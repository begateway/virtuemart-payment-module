FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev \
    unzip \
    wget \
    default-mysql-client \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) mysqli pdo_mysql gd zip intl

RUN a2enmod rewrite

WORKDIR /var/www/html

ARG JOOMLA_URL="https://github.com/joomla/joomla-cms/releases/download/5.2.2/Joomla_5.2.2-Stable-Full_Package.zip"
ARG VM_URL="https://dev.virtuemart.net/attachments/download/1406/com_virtuemart.4.6.4.11226_package_or_extract.zip"

RUN mkdir -p /usr/src/joomla && \
    wget -O /tmp/joomla.zip "$JOOMLA_URL" && \
    unzip /tmp/joomla.zip -d /usr/src/joomla && \
    rm /tmp/joomla.zip

RUN mkdir -p /usr/src/extensions/virtuemart && \
    wget -O /tmp/vm.zip "$VM_URL" && \
    unzip /tmp/vm.zip -d /usr/src/extensions/virtuemart && \
    rm /tmp/vm.zip

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
