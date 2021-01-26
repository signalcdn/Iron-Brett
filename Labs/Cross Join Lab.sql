-- Q1 Get all pairs of actors that worked together.

use sakila

select f.title as 'Film Title', fa1.actor_id as 'Actor ID 1', fa2.actor_id as 'Actor ID 2', concat(a1.first_name," ", a1.last_name) as 'Actor 1 Name', concat(a2.first_name," ", a2.last_name) as 'Actor 2 Name'
from film f

    inner join film_actor fa1
    on f.film_id=fa1.film_id
    
    inner join actor a1
    on fa1.actor_id=a1.actor_id
    
    inner join film_actor fa2
    on f.film_id=fa2.film_id
    
    inner join actor a2
    on fa2.actor_id=a2.actor_id
    
where a1.actor_id != a2.actor_id and a2.actor_id > a1.actor_id
order by a1.actor_id, a2.actor_id;

-- Q2 Get all pairs of customers that have rented the same film more than 3 times.

select  in2.film_id as FilmID, a1.customer_id as ID1, a2.customer_id as ID2 , count(*) as Count
from sakila.customer a1

inner join rental re1 
on re1.customer_id = a1.customer_id

inner join inventory in1 
on re1.inventory_id = in1.inventory_id

inner join film fa1
on in1.film_id=fa1.film_id

inner join inventory in2
on fa1.film_id = in2.film_id

inner join rental re2
on re2.inventory_id=in2.inventory_id

inner join customer a2
on re2.customer_id=a2.customer_id


where a1.customer_id <> a2.customer_id and a2.customer_id>a1.customer_id
group by a1.customer_id, a2.customer_id
having count(*)>3
order by Count desc;

select * from rental

-- Q3 Get all possible pairs of actors and films.

SELECT distinct(f.title) as 'Title', concat(a.first_name," ", a.last_name) as Name
from film f
	cross join sakila.actor a


