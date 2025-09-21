#!/bin/sh
set -e

composer dump-autoload --optimize

php artisan config:cache
php artisan route:cache
php artisan view:cache

exec "$@"