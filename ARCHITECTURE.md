# 🏗️ Arquitectura del Proyecto

Este documento describe la arquitectura y estructura del proyecto Laravel + PostgreSQL + Vue TypeScript.

## 📊 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                        Docker Host                           │
│                                                               │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐ │
│  │   Frontend     │  │    Backend     │  │   Database     │ │
│  │   (Vue + TS)   │  │   (Laravel)    │  │  (PostgreSQL)  │ │
│  │                │  │                │  │                │ │
│  │  Port: 5173    │  │  Port: 8000    │  │  Port: 5432    │ │
│  │  Vite Dev      │◄─┤  PHP Artisan   │◄─┤  PostgreSQL    │ │
│  │  Server        │  │  Serve         │  │  16.6          │ │
│  └────────────────┘  └────────────────┘  └────────────────┘ │
│         │                    │                    │          │
│         └────────────────────┴────────────────────┘          │
│                    Network: application                      │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Flujo de Comunicación

1. **Usuario → Frontend (Puerto 5173)**
   - El navegador accede a `http://localhost:5173`
   - Vite sirve la aplicación Vue con hot-reload

2. **Frontend → Backend (Puerto 8000)**
   - El frontend hace peticiones HTTP a `http://localhost:8000/api`
   - Las peticiones pasan a través de axios configurado en `frontend/src/services/api.ts`

3. **Backend → Base de Datos (Puerto 5432)**
   - Laravel se conecta a PostgreSQL usando el hostname `db`
   - La conexión está configurada en `backend/.env`

## 📁 Estructura de Archivos Clave

### Raíz del Proyecto
```
.
├── backend/                    # Aplicación Laravel
├── frontend/                   # Aplicación Vue
├── data/                       # Datos persistentes de PostgreSQL (no versionado)
├── docker-compose.yaml         # Configuración base de Docker
├── docker-compose.override.yml # Configuración de desarrollo (puertos, volúmenes)
├── Dockerfile                  # Imagen Docker para backend
├── Dockerfile.frontend         # Imagen Docker para frontend
├── .env                        # Variables de entorno compartidas
├── setup.sh                    # Script de configuración automática
└── README.md                   # Documentación principal
```

### Backend (Laravel)
```
backend/
├── app/                        # Lógica de la aplicación
│   ├── Http/
│   │   └── Controllers/        # Controladores
│   └── Models/                 # Modelos Eloquent
├── routes/
│   ├── api.php                 # Rutas de API (/api/*)
│   └── web.php                 # Rutas web
├── config/
│   ├── cors.php                # Configuración CORS
│   └── database.php            # Configuración de base de datos
├── database/
│   └── migrations/             # Migraciones de base de datos
├── docker-entrypoint.sh        # Script de inicialización automática
├── .env                        # Variables de entorno del backend
└── composer.json               # Dependencias PHP
```

### Frontend (Vue)
```
frontend/
├── src/
│   ├── components/             # Componentes Vue
│   ├── services/
│   │   └── api.ts              # Cliente Axios configurado
│   ├── App.vue                 # Componente principal
│   └── main.ts                 # Punto de entrada
├── docker-entrypoint.sh        # Script de inicialización automática
├── .env                        # Variables de entorno del frontend
├── vite.config.ts              # Configuración de Vite
└── package.json                # Dependencias npm
```

## 🔧 Configuración de Docker

### docker-compose.yaml
Define los tres servicios principales:
- **backend**: Construido desde `Dockerfile`
- **frontend**: Construido desde `Dockerfile.frontend`
- **db**: Imagen oficial de PostgreSQL

### docker-compose.override.yml
Configuración específica para desarrollo:
- Expone puertos al host
- Monta volúmenes para desarrollo en vivo
- Los cambios en el código se reflejan inmediatamente

### Entrypoint Scripts
Cada servicio tiene un script de inicialización que:
- **Backend**: Instala dependencias, genera key, ejecuta migraciones
- **Frontend**: Instala dependencias npm

## 🌐 Endpoints de API

### Backend (Laravel)

#### `GET /api/test`
Endpoint de prueba que verifica:
- Estado del backend
- Conexión a PostgreSQL
- Variables de entorno

**Respuesta:**
```json
{
  "message": "¡Backend Laravel funcionando correctamente!",
  "database": "Conectado a PostgreSQL ✓",
  "timestamp": "2024-12-16 00:00:00",
  "environment": "local"
}
```

## 🔐 Variables de Entorno

### Archivo `.env` (raíz)
Variables compartidas para Docker Compose:
- `DOCKERFILE`: Dockerfile a usar para backend
- `APP_EXPOSE_PORT`: Puerto externo del backend (8000)
- `DB_EXPOSE_PORT`: Puerto externo de PostgreSQL (5432)
- `POSTGRES_*`: Configuración de PostgreSQL

### Backend `.env`
- `DB_CONNECTION=pgsql`
- `DB_HOST=db` (nombre del servicio en Docker)
- `DB_PORT=5432`
- `DB_DATABASE=proyecto_db`
- `DB_USERNAME=postgres`
- `DB_PASSWORD=postgres`

### Frontend `.env`
- `VITE_API_URL=http://localhost:8000/api`

## 🚀 Proceso de Inicialización

### Orden de inicio
1. **PostgreSQL** inicia primero (definido en `depends_on`)
2. **Backend** espera a PostgreSQL con `pg_isready`
3. **Frontend** inicia cuando está listo

### Inicialización automática

#### Backend
1. Espera a PostgreSQL
2. Instala dependencias Composer (si no existen)
3. Genera APP_KEY de Laravel
4. Ejecuta migraciones
5. Inicia servidor con `php artisan serve`

#### Frontend
1. Instala dependencias npm (si no existen)
2. Inicia servidor de desarrollo Vite

## 🔒 Seguridad

### CORS
- Configurado en `backend/config/cors.php`
- Permite todas las origenes en desarrollo (`allowed_origins: ['*']`)
- Para producción, restringir a dominios específicos

### Base de Datos
- Credenciales en archivo `.env`
- No exponer en producción el puerto 5432
- Usar contraseñas seguras en producción

## 📝 Notas de Desarrollo

### Hot Reload
- **Frontend**: Vite detecta cambios automáticamente
- **Backend**: Laravel se reinicia en cada petición (modo desarrollo)

### Persistencia de Datos
- PostgreSQL almacena datos en `./data/`
- Este directorio está en `.gitignore`
- Para resetear la BD: `docker compose down -v`

### Logs
Ver logs de cada servicio:
```bash
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db
```

## 🔄 Ciclo de Desarrollo Típico

1. **Iniciar servicios**
   ```bash
   docker compose up -d
   ```

2. **Hacer cambios en el código**
   - Backend: Editar archivos en `backend/`
   - Frontend: Editar archivos en `frontend/`
   - Los cambios se reflejan automáticamente

3. **Ver logs si hay errores**
   ```bash
   docker compose logs -f backend
   ```

4. **Ejecutar migraciones si hay cambios en BD**
   ```bash
   docker compose exec backend php artisan migrate
   ```

5. **Detener servicios**
   ```bash
   docker compose down
   ```

## 🎯 Próximos Pasos

Para extender el proyecto, considera:
- Agregar autenticación (Laravel Sanctum)
- Implementar más endpoints de API
- Agregar pruebas unitarias y de integración
- Configurar Vue Router para múltiples páginas
- Agregar gestión de estado (Pinia)
- Configurar CI/CD
- Preparar para producción (optimización, seguridad)
