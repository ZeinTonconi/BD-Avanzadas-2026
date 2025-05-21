# Sesion 3
## Funciones
### Duración promedio de las películas
```
CREATE OR REPLACE FUNCTION fn_promedio_pelis(categoryName VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
  promedio NUMERIC;
BEGIN
    select avg(f.length) into promedio
    from film f
    inner join film_category fc
    on fc.film_id = f.film_id
    inner join category c
    on c.category_id = fc.category_id
    WHERE categoryName = c."name";
  RETURN COALESCE(promedio, 0);
END;
$$ LANGUAGE plpgsql;

select fn_promedio_pelis('Family');
```
### Categoría favorita de un cliente
```
CREATE OR REPLACE FUNCTION fn_cate_fav_cliente(custId integer)
RETURNS varchar(25) AS $$
DECLARE
    favoriteCategory varchar(25);
BEGIN
    SELECT c.name INTO favoriteCategory
    FROM category c
    INNER JOIN film_category fc ON c.category_id = fc.category_id
    INNER JOIN inventory i ON fc.film_id = i.film_id
    INNER JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE r.customer_id = custId
    GROUP BY c.name
    ORDER BY COUNT(r.rental_id) DESC
    LIMIT 1;
    RETURN favoriteCategory;
END;
$$ LANGUAGE plpgsql;

select fn_cate_fav_cliente(15);
```
### Pagos por cliente y mes
```
CREATE OR REPLACE FUNCTION fn_pagos_cli_mes(custId integer)
RETURNS TABLE(mes NUMERIC, total NUMERIC) AS $$
BEGIN
    RETURN QUERY
    select EXTRACT(MONTH FROM p.payment_date), sum(p.amount)
    from payment p
    where p.customer_id = custId
    group by EXTRACT(MONTH FROM p.payment_date)
    order by mes;
END;
$$ LANGUAGE plpgsql;

select fn_pagos_cli_mes(6);
```
### Clientes sin alquiler en los últimos 3 meses
```
CREATE OR REPLACE FUNCTION fn_clientes_inactivos()
RETURNS TABLE(customer_id NUMERIC) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT c.customer_id
  FROM customer c
  INNER JOIN payment p ON c.customer_id = p.customer_id
  WHERE c.active = false
    AND p.payment_date >= (CURRENT_TIMESTAMP - INTERVAL '3 months');
END;
$$ LANGUAGE plpgsql;
```
## Triggers
### Auditoría de actualización
```
CREATE OR REPLACE FUNCTION actualizacion_cliente()
RETURNS trigger AS $$
BEGIN
    RAISE NOTICE 'Cliente actualizado: % %, Email nuevo: %',
            NEW.first_name,
            NEW.last_name,
            NEW.email;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_timestamp
AFTER UPDATE ON customer
FOR EACH ROW
EXECUTE FUNCTION actualizacion_cliente();

INSERT INTO customer (customer_id, store_id, first_name, last_name, email, address_id, active)
VALUES ('1000', 1, 'Rebe', 'Navarro', 'beca@navarro', 5,1 );

UPDATE customer
SET email = 'beca@gmail.com'
WHERE customer_id = 1000;
```
### Log de inserciones de películas
```
CREATE OR REPLACE FUNCTION notify_new_film()
RETURNS TRIGGER AS $$
BEGIN
  RAISE NOTICE 'Nueva película: % fue registrada con rating %', NEW.title, NEW.rating;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notify_new_film
AFTER INSERT ON film
FOR EACH ROW
EXECUTE FUNCTION notify_new_film();

INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
VALUES ('IT: The Movie', 'Luis xd', 2025, 1, 5, 2.99, 120, 19.99, 'PG');
```
### Historial de eliminaciones
```
CREATE TABLE staff_deleted_log (
  staff_id INTEGER,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE OR REPLACE FUNCTION log_staff_deletion()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO staff_deleted_log (staff_id, first_name, last_name, deleted_at)
  VALUES (OLD.staff_id, OLD.first_name, OLD.last_name, CURRENT_TIMESTAMP);
  RETURN NULL; -- No se necesita retornar nada en un trigger AFTER DELETE
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_log_staff_deletion
AFTER DELETE ON staff
FOR EACH ROW
EXECUTE FUNCTION log_staff_deletion();
```
# Soluciones docnete
## Triigers
### Historial de eliminaciones
Cuando son logs o historial cosas para auditoria o analisis no es necesario colocar el primary key.
```
CREATE TABLE staff_deleted_log(
    staff_id int,
    first_name varchar(45),
    last_name varchar(45),
    deleted_at timestamp
);

CREATE OR REPLACE FUNCTION insert_staff_log()
RETURN TRIGGER AS $$
BEGIN
  INSERT INTO staff_deleted_log
  (staff_id, first_name, last_name, delted_at)
  VALUES (OLD.staff_id, OLD.first_name, OLD.last_name, now());
  RETURN OLD;
END;

CREATE TRIGGER trg_deleted_log
AFTER DELETE ON staff
FOR EACH ROW
EXECUTE FUNCTION insert_staff_log()
```