# ⚡ Inicio Rápido - Quick Start

Esta es una guía rápida de 5 minutos para poner en marcha el proyecto.

## 🚀 Pasos Rápidos

### 1. Clonar y entrar al directorio
```bash
git clone <url-del-repositorio>
cd Laravel-NodeDocker
```

### 2. Levantar el proyecto (Opción Automática)
```bash
./setup.sh
```

**¡Eso es todo!** El script hace todo automáticamente:
- ✅ Construye los contenedores Docker
- ✅ Instala dependencias del backend y frontend
- ✅ Configura Laravel
- ✅ Ejecuta las migraciones de base de datos
- ✅ Inicia todos los servicios

### 3. Verificar que funciona

Abre tu navegador en:
- **Frontend**: http://localhost:5173
  - Deberías ver la interfaz Vue con estado "Conectado ✓"
  
- **Backend**: http://localhost:8000/api/test
  - Deberías ver una respuesta JSON

## 🔧 Comandos Esenciales

```bash
# Ver estado de los contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Detener todo
docker compose down

# Reiniciar servicios
docker compose restart
```

## 📁 Estructura de Carpetas

```
Laravel-NodeDocker/
├── backend/          # 🔴 Laravel (API Backend)
├── frontend/         # 🟢 Vue + TypeScript (Frontend)
└── data/            # 🗄️ Base de datos PostgreSQL (no versionado)
```

## ✏️ Empezar a Desarrollar

### Agregar una nueva ruta en el backend
```bash
# Crear controlador
docker compose exec backend php artisan make:controller MiController

# Editar: backend/routes/api.php
# Agregar: Route::get('/mi-ruta', [MiController::class, 'index']);
```

### Agregar un nuevo componente en el frontend
```bash
# Crear archivo: frontend/src/components/MiComponente.vue
# Importarlo en: frontend/src/App.vue
```

## 🆘 Problemas Comunes

### No funciona el backend
```bash
# Ver qué pasó
docker compose logs backend

# Reintentar
docker compose restart backend
```

### No funciona el frontend
```bash
# Ver qué pasó
docker compose logs frontend

# Reintentar
docker compose restart frontend
```

### Empezar de cero
```bash
docker compose down -v
./setup.sh
```

## 📚 Más Información

- **README.md** - Documentación completa
- **ARCHITECTURE.md** - Diseño del sistema
- **TESTING.md** - Guía de pruebas

## 🎯 URLs Importantes

| Servicio | URL | Descripción |
|----------|-----|-------------|
| Frontend | http://localhost:5173 | Interfaz Vue |
| Backend | http://localhost:8000 | API Laravel |
| API Test | http://localhost:8000/api/test | Endpoint de prueba |
| PostgreSQL | localhost:5432 | Base de datos |

**Usuario DB**: `postgres` / **Password**: `postgres` / **Database**: `proyecto_db`

---

¡Listo para empezar a desarrollar! 🎉
