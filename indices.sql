explain analyze select * from rental
inner join customer c ON
c.customer_id = rental.customer_id
where rental_date > '2005-05-20' 
and  c.first_name like 'A%'

create index idx_c_first_name on customer(first_name)