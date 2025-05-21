--Ejercicio 1
create or replace function gastp_cliente_anio(p_coustumer_id INT)
returns int as $$
declare gasto_anual int; 
begin
	select SUM(p.amount)
    into gasto_anual
    from customer c
    join payment p
    on c.customer_id = p.customer_id
	where p.payment_date >= CURRENT_DATE - INTERVAL '1 year'
	;

	IF gasto_anual IS NULL THEN
    	gasto_anual := 0;
	END IF;
	return gasto_anual;
end
$$ language plpgsql;

select *
from customer c
join payment p
on c.customer_id = p.customer_id
    
    
select gastp_cliente_anio(341);

-- Ejercicio 2
CREATE OR REPLACE PROCEDURE activar_clientes_por_gasto_minimo(
    IN p_valor_minimo NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
    gasto_total NUMERIC;
BEGIN
    FOR r IN SELECT customer_id FROM customer LOOP
        SELECT COALESCE(SUM(p.amount), 0)
        INTO gasto_total
        FROM payment p
        WHERE p.customer_id = r.customer_id;

        IF gasto_total >= p_valor_minimo THEN
            UPDATE customer
            SET activebool = TRUE
            WHERE customer_id = r.customer_id;
        END IF;
    END LOOP;
END;
$$;

-- Ejercicio 3

create table update_customer_log (
  customer_id INTEGER,
  old_email VARCHAR(45),
  new_email VARCHAR(45),
  old_active INTEGER,
  new_active INTEGER
);


create or replace function fn_log_update()
returns trigger as $$
  begin
    if old.email != new.email or old.active != new.active THEN
      insert into update_customer_log 
      (customer_id, old_email, new_email, old_active, new_active) 
      values (old.customer_id, old.email, new.email, old.active, new.active);
      if old.email != new.email then
        RAISE NOTICE 'Customer email update of customer % from % to %', old.customer_id, old.email, new.email; 
      end if;
      if old.active != new.active then
        RAISE notice 'Cutomer active update of customer % from % to %', old.customer_id, old.active, new.active;
      end if;
    end if;
    return null;
  end;
$$ language plpgsql; 

create trigger log_update_customer 
after update on customer
for each row
execute function fn_log_update();

select * from customer

update customer set email = 'zein.tonconi@gmail.com' where customer_id = 1

update customer set active = 0 where customer_id = 1

select * from update_customer_log

-- Ejercicio 4

create view vip_cutomers as
  select c.customer_id, sum(p.amount) from customer c
  inner join payment p on c.customer_id = p.customer_id
  GROUP BY c.customer_id
  having sum(p.amount) > 200

select * from vip_cutomers
