FROM php:8.4.2

WORKDIR /app

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
RUN docker-php-ext-install pdo_pgsql zip exif pcntl bcmath gd intl xml

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# El código se montará como volumen, no lo copiamos aquí
# Esto permite desarrollo en vivo

EXPOSE 8000

# El comando se especificará en docker-compose.yaml


