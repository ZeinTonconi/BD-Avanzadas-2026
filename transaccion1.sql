create table seats(
    id int,
    is_empty bool
)

insert into seats(id, is_empty)
values(1,true);

select * from seats;

-- Trans 1
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
select * from seats;

update seats
set is_empty = FALSE
where id = 1;

select * from seats;

COMMIT;


update seats
set is_empty = TRUE
where id = 1;

select * from seats;

BEGIN;
select * from seats;

update seats
set is_empty = FALSE
where id = 1;

select * from seats;
ROLLBACK;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM seats;
INSERT INTO seats (id, is_empty)
VALUES (2,false)

COMMIT;


delete from seats where id = 1


create or replace procedure insert_film(
	new_film_id int,
	new_title varchar(45),
	new_release_year int, 
	new_language_id int
)
language plpgsql as $$
declare
	existing_film record;
begin 
	raise notice 'Checking if a film exist';
	select * 
	into existing_film
	from film f where
		new_film_id = film_id and
		new_title = title and
		new_release_year = release_year and
		new_language_id = language_id;
    if existing_film is null THEN
        raise notice 'Film created';
        insert into film (film_id, title, release_year, language_id) 
			values(new_film_id, new_title, new_release_year, new_language_id);
    ELSE    
        raise notice 'Film already on the DB';
    end if;
end;
$$;

begin transaction isolation level serializable;
call insert_film(1001, 'Star', 2010, 1);
commit;

delete from film where film_id = 1001;
select * from film where film_id = 1001;


begin transaction isolation level serializable;
select c.customer_id, sum(p.amount) from customer c
inner join payment p on c.customer_id = p.customer_id
group by c.customer_id
order by sum(p.amount) DESC
limit 20;
commit;

-- Sesion 1
begin transaction isolation level serializable;

	update payment p 
	set amount = amount
	where p.payment_id = 19073;
	
	select c.customer_id, sum(p.amount) as total from customer c
	inner join payment p on c.customer_id = p.customer_id
	group by c.customer_id
	order by total DESC
	limit 20;
	
commit;

-- sesion 2
begin;
	update payment p set amount = amount + 10 where p.payment_id = 19073;
commit;