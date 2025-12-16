#!/bin/sh
set -e

echo "🚀 Iniciando configuración del frontend Vue..."

# Instalar dependencias si no existen
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias de npm..."
    npm install
fi

echo "✅ Frontend listo!"

# Iniciar servidor de desarrollo
exec npm run dev
