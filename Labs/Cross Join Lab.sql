-- Q1 Get all pairs of actors that worked together.

SELECT * FROM sakila.film_actor where film_id=1;

SELECT film_actor.film_id, count(film_actor.actor_id) as 'Actor Count', film.title as Title
FROM sakila.film_actor
join sakila.film on film_actor.film_id = film.film_id
group by title


select fa1.actor_id as 'Actor ID 1', fa2.actor_id as 'Actor ID 2', concat(a1.first_name," ", a1.last_name) as 'Actor 1 Name', concat(a2.first_name," ", a2.last_name) as 'Actor 2 Name'
from film f

    inner join film_actor fa1
    on f.film_id=fa1.film_id
    
    inner join actor a1
    on fa1.actor_id=a1.actor_id
    
    inner join film_actor fa2
    on f.film_id=fa2.film_id
    
    inner join actor a2
    on fa2.actor_id=a2.actor_id
    
where a1.actor_id != a2.actor_id;

-- Q2 Get all pairs of customers that have rented the same film more than 3 times.

select count(rental.inventory_id) as Count, concat(c1.first_name," ", c1.last_name) as c1n, concat(c2.first_name," ", c2.last_name) as c2n
from rental
    
    inner join sakila.rental as r1
    on rental.inventory_id = r1.inventory_id
	
    inner join sakila.customer as c1
    on r1.customer_id = c1.customer_id
    
	join sakila.rental as r2 
	on r1.inventory_id = r2.inventory_id and r1.customer_id < r2.customer_id
    
    inner join sakila.customer as c2
    on r2.customer_id=c2.customer_id
    
group by r1.customer_id, r2.customer_id
having count(distinct r1.inventory_id) > 3
order by count(distinct r1.inventory_id) desc;

-- Q3 Get all possible pairs of actors and films.

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
    
where a1.actor_id != a2.actor_id;