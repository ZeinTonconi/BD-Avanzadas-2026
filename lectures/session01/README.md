****# Total de películas por categoría

```
 select f.title, c."name"
 from film f
 inner join film_category fc 
on fc.film_id  = f.film_id
inner join category c 
on c.category_id = fc.category_id
group by c."name";
```

# Total de películas por actor

```

```

# Total de pagos por cliente

```
```

# Total recaudado por tienda

```
```

# Mostrar cada actor con JSON de sus películas
```
```
