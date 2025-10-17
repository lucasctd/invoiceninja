# Use a imagem base do PHP 8.4 FPM Alpine
FROM php:8.4-fpm-alpine

# Define o diretório de trabalho
WORKDIR /var/www

# Instala dependências do sistema, incluindo o supervisor
RUN apk add --no-cache --update \
    curl \
    openssl \
    build-base \
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
    oniguruma-dev \
    supervisor # Adicionado o supervisor

# Limpa o cache do apk
RUN rm -rf /var/cache/apk/*

# Instala extensões do PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath opcache

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

# Expõe a porta 9000 para o php-fpm
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# Inicia o supervisor, que por sua vez gerenciará o php-fpm e o cron
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]