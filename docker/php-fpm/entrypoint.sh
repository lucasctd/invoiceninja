#!/bin/sh
set -e

git config --global --add safe.directory /var/www

composer dump-autoload --optimize

php artisan config:cache
php artisan route:cache
php artisan view:cache

exec "$@"