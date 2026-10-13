FROM composer:2.8.12 AS composer
FROM php:8.3.26-apache-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" gd zip mysqli curl \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
# Official tag 4.1.0.4, commit 3b0597ec91cae3de040a63fee3834a6d910372ea.
# Version and checksum intentionally cannot be overridden with build arguments.
RUN curl -fL --retry 3 https://codeload.github.com/opencart/opencart/tar.gz/refs/tags/4.1.0.4 -o /tmp/opencart.tar.gz \
    && echo 'af8a2b2a0eea788aabfd10fa2b22e52153a01d72377aa3ffebe500cce039765a  /tmp/opencart.tar.gz' | sha256sum -c - \
    && mkdir /tmp/opencart \
    && tar -xzf /tmp/opencart.tar.gz --strip-components=1 -C /tmp/opencart \
    && cd /tmp/opencart \
    && composer install --no-dev --prefer-dist --no-interaction --no-progress --optimize-autoloader \
    && cp -a upload/. /var/www/html/ \
    && php -r 'if (!str_contains(file_get_contents("/var/www/html/index.php"), "define(" . chr(39) . "VERSION" . chr(39) . ", " . chr(39) . "4.1.0.4" . chr(39) . ");")) { exit(1); }' \
    && cp /var/www/html/.htaccess.txt /var/www/html/.htaccess \
    && cp /var/www/html/config-dist.php /var/www/html/config.php \
    && cp /var/www/html/admin/config-dist.php /var/www/html/admin/config.php \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /tmp/opencart /tmp/opencart.tar.gz

COPY apache.conf /etc/apache2/conf-enabled/opencart.conf
COPY entrypoint.sh /usr/local/bin/opencart-entrypoint
COPY check-db.php /usr/local/bin/opencart-check-db.php
RUN chmod +x /usr/local/bin/opencart-entrypoint
LABEL org.opencontainers.image.version="4.1.0.4" \
      org.opencontainers.image.revision="3b0597ec91cae3de040a63fee3834a6d910372ea"
WORKDIR /var/www/html
ENTRYPOINT ["opencart-entrypoint"]
CMD ["apache2-foreground"]
