## 🚀 Pasos para levantar el entorno

## ENV

1. Crear un archivo .env en la raiz de la carpeta dvdrental con los siguientes datos 
```
POSTGRES_USER=nameUser
POSTGRES_PASSWORD=passwordUser
POSTGRES_DB=dvdrental
```

2. **Abrir Git Bash o PowerShell dentro de la carpeta `dvdrental`**
3. Ejecutar el siguiente comando:

```bash
docker-compose --env-file .env up -d
```
Esto descargará la imagen de PostgreSQL, iniciará el contenedor y restaurará automáticamente la base de datos dvdrental.

## 🔍 Verificar que la base esté funcionando

Conectarse al contenedor PostgreSQL:

```
docker exec -it bdavanzada-postgres psql -U paul -d dvdrental
```

Una vez dentro del prompt psql, escribe:

```
\dt
```

Deberías ver las tablas como actor, film, customer, etc.

## ❓ ¿Problemas comunes?

- Asegúrate de que el archivo dvdrental.tar esté en la carpeta docker/.

- Si el contenedor se detiene solo, usa docker logs bdavanzada-postgres para ver qué ocurrió.

- Si quieres reiniciar todo desde cero:

```
docker-compose down -v
docker-compose --env-file .env up -d
```