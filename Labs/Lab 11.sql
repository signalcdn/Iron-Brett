-- Q1 How many copies of the film Hunchback Impossible exist in the inventory system?

-- Join
select f.title, count(*) from film f
join inventory i
on f.film_id = i.film_id
where title='HUNCHBACK IMPOSSIBLE'

-- subquery
select count(inventory.film_id) from inventory where inventory.film_id in
(select film_id from film where title='HUNCHBACK IMPOSSIBLE')


-- Q2 List all films whose length is longer than the average of all the films.
use sakila
select *, title from film
where length > (select avg(length) as AvgLength from film)

-- Q3 Use subqueries to display all actors who appear in the film Alone Trip.

-- Join

select first_name as FirstName, last_name as LastName 
from actor
join film_actor on
actor.actor_id = film_actor.actor_id
join film on
film_actor.actor_id = film.film_id
where film_actor.film_id = (select distinct(film_id) from film where title='Alone Trip')

-- Subquery

select first_name, last_name from actor where actor_id in 
(select actor_id from film_actor where film_id in
(select film_id from film where title='Alone Trip') group by actor_id)

-- Q4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select film.title
from film
join film_category on film.film_id = film_category.film_id
where film_category.category_id = (select distinct(category_id) from category where category.name='Family')

select title from film where film_id in 
(select film_id from film_category where category_id in 
(select category_id from category where name='Family'));


-- Q5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select first_name, last_name from customer
join address on customer.address_id = address.address_id
join city on address.city_id=city.city_id
join country on city.country_id=country.country_id
where country.country ='Canada'

select first_name, last_name from customer where customer.address_id in
(select address_id from address where city_id in
(select city_id from city where country_id in
(select country_id from country where country='Canada')))

-- Q6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select film.title from film
join film_actor on film.film_id = film_actor.film_id
where actor_id = (select actor_id from film_actor group by actor_id order by count(actor_id) desc limit 1)

select title from film where film_id in
( select film_id from film_actor where actor_id =
	(select actor_id from film_actor 
	group by actor_id
	order by count(*) desc 
    limit 1));


-- Q7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select distinct(film.title), customer.first_name, customer.last_name from customer
join payment on customer.customer_id = payment.customer_id
join rental on payment.rental_id = rental.rental_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on inventory.film_id = film.film_id
where customer.customer_id = (select customer_id from payment group by customer_id order by sum(payment.amount) desc limit 1)





select title from film where film_id in
(select film_id from inventory where inventory_id in
(select inventory_id from rental where customer_id in
(select customer_id from ##in
(select customer_id from payment group by customer_id order by sum(payment.amount) desc limit 1)tableAlias)
group by film_id));

-- Q8 Customers who spent more than the average payments.

select customer_id, SumAmount from 
(select (select avg(PaySum) as AvgSum from (select customer_id, sum(amount) as PaySum from payment group by customer_id order by Paysum desc)sub) as AvgSum, customer_id, sum(amount) as SumAmount
from payment group by customer_id)sub1
where SumAmount > AvgSum
group by customer_id


select customer_id, concat(first_name,' ',last_name) as Name_Surname
from customer
where customer_id in(
select customer_id from
(select customer_id, sum(amount) as amount from payment
group by customer_id
having amount>(select avg(summ) from (select sum(amount) as summ from payment group by customer_id)sub1))sub3);