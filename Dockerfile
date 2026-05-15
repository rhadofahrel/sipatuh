FROM dunglas/frankenphp:php8.2

# Install PHP extensions
RUN install-php-extensions \
    gd \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath

# Install Composer (INI YANG KEMARIN KURANG)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy semua file
COPY . .

# Install dependencies Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Install Node.js + build assets
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install && npm run build

# Permission Laravel
RUN mkdir -p storage/framework/{sessions,views,cache} \
    && chmod -R 777 storage bootstrap/cache

# Run app
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]