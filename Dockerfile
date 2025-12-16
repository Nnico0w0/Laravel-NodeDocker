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
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory /app

# Instalar extensiones PHP
RUN docker-php-ext-install pdo_pgsql zip exif pcntl bcmath gd intl xml

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# El código se montará como volumen, no lo copiamos aquí
# Esto permite desarrollo en vivo

EXPOSE 8000

# Copiar el entrypoint script
COPY backend/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]


