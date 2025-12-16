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
docker compose up -d --build

# Esperar a que los servicios estén listos
echo -e "${YELLOW}⏳ Esperando que los servicios estén listos...${NC}"
echo "Los contenedores se están inicializando automáticamente..."
echo "Esto puede tomar unos minutos la primera vez."
sleep 60

echo ""
echo -e "${GREEN}✅ ¡Configuración completada!${NC}"
echo ""
echo "🌐 Los servicios deberían estar disponibles en:"
echo "   - Frontend (Vue): http://localhost:5173"
echo "   - Backend (Laravel): http://localhost:8000"
echo "   - API Test: http://localhost:8000/api/test"
echo ""
echo "📝 Para ver los logs: docker compose logs -f"
echo "🛑 Para detener: docker compose down"
echo ""
echo "⚠️  Si los servicios aún no están listos, verifica los logs:"
echo "   docker compose logs -f backend"
echo "   docker compose logs -f frontend"
echo ""
