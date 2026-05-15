FROM dunglas/frankenphp:php8.2

# Install PHP extensions (INI KUNCI UTAMA)
RUN install-php-extensions \
    gd \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath

# Set working directory
WORKDIR /app

# Copy semua file
COPY . .

# Install composer deps
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Install node & build
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install && npm run build

# Laravel permissions
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && chmod -R 777 storage bootstrap/cache

# Run Laravel
CMD php artisan serve --host=0.0.0.0 --port=8080