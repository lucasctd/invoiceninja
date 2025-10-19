# Use a imagem base do PHP 8.4 FPM Alpine
FROM php:8.4-fpm-alpine

# Define o diretório de trabalho
WORKDIR /var/www

# Instala dependências do sistema, incluindo o supervisor
RUN apk add --no-cache --update \
    curl \
    openssl \
    build-base \
    autoconf \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    freetype-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    bash \
    fcgi \
    libmcrypt-dev \
    icu-dev \
    oniguruma-dev \
    supervisor

# Limpa o cache do apk
RUN rm -rf /var/cache/apk/*

RUN pecl install redis && docker-php-ext-enable redis

# Instala extensões do PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql mbstring zip exif pcntl bcmath opcache intl

 RUN echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/custom.ini

# Instala o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia o conteúdo da aplicação
COPY --chown=www-data:www-data . .
COPY ./docker-prod/php-fpm/ping.php /ping.php
COPY .env.docker .env
COPY ./docker-prod/php-fpm/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /ping.php
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chown -R www-data:www-data /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Configuração do Supervisor e Cron
# Copia a configuração do supervisor
COPY ./docker-prod/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Copia o arquivo crontab do Laravel para o diretório de crontabs
COPY ./docker-prod/cron/laravel.crontab /etc/crontabs/www-data

# Garante que o usuário www-data seja o dono do arquivo crontab
RUN chown www-data:www-data /etc/crontabs/www-data

# Instala as dependências do Composer como usuário root
# O usuário será trocado para www-data dentro do supervisor quando necessário
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

RUN chown -R www-data:www-data ./vendor

# Ajusta permissões dos arquivos para 644
RUN find /var/www -type f -exec chmod 644 {} \;

# Ajusta permissões dos diretórios para 755
RUN find /var/www -type d -exec chmod 755 {} \;

# Expõe a porta 9000 para o php-fpm
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# Inicia o supervisor, que por sua vez gerenciará o php-fpm e o cron
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]