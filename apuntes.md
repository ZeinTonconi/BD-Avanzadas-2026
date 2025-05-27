
# Particiones
## Vertical
Separar las columnas en las tablas, por ejemplo podemos partir una tabla en:
* User: email, password, id
* User_profile: name, lastName, user_id
Es para particionar tablas muy grandes y solo necesitemos solamente cierta parte de la tabla.

## Horizontal
Agregamos un sufijo en las tablas segun algun criterio, por ejemplo si hay datos de transacciones de personas por año y por genero separar la tabla por años:
* 2025, 2024, etc.
Las tablas particionadas no pueden tener FK, si se puede hacer pseudo-relacion. Poner le FK dentro de la tabla pero no establecer la relacion. 