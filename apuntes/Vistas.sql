select s.first_name, s.last_name, s.staff_id, i.inventory_id, f.title, f.film_id
from staff s 
inner join rental r
on r.staff_id = s.staff_id
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on f.film_id = i.film_id