# 🚀 Proyecto Laravel + PostgreSQL + Vue TypeScript

Este proyecto es una aplicación full-stack que incluye:
- **Backend**: Laravel 12.x con PHP 8.4
- **Base de datos**: PostgreSQL 16.6
- **Frontend**: Vue 3 con TypeScript y Vite

Todo configurado con Docker para facilitar el desarrollo y despliegue.

> 💡 **¿Primera vez aquí?** Lee la [Guía de Inicio Rápido (QUICKSTART.md)](QUICKSTART.md) para poner en marcha el proyecto en 5 minutos.

## 📚 Documentación

- **[QUICKSTART.md](QUICKSTART.md)** - Inicio rápido en 5 minutos
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Arquitectura y diseño del sistema
- **[TESTING.md](TESTING.md)** - Guía de pruebas y verificación
- **README.md** (este archivo) - Documentación completa

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:
- [Docker](https://docs.docker.com/get-docker/) (versión 20.10 o superior)
- [Docker Compose](https://docs.docker.com/compose/install/) (versión 2.0 o superior)

## 🛠️ Instalación y Configuración

### Opción 1: Setup Automático (Recomendado)

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd Laravel-NodeDocker

# 2. Ejecutar el script de configuración automática
./setup.sh
```

El script `setup.sh` automáticamente:
- Construye y levanta los contenedores
- Instala todas las dependencias del backend y frontend
- Genera la clave de aplicación de Laravel
- Ejecuta las migraciones de base de datos
- Deja todo listo para empezar a desarrollar

### Opción 2: Setup Manual

#### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd Laravel-NodeDocker
```

#### 2. Configurar variables de entorno

El archivo `.env` (tanto en la raíz como en `backend/.env`) ya está configurado con valores por defecto para desarrollo local. 

⚠️ **Importante para Producción**: Los archivos `.env` incluyen credenciales de desarrollo. Para producción, asegúrate de:
- Usar credenciales seguras y únicas
- No versionar los archivos `.env` en el repositorio
- Usar variables de entorno o un sistema de gestión de secretos

#### 3. Levantar los contenedores

```bash
# Construir las imágenes y levantar los contenedores
docker compose up -d --build
```

**Nota:** Los contenedores tienen scripts de inicialización automática que:
- Instalan las dependencias automáticamente
- Generan la clave de Laravel
- Ejecutan las migraciones

Si es la primera vez, esto puede tomar unos minutos. Puedes ver el progreso con:

```bash
docker compose logs -f backend
docker compose logs -f frontend
```

## 🚀 Uso

Una vez completada la instalación, los servicios estarán disponibles en:

- **Frontend (Vue)**: http://localhost:5173
- **Backend (Laravel)**: http://localhost:8000
- **Base de datos (PostgreSQL)**: localhost:5432

### Comandos útiles

#### Gestión de contenedores

```bash
# Ver el estado de los contenedores
docker compose ps

# Ver los logs de todos los servicios
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db

# Detener los contenedores
docker compose stop

# Detener y eliminar los contenedores
docker compose down

# Detener y eliminar contenedores, volúmenes y redes
docker compose down -v
```

#### Comandos del backend (Laravel)

```bash
# Ejecutar comandos de artisan
docker compose exec backend php artisan migrate
docker compose exec backend php artisan make:controller NombreController
docker compose exec backend php artisan make:model NombreModel

# Ejecutar shell en el contenedor del backend
docker compose exec backend bash

# Limpiar caché
docker compose exec backend php artisan cache:clear
docker compose exec backend php artisan config:clear
docker compose exec backend php artisan route:clear
```

#### Comandos del frontend (Vue)

```bash
# Ejecutar comandos de npm
docker compose exec frontend npm run build
docker compose exec frontend npm run dev

# Ejecutar shell en el contenedor del frontend
docker compose exec frontend sh
```

#### Comandos de base de datos

```bash
# Conectarse a PostgreSQL
docker compose exec db psql -U postgres -d proyecto_db

# Hacer backup de la base de datos
docker compose exec db pg_dump -U postgres proyecto_db > backup.sql

# Restaurar backup
docker compose exec -T db psql -U postgres proyecto_db < backup.sql
```

## 📁 Estructura del Proyecto

```
Laravel-NodeDocker/
├── backend/              # Aplicación Laravel
│   ├── app/             # Código de aplicación
│   ├── config/          # Archivos de configuración
│   ├── database/        # Migraciones y seeders
│   ├── routes/          # Definición de rutas
│   └── ...
├── frontend/            # Aplicación Vue
│   ├── src/            # Código fuente
│   │   ├── components/ # Componentes Vue
│   │   ├── services/   # Servicios (API, etc.)
│   │   └── App.vue     # Componente principal
│   └── ...
├── data/               # Datos persistentes de PostgreSQL
├── docker compose.yaml # Configuración de Docker Compose
├── Dockerfile         # Dockerfile para backend
├── Dockerfile.frontend # Dockerfile para frontend
├── .env              # Variables de entorno
└── README.md         # Este archivo
```

## 🔧 Desarrollo

### Agregar nuevas rutas en Laravel

1. Edita `backend/routes/api.php` para agregar nuevas rutas API
2. Las rutas estarán disponibles en `http://localhost:8000/api/tu-ruta`

### Agregar nuevos componentes en Vue

1. Crea componentes en `frontend/src/components/`
2. Importa y usa los componentes en `App.vue` o en otros componentes

### Conectar frontend con backend

El frontend ya está configurado para conectarse al backend usando Axios:

```typescript
import apiClient from './services/api';

// Hacer petición GET
const response = await apiClient.get('/test');

// Hacer petición POST
const response = await apiClient.post('/endpoint', { data: 'value' });
```

## 🐛 Solución de Problemas

### El backend no se conecta a la base de datos

1. Verifica que el contenedor de PostgreSQL esté corriendo:
   ```bash
   docker compose ps
   ```

2. Verifica las credenciales en el archivo `.env`

3. Reinicia los contenedores:
   ```bash
   docker compose restart
   ```

### El frontend no se conecta al backend

1. Verifica que `VITE_API_URL` en `frontend/.env` apunte a `http://localhost:8000/api`

2. Verifica que CORS esté configurado correctamente en Laravel (ya configurado)

3. Verifica los logs del backend:
   ```bash
   docker compose logs -f backend
   ```

### Error: "Permission denied"

En sistemas Linux, puede ser necesario ajustar los permisos:

```bash
# Dar permisos al directorio storage de Laravel
sudo chmod -R 775 backend/storage backend/bootstrap/cache
```

### Los cambios no se reflejan

1. Para Laravel, limpia la caché:
   ```bash
   docker compose exec backend php artisan cache:clear
   ```

2. Para Vue, asegúrate de que el servidor de desarrollo esté corriendo:
   ```bash
   docker compose logs -f frontend
   ```

## 📝 Notas Adicionales

- Los cambios en el código se reflejan automáticamente gracias a los volúmenes de Docker
- La base de datos persiste en el directorio `./data`
- Para producción, se recomienda configurar variables de entorno adecuadas y optimizar las imágenes

## 🤝 Contribución

Si deseas contribuir al proyecto:

1. Haz un fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/NuevaFuncionalidad`)
3. Commit tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/NuevaFuncionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT.

## 📧 Contacto

Para preguntas o soporte, por favor abre un issue en el repositorio.

---

¡Feliz desarrollo! 🎉
