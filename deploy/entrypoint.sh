#!/bin/sh
set -eu
cd /var/www/html
if [ ! -f .installed-4.1.0.4 ]; then
    php /usr/local/bin/opencart-check-db.php
    case "$OPENCART_URL" in
        http://*/|https://*/) ;;
        *) echo 'OPENCART_URL must be an absolute HTTP(S) URL ending in /' >&2; exit 1 ;;
    esac
    case "$OPENCART_URL" in
        *"'"*) echo 'OPENCART_URL cannot contain a quote' >&2; exit 1 ;;
    esac
    output=$(php install/cli_install.php install \
        --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --email "$ADMIN_EMAIL" \
        --http_server "$OPENCART_URL" --language en-gb \
        --db_driver mysqli --db_hostname db --db_username "$DB_USER" \
        --db_password "$DB_PASSWORD" --db_database "$DB_NAME" --db_port 3306 --db_prefix oc_)
    printf '%s\n' "$output"
    case "$output" in
        *'SUCCESS! OpenCart successfully installed on your server'*) ;;
        *) echo 'OpenCart installation failed' >&2; exit 1 ;;
    esac
    touch .installed-4.1.0.4
    chown -R www-data:www-data /var/www/html
fi
exec docker-php-entrypoint "$@"
