#!/bin/sh
set -e

echo "Running entrypoint script..."

# Define o diretório como seguro para o git
git config --global --add safe.directory /var/www

# Garante que o usuário www-data seja o dono dos diretórios de cache e storage
# Isso previne problemas de permissão ao rodar os comandos artisan
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

echo "Optimizing Laravel application..."

# Executa os comandos de otimização como o usuário 'www-data'
su www-data -s /bin/sh -c "composer dump-autoload --optimize"
su www-data -s /bin/sh -c "php artisan config:cache"
su www-data -s /bin/sh -c "php artisan route:cache"
su www-data -s /bin/sh -c "php artisan view:cache"

echo "Optimization complete. Handing over to CMD..."

# Executa o CMD principal do Dockerfile (que no nosso caso é o supervisord)
exec "$@"
