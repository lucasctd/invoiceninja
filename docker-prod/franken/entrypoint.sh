#!/bin/sh
set -e

echo "Running entrypoint script..."

echo "Optimizing Laravel application..."

# Executa os comandos de otimização como o usuário 'www-data'
su www-data -s /bin/sh -c "php artisan config:cache"
su www-data -s /bin/sh -c "php artisan route:cache"
su www-data -s /bin/sh -c "php artisan view:cache"

echo "Optimization completed. Handing over to CMD..."

# Executa o CMD principal do Dockerfile (que no nosso caso é o supervisord)
exec "$@"
