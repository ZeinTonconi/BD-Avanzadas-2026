#!/bin/bash

# Esperar a que PostgreSQL esté disponible
until pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"; do
  echo "Esperando a PostgreSQL..."
  sleep 2
done

# Restaurar si no hay tablas
if [ "$(psql -U $POSTGRES_USER -d $POSTGRES_DB -tAc "SELECT COUNT(*) FROM pg_tables WHERE schemaname='public';")" -eq "0" ]; then
  echo "Restaurando base de datos desde dvdrental.tar..."
  pg_restore -U $POSTGRES_USER -d $POSTGRES_DB /docker-entrypoint-initdb.d/dvdrental.tar
else
  echo "La base de datos ya tiene contenido. No se restaurará."
fi
