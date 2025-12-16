#!/bin/bash
set -e

echo "🚀 Iniciando configuración del backend Laravel..."

# Esperar a que PostgreSQL esté listo
echo "⏳ Esperando a PostgreSQL..."
until pg_isready -h db -p 5432 -U postgres; do
  echo "PostgreSQL no está listo aún, esperando..."
  sleep 2
done

echo "✅ PostgreSQL está listo!"

# Instalar dependencias si no existen
if [ ! -d "vendor" ]; then
    echo "📦 Instalando dependencias de Composer..."
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

# Generar key si no existe
if grep -q "APP_KEY=$" .env || ! grep -q "APP_KEY=" .env; then
    echo "🔑 Generando clave de aplicación..."
    php artisan key:generate --force
fi

# Ejecutar migraciones
echo "🗄️  Ejecutando migraciones..."
php artisan migrate --force

# Limpiar caché
echo "🧹 Limpiando caché..."
php artisan config:clear
php artisan cache:clear

echo "✅ Backend listo!"

# Iniciar servidor
exec php artisan serve --host=0.0.0.0 --port=8000
