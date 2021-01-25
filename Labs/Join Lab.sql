use sakila;

-- Q1 List number of films per category.

SELECT category_id, count(category_id) as count 
FROM sakila.film_category 
group by category_id order by count desc;inventory

-- Q2 Display the first and last names, as well as the address, of each staff member.
use sakila

SELECT address, address.address_id, staff.first_name, staff.last_name
FROM sakila.address
join sakila.staff on address.address_id = staff.address_id


-- Q3 Display the total amount rung up by each staff member in August of 2005.

select payment.staff_id, sum(amount), staff.first_name, staff.last_name
from payment
join sakila.staff on payment.staff_id = staff.staff_id
group by staff_id

select payment.staff_id, sum(amount)
from payment
group by staff_id



-- Q4 List each film and the number of actors who are listed for that film.

SELECT film_actor.film_id, count(film_actor.actor_id) as 'Actor Count', film.title as Title
FROM sakila.film_actor
join sakila.film on film_actor.film_id = film.film_id
group by title

-- Q5 Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

select sum(amount), payment.customer_id, customer.last_name
from sakila.payment
join customer on payment.customer_id = customer.customer_id group by last_name order by last_name


