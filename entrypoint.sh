#!/bin/bash
set -e

echo "--- Start Entrypoint ---"

# 1. КОПИРОВАНИЕ ФАЙЛОВ
# Проверяем наличие папки components как признак того, что файлы ядра есть
if [ ! -d "/var/www/html/components" ]; then
    echo "Joomla core files missing. Copying from source..."
    cp -rp /usr/src/joomla/. /var/www/html/
    echo "Files copied."
else
    # Если ядро есть, но нет папки установки и конфига — восстанавливаем installation
    if [ ! -f "/var/www/html/configuration.php" ] && [ ! -d "/var/www/html/installation" ]; then
        echo "Restoring installation folder..."
        cp -rp /usr/src/joomla/installation /var/www/html/
    fi
fi

# Чиним права
chown -R www-data:www-data /var/www/html

# 2. ОЖИДАНИЕ БАЗЫ
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

# 3. ПОИСК СКРИПТА КОНСОЛИ (Самая важная часть)
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

# 4. УСТАНОВКА JOOMLA
if [ ! -f "/var/www/html/configuration.php" ]; then
    echo "Installing Joomla via CLI..."
    
    # Если скрипт не найден, выводим отладку и падаем
    if [ -z "$CLI_SCRIPT" ]; then
        echo "CRITICAL ERROR: Could not find 'joomla' (root) or 'cli/joomla.php'!"
        echo "--- Debug: Content of 'cli' directory ---"
        ls -la cli/
        echo "-----------------------------------------"
        exit 1
    fi

    # Если скрипт не найден, выводим отладку и падаем
    if [ -z "$INSTALL_CLI_SCRIPT" ]; then
        echo "CRITICAL ERROR: Could not find 'joomla' (root) or 'installation/joomla.php'!"
        echo "--- Debug: Content of 'installation' directory ---"
        ls -la installation/
        echo "-----------------------------------------"
        exit 1
    fi

    # Запуск установки
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

    # !!! ГЛАВНАЯ ПРОВЕРКА !!!
    if [ ! -f "/var/www/html/configuration.php" ]; then
        echo "CRITICAL ERROR: 'configuration.php' was not created after installation attempt!"
        echo "This means the installation failed silently or permission denied."
        exit 1
    else
        echo "SUCCESS: configuration.php created."
    fi

    # 5. УСТАНОВКА VIRTUEMART
    VM_PATH="/usr/src/extensions/virtuemart"
    CORE_PKG=$(find $VM_PATH -name "com_virtuemart*.zip" | grep -v "aio" | head -n 1)
    AIO_PKG=$(find $VM_PATH -name "com_virtuemart*aio*.zip" | head -n 1)

    # if [ -f "$CORE_PKG" ]; then
    #     echo "Installing VM Core: $CORE_PKG"
    #     php "$CLI_SCRIPT" extension:install --path="$CORE_PKG" || echo "VM Core install warning"
    # fi

    # if [ -f "$AIO_PKG" ]; then
    #     echo "Installing VM AIO: $AIO_PKG"
    #     php "$CLI_SCRIPT" extension:install --path="$AIO_PKG" || echo "VM AIO install warning"
    # fi

    cp $CORE_PKG /var/www/html/tmp/
    cp $AIO_PKG /var/www/html/tmp/

    # 6. ЗАЧИСТКА
    echo "Removing installation folder..."
    rm -rf /var/www/html/installation
    
    chown -R www-data:www-data /var/www/html
fi

echo "Entrypoint finished. Starting Apache..."
exec "$@"
