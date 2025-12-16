# 🧪 Guía de Pruebas

Este documento describe cómo probar que todo el stack está funcionando correctamente.

## ✅ Checklist de Verificación

### 1. Servicios Docker

```bash
# Verificar que todos los contenedores están corriendo
docker compose ps
```

Deberías ver 3 servicios corriendo:
- `backend` - Estado: Up
- `frontend` - Estado: Up  
- `db` - Estado: Up

### 2. Base de Datos PostgreSQL

```bash
# Conectarse a PostgreSQL
docker compose exec db psql -U postgres -d proyecto_db

# Dentro de psql, verificar las tablas
\dt

# Salir
\q
```

Deberías ver las tablas de Laravel:
- `cache`
- `cache_locks`
- `failed_jobs`
- `job_batches`
- `jobs`
- `migrations`
- `password_reset_tokens`
- `sessions`
- `users`

### 3. Backend Laravel

```bash
# Ver logs del backend
docker compose logs -f backend
```

Deberías ver:
- ✅ PostgreSQL está listo
- ✅ Migraciones ejecutadas
- ✅ Backend listo
- ✅ Server started on [http://0.0.0.0:8000]

#### Probar endpoint de API

```bash
# Desde tu terminal
curl http://localhost:8000/api/test
```

Deberías recibir:
```json
{
  "message": "¡Backend Laravel funcionando correctamente!",
  "database": "Conectado a PostgreSQL ✓",
  "timestamp": "2024-12-16 ...",
  "environment": "local"
}
```

#### Acceder desde el navegador
- Abre: http://localhost:8000
- Deberías ver la página de bienvenida de Laravel

- Abre: http://localhost:8000/api/test
- Deberías ver la respuesta JSON

### 4. Frontend Vue

```bash
# Ver logs del frontend
docker compose logs -f frontend
```

Deberías ver:
- ✅ Frontend listo
- ✅ VITE ready in XXX ms
- ✅ Local: http://localhost:5173/

#### Acceder desde el navegador
- Abre: http://localhost:5173
- Deberías ver la aplicación Vue con:
  - Título: "🚀 Proyecto Laravel + PostgreSQL + Vue TypeScript"
  - Estado de Conexión Backend: "Conectado ✓" (en verde)
  - Respuesta del Backend mostrando el JSON

### 5. Comunicación Frontend-Backend

En la interfaz web (http://localhost:5173):
1. Verifica que el estado muestra "Conectado ✓"
2. Verifica que se muestra la respuesta JSON del backend
3. Haz clic en "🔄 Reintentar Conexión"
4. El estado debería actualizarse correctamente

## 🐛 Problemas Comunes

### Backend no inicia
```bash
# Ver logs detallados
docker compose logs backend

# Posibles causas:
# - PostgreSQL no está listo aún → Esperar más tiempo
# - Error en migraciones → Revisar logs
# - Falta APP_KEY → Regenerar con: docker compose exec backend php artisan key:generate
```

### Frontend no se conecta al backend
```bash
# Verificar que el backend esté corriendo
curl http://localhost:8000/api/test

# Verificar configuración CORS
docker compose exec backend cat config/cors.php

# Verificar logs del frontend
docker compose logs frontend
```

### Base de datos no conecta
```bash
# Verificar que PostgreSQL está corriendo
docker compose ps db

# Intentar conectarse manualmente
docker compose exec db psql -U postgres -d proyecto_db

# Verificar variables de entorno
docker compose exec backend php artisan config:show database
```

### Puerto ya en uso
```bash
# Ver qué proceso usa el puerto 8000
lsof -i :8000

# Ver qué proceso usa el puerto 5173
lsof -i :5173

# Ver qué proceso usa el puerto 5432
lsof -i :5432

# Detener servicios Docker y reintentar
docker compose down
docker compose up -d
```

## 🔄 Resetear Todo

Si necesitas empezar de cero:

```bash
# Detener y eliminar todo (incluyendo datos de BD)
docker compose down -v

# Eliminar imágenes
docker compose down --rmi all

# Limpiar todo el sistema Docker (opcional, afecta otros proyectos)
docker system prune -a --volumes

# Iniciar de nuevo
./setup.sh
```

## 📊 Métricas de Éxito

El proyecto está funcionando correctamente cuando:

- ✅ Todos los contenedores están en estado "Up"
- ✅ Backend responde en http://localhost:8000
- ✅ API responde en http://localhost:8000/api/test
- ✅ Frontend carga en http://localhost:5173
- ✅ Frontend muestra "Conectado ✓" en verde
- ✅ Se visualiza la respuesta JSON del backend en el frontend
- ✅ PostgreSQL acepta conexiones
- ✅ Las migraciones de Laravel se ejecutaron correctamente

## 🧪 Pruebas Adicionales

### Probar creación de controlador
```bash
docker compose exec backend php artisan make:controller TestController
# Verificar que se creó: backend/app/Http/Controllers/TestController.php
```

### Probar creación de modelo
```bash
docker compose exec backend php artisan make:model Product -m
# Verificar que se crearon:
# - backend/app/Models/Product.php
# - backend/database/migrations/YYYY_MM_DD_HHMMSS_create_products_table.php
```

### Probar instalación de paquete npm
```bash
docker compose exec frontend npm install lodash
# Verificar que se actualizó frontend/package.json
```

## 📝 Logs Útiles

### Ver todos los logs
```bash
docker compose logs
```

### Seguir logs en tiempo real
```bash
docker compose logs -f
```

### Ver logs específicos
```bash
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db
```

### Ver últimas 100 líneas
```bash
docker compose logs --tail=100 backend
```

## 🎯 Siguiente Paso

Una vez que todas las pruebas pasen exitosamente, estás listo para:
1. Empezar a desarrollar nuevas funcionalidades
2. Agregar rutas y controladores en Laravel
3. Crear nuevos componentes en Vue
4. Implementar autenticación
5. Construir tu aplicación

¡Feliz desarrollo! 🚀
