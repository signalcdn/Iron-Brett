-- Q1 Write a query to display for each store its store ID, city, and country.

SELECT 
store_id as 'Store ID',
city.city_id as 'City ID',
country.country as 'Country'
FROM sakila.store
join address on store.address_id = address.address_id 
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id

-- Q2 Write a query to display how much business, in dollars, each store brought in.

select payment.staff_id, sum(amount), staff.store_id
from payment
join sakila.staff on payment.staff_id = staff.staff_id
group by store_id


-- Q3 What is the average running time of films by category?

SELECT film_category.category_id, avg(length) as 'Average Length' 
FROM sakila.film 
inner JOIN film_category ON film.film_id = film_category.film_id group by category_id;

-- Q4 Which film categories are longest?

SELECT film_category.category_id, avg(length) as avgLength, category.name as 'Name' 
FROM sakila.film 
inner JOIN film_category ON film.film_id = film_category.film_id
inner JOIN category on film_category.category_id = category.category_id
group by category_id
order by avgLength desc;


-- Q5 Display the most frequently rented movies in descending order.

select count(inventory_id) as count from rental group by inventory_id order by count desc limit 5


select 
film.title, count(film.title) as Count
from sakila.film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by film.title order by Count desc limit 5


-- Q6 List the top five genres in gross revenue in descending order.

SELECT
category.name as Category, sum(rental_rate) as Revenues
from sakila.film
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
group by category.name order by Revenues desc limit 5

-- Q7 Is "Academy Dinosaur" available for rent from Store 1?

SELECT title, count(inventory.film_id) as Copies, inventory.store_id from film
join inventory on film.film_id = inventory.film_id 
where inventory.film_id =1 group by inventory.store_id;