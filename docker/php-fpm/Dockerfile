FROM php:8.4-fpm-alpine

# Set working directory
WORKDIR /var/www

# Install system dependencies
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
    oniguruma-dev

# Clear cache
RUN rm -rf /var/cache/apk/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents

COPY --chown=www-data:www-data . .
COPY ./docker/php-fpm/ping.php /ping.php
COPY .env.docker .env
COPY ./docker/php-fpm/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /ping.php
RUN chmod +x /usr/local/bin/entrypoint.sh

# Instala dependências do composer como www-data
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Change current user to www
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]
