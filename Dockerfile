FROM dunglas/frankenphp:php8.4

RUN apt-get update && apt-get install -y wget

RUN install-php-extensions \
    pdo_mysql \
    mbstring \
    bcmath \
    intl \
    zip \
    gd \
    opcache

WORKDIR /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction

RUN mkdir -p storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views

RUN chmod -R 775 storage bootstrap/cache || true

RUN cp .env.example .env || true

EXPOSE 80

CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port=80"]