#!/bin/bash

# Script de configuración inicial del proyecto
# Este script automatiza los pasos de configuración descritos en el README

set -e

echo "🚀 Iniciando configuración del proyecto Laravel + PostgreSQL + Vue TypeScript..."
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Construir y levantar contenedores
echo -e "${YELLOW}📦 Paso 1: Construyendo y levantando contenedores...${NC}"
docker-compose up -d --build

# Esperar a que los servicios estén listos
echo -e "${YELLOW}⏳ Esperando que los servicios estén listos...${NC}"
sleep 10

# 2. Instalar dependencias del backend
echo -e "${YELLOW}📦 Paso 2: Instalando dependencias del backend...${NC}"
docker-compose exec -T backend composer install --no-interaction

# 3. Generar key de Laravel
echo -e "${YELLOW}🔑 Paso 3: Generando clave de aplicación Laravel...${NC}"
docker-compose exec -T backend php artisan key:generate --force

# 4. Ejecutar migraciones
echo -e "${YELLOW}🗄️  Paso 4: Ejecutando migraciones de base de datos...${NC}"
sleep 5  # Esperar un poco más para que PostgreSQL esté completamente listo
docker-compose exec -T backend php artisan migrate --force

# 5. Instalar dependencias del frontend
echo -e "${YELLOW}📦 Paso 5: Instalando dependencias del frontend...${NC}"
docker-compose exec -T frontend npm install

echo ""
echo -e "${GREEN}✅ ¡Configuración completada exitosamente!${NC}"
echo ""
echo "🌐 Los servicios están disponibles en:"
echo "   - Frontend (Vue): http://localhost:5173"
echo "   - Backend (Laravel): http://localhost:8000"
echo "   - API Test: http://localhost:8000/api/test"
echo ""
echo "📝 Para ver los logs: docker-compose logs -f"
echo "🛑 Para detener: docker-compose down"
echo ""
