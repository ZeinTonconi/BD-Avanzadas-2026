# Monto total pagado por cada cliente
```
select c."first_name", c.last_name, sum(p.amount)
from customer c
inner join payment p
    on c.customer_id = p.customer_id
group by c.first_name, c.last_name;

```

# Clientes que han pagado más de $200

```
select c.first_name, sum(p.amount)  from customer c
inner join payment p on c.customer_id = p.customer_id
group by c.first_name having sum(p.amount)>200
order by sum(p.amount) desc;

```
# Cantidad de películas por categoría y promedio de duración
```
select c."name", count(*), avg(f.length)
from film f
inner join film_category fc
on fc.film_id = f.film_id
inner join category c
on c.category_id = fc.category_id
group by c."name" ;

```
# JSON de películas por categoría
```
```

