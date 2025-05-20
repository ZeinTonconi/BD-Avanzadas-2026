# Ejercicios Propuestos

## Contar películas por categoría
Crea un procedimiento que reciba el nombre de una categoría (IN) y devuelva la cantidad de películas (OUT).
```
CREATE OR REPLACE PROCEDURE count_film_by_category(
  category varchar
)
LANGUAGE plpgsql AS $$
DECLARE
    total NUMERIC;
BEGIN
    select count(*)
    into total
    from film f
    inner join film_category fc
    on fc.film_id = f.film_id
    inner join category c
    on c.category_id = fc.category_id
    where c.name = category;
    RAISE NOTICE 'El total es: %', total;
END
$$;

CALL count_film_by_category('Documentary');

```

## Listar películas por actor
Crea un SP que reciba el actor_id y muestre los títulos de las películas donde participó (usando RAISE NOTICE o PERFORM).
```
CREATE OR REPLACE PROCEDURE sp_show_films_by_actor(
 actorId INT
)
LANGUAGE plpgsql AS $$
DECLARE
    f RECORD;
BEGIN
    for f in 
        SELECT * from film_actor
        inner join film on film.film_id = film_actor.film_id
        where film_actor.actor_id = actorId
    LOOP
        RAISE NOTICE 'Film: %', f.title;
    END LOOP;
END;
$$;

call sp_show_films_by_actor(2)

```
## Total de pagos de un cliente
Crea un SP que reciba el customer_id y devuelva el total que ha pagado (OUT).

```
CREATE OR REPLACE PROCEDURE count_payments_for_customer(
--   firstName varchar, lastName varchar
    customerid integer
)
LANGUAGE plpgsql AS $$
DECLARE
    total NUMERIC;
BEGIN
    select sum(p.amount)
    into total
    from customer c
    inner join payment p
        on c.customer_id = p.customer_id
    where c.customer_id = customerid;
    --where c.first_name = firstName and c.last_name = lastName;
    RAISE NOTICE 'El total es: %', total;
END
$$;

CALL count_payments_for_customer('Sue', 'Peters');
CALL count_payments_for_customer(524);

```
## Activar clientes con pagos
Dado un store_id (IN), activa todos los clientes que hayan hecho al menos un pago.

```
CREATE OR REPLACE PROCEDURE sp_active_clients_from_store(
 storeId INT
)
LANGUAGE plpgsql AS $$
BEGIN
  update customer set active = 1
  where customer_id in (
    select c.customer_id from staff st 
    inner join payment p on st.staff_id = p.staff_id
    inner join customer c on c.customer_id = p.customer_id
    WHERE st.store_id = storeId 
  );
END;
$$;

call sp_active_clients_from_store(1)

```
## Reactivar clientes inactivos
SP que toma un cliente por customer_id, lo activa y registra un mensaje de auditoría usando RAISE NOTICE.
```
CREATE OR REPLACE PROCEDURE sp_active_customer(
  customerId INT
)
LANGUAGE plpgsql AS $$
DECLARE
  customer RECORD;
BEGIN
  select * into customer from customer
  where customer_id = customerId and active = 0;

  IF customer is null then
    RAISE NOTICE 'Se intento activar el cliente con id % pero ya estaba activo', customerId;
  ELSE  
    update customer set active = 1
    where customer_id = customerId;
    RAISE NOTICE 'Se activo el cliente con id %', customerId;
  END IF;
END;
$$;

call sp_active_customer(3)
```
