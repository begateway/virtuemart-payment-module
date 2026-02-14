#!/bin/bash
set -e

echo "--- Start Entrypoint ---"

# 1. Copy files
if [ ! -d "/var/www/html/components" ]; then
    echo "Joomla core files missing. Copying from source..."
    cp -rp /usr/src/joomla/. /var/www/html/
    echo "Files copied."
else
    if [ ! -f "/var/www/html/configuration.php" ] && [ ! -d "/var/www/html/installation" ]; then
        echo "Restoring installation folder..."
        cp -rp /usr/src/joomla/installation /var/www/html/
    fi
fi

chown -R www-data:www-data /var/www/html

# 2. Wait for DB
echo "Waiting for Database connection to $DB_HOST..."
max_tries=30
counter=0
while ! mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --skip-ssl -e "SELECT 1" >/dev/null 2>&1; do
    counter=$((counter+1))
    if [ $counter -gt $max_tries ]; then
        echo "Error: Database timed out."
        mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --skip-ssl -e "SELECT 1"
        exit 1
    fi
    echo "Waiting for database... ($counter/$max_tries)"
    sleep 2
done
echo "Database connection established!"

# 3. Search for CLI script (The most important part)
CLI_SCRIPT=""

if [ -f "./joomla" ]; then
    CLI_SCRIPT="./joomla"
    echo "Found CLI script at: ./joomla"
elif [ -f "./cli/joomla.php" ]; then
    CLI_SCRIPT="./cli/joomla.php"
    echo "Found CLI script at: ./cli/joomla.php"
fi

INSTALL_CLI_SCRIPT=""

if [ -f "./joomla" ]; then
    INSTALL_CLI_SCRIPT="./joomla"
    echo "Found INSTALL CLI script at: ./joomla"
elif [ -f "./installation/joomla.php" ]; then
    INSTALL_CLI_SCRIPT="./installation/joomla.php"
    echo "Found INSTALL CLI script at: ./installation/joomla.php"
fi

# 4. INSTALL JOOMLA
if [ ! -f "/var/www/html/configuration.php" ]; then
    echo "Installing Joomla via CLI..."
    
    if [ -z "$CLI_SCRIPT" ]; then
        echo "CRITICAL ERROR: Could not find 'joomla' (root) or 'cli/joomla.php'!"
        echo "--- Debug: Content of 'cli' directory ---"
        ls -la cli/
        echo "-----------------------------------------"
        exit 1
    fi

    if [ -z "$INSTALL_CLI_SCRIPT" ]; then
        echo "CRITICAL ERROR: Could not find 'joomla' (root) or 'installation/joomla.php'!"
        echo "--- Debug: Content of 'installation' directory ---"
        ls -la installation/
        echo "-----------------------------------------"
        exit 1
    fi

    php "$INSTALL_CLI_SCRIPT" install \
        --db-type="mysqli" \
        --db-host="$DB_HOST" \
        --db-user="$DB_USER" \
        --db-pass="$DB_PASSWORD" \
        --db-name="$DB_NAME" \
        --db-prefix="jos_" \
        --db-encryption="0" \
        --site-name="Joomla Dev Docker" \
        --admin-user="admin" \
        --admin-username="admin" \
        --admin-password="adminpassword" \
        --admin-email="admin@example.com" || { echo "JOOMLA INSTALLATION FAILED!"; exit 1; }

    echo "Joomla installed successfully."

    if [ ! -f "/var/www/html/configuration.php" ]; then
        echo "CRITICAL ERROR: 'configuration.php' was not created after installation attempt!"
        echo "This means the installation failed silently or permission denied."
        exit 1
    else
        echo "SUCCESS: configuration.php created."
    fi

    # 5. Copy VIRTUEMART PACKAGES to tmp folder for manual installation
    VM_PATH="/usr/src/extensions/virtuemart"

    cp $VM_PATH/* /var/www/html/tmp/

    # 6. ЗАЧИСТКА
    echo "Removing installation folder..."
    rm -rf /var/www/html/installation
    
    chown -R www-data:www-data /var/www/html
fi

echo "Entrypoint finished. Starting Apache..."
exec "$@"
