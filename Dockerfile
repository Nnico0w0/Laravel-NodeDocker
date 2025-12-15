FROM php:8.4.2
WORKDIR /app
ARG WWWGROUP

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y \
    git \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    libpq-dev \
    libxml2-dev \
    pkg-config \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory /app

# Instalar extensiones PHP
RUN docker-php-ext-install pdo_mysql pdo_pgsql zip exif pcntl bcmath gd intl xml

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer self-update
RUN composer --version
COPY ./backend /app
RUN composer install
EXPOSE 8000


