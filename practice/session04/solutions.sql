
--EJERCICIO 1

-- Transaccion 1
begin;
select f.title count(r.rental_id) as total_alquileres
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.invetory_id = r.inventory_id
group by f.title
order by total_alquileres DESC
limit 10;


-- Transaccion 2
begin;
select * from film f
where f.title = 'Wife Turn';

select inventory_id from inventory where fim_id = 973 limit 1;

insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
values (now(), 4451, 1, null, 1);


-- EJERCICIO 2
DO $$
DECLARE 
    monto numeric = -10;
BEGIN
    if monto > 0 THEN
        begin 
            insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
            value (1,1, 16049, monto, now());
        exception when others THEN
            raise notice 'Error';
            rollback;
        end;
    ELSE
        raise notice 'Monto invalido'
        rollback;
    else if;
end $$;

-- EJERCICIO 3
DO $$
BEGIN
    if exists (select 1 from film where title = "EL GRAN ESTRENO") THEN
        raise notice 'Ya existe';
        rollback;
    else
        insert into film(
            ...
        )
        values (
            ...
        )
        commit;
    end if;
end $$;

-- EJERCICIO 4
begin transaction isolation level serializable;

select customer_id,sum(amount) as total
from payment
group by customer_id
order by total desc
-- Insertamos el mismo valor en dos transaccione diferentes
insert into payment (customer_id, staff_id...)
values (...)

select * FROM payment p where p.rental_id = 16049;
commit;

-- Transaccion 2
begin;
insert into payment (customer_id, staff_id...)
values (...)
commit; 


-- La primera transaccion 1 empieza pero antes de hacer commit la transaccion 2
-- empieza y hace el commit antes de que el 1 haga el commit la transaccion 1
-- se bloquea.