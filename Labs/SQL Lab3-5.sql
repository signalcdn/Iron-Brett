use sakila

-- Q1 Get release years.

SELECT DISTINCT YEAR(release_year) as 'Distinct Years' FROM sakila.film

-- Q2 Get all films with ARMAGEDDON in the title.

select * from sakila.film where title LIKE '%ARMAGEDDON%'

-- Q3 Get all films which title ends with APOLLO.

select * from sakila.film where REGEXP_LIKE(title, 'APOLLO$');

-- Q4 Get 10 the longest films.

select top 10(length) from sakila.film limit 10

-- Q5 How many films include Behind the Scenes content?

select count(*) as 'Films with BTS Content' from sakila.film where special_features LIKE '%Behind the Scenes%'

-- Q6 Drop column picture from staff.

ALTER TABLE sakila.staff
DROP COLUMN picture;

-- Q7 A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.


INSERT INTO sakila.staff
VALUES ('3','Tammy', 'Sanders', '5', 'Tammy.Sanders@sakilastaff.com', '2', '1', 'Tammy', 'xdxd', CURRENT_TIMESTAMP);

-- Q8 Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
-- Q8.1 
-- You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there. 
-- You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';


-- Q8.2 Use similar method to get inventory_id, film_id, and staff_id.

select staff_id from sakila.staff
where first_name = 'MIKE' and last_name = 'Hillyer';

select film_id from sakila.film
where title = 'ACADEMY DINOSAUR';

select inventory_id from sakila.inventory
where film_id = 1;

select * from rental

-- rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update

INSERT INTO sakila.rental
VALUES ('16051', CURRENT_TIMESTAMP, '2', '130', null, '1', CURRENT_TIMESTAMP);

select customer_id from sakila.rental
where rental_id = 16050;

-- LAB SOLUTION




-- Q9 Delete non-active users, but first, create a backup table with deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

select (customer_id, email, create_date) into Backup
FROM customer where active=0;

-- Check if there are any non-active users

select * from sakila.customer
where active= 0;

-- Create a table backup table as suggested

CREATE TABLE Backup (customer_id smallint, email varchar(255), create_date datetime);

-- Insert the non active users in the table backup table
INSERT INTO BACKUP
select customer_id, email, create_date
FROM sakila.customer where active=0;

-- Delete the non active users from the table customer

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM customer WHERE active=0;

-- CHECK COLUMN TYPES
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'customer'


-- Lab 4
-- Setup 





-- Instructions
-- We have just one item for each film, and all will be placed in the new table.
-- For 2020, the rental duration will be 3 days, with an offer price of 2.99€ and a replacement cost of 8.99€ (these are all fixed values for all movies for this year).
-- The catalog is in a CSV file named films_2020.csv that can be found at files_for_lab folder.
-- Q1 Add the new films to the database.

drop table if exists films_2020;
CREATE TABLE `films_2020` (
  `film_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year(4) DEFAULT NULL,
  `language_id` tinyint(3) unsigned NOT NULL,
  `original_language_id` tinyint(3) unsigned DEFAULT NULL,
  `rental_duration` int(6),
  `rental_rate` decimal(4,2),
  `length` smallint(5) unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) DEFAULT NULL,
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;


-- Q2 Update information on rental_duration, rental_rate, and replacement_cost.

UPDATE sakila.films_2020 SET rental_duration = 3, rental_rate = 2.99, replacement_cost = 8.99 where language_id = 1;


-- Hint: You might have to use the following commands to set bulk import option to ON:

show variables like 'local_infile';
set global local_infile = 1;

-- If bulk import gives an unexpected error, you can also use the data_import_wizard to insert data into the new table.

-- Q1 In the table actor, which are the actors whose last names are not repeated? 

select first_name, last_name 
from sakila.actor 
group by last_name
having count(*)=1;

-- Q2 Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
select last_name 
from sakila.actor 
group by last_name
having count(*)>1;

-- Q3 Using the rental table, find out how many rentals were processed by each employee.

select staff_id, count(rental_id) from sakila.rental group by staff_id;

-- Q4 Using the film table, find out how many films were released each year.

select count(*), release_year from sakila.film group by release_year

-- Q5 Using the film table, find out for each rating how many films were there.

select count(*), rating from sakila.film group by rating

-- Q6 What is the mean length of the film for each rating type. Round off the average lengths to two decimal places

select round(avg(length), 2) as avgLength, rating as 'Rating' from sakila.film group by rating;

-- Q7 Which kind of movies (rating) have a mean duration of more than two hours?

select round(avg(length), 2) as avgLength, rating as 'Rating' from sakila.film group by rating having avgLength>119;

-- Lab 4 ---
-- Q1 Rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.

select title, length,
RANK() OVER(order by Length DESC) as 'Rank'
from sakila.film 
order by length desc


-- Q2 Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, rating and the rank.

select title, rating, length,
RANK() OVER(order by Length DESC) as 'Rank'
from sakila.film 
order by length desc

-- Q3 How many films are there for each of the categories in the category table. Use appropriate join to write this query
SELECT film_category.category_id, count(film_category.category_id) as count 
FROM sakila.film 
INNER JOIN film_category ON film.film_id = film_category.film_id group by category_id;



-- Q4 Which actor has appeared in the most films?
-- NO JOIN
SELECT film_actor.actor_id, count(film_actor.film_id) as count
FROM sakila.film_actor 
group by actor_id order by count desc

-- WITH JOIN
SELECT film_actor.actor_id, count(film_actor.film_id) as count, actor.first_name as FirstName, actor.last_name as LastName
FROM sakila.film_actor
JOIN actor ON film_actor.actor_id = actor.actor_id
group by actor_id order by count desc


-- Q5 Most active customer (the customer that has rented the most number of films)
-- NO JOIN
SELECT rental.customer_id, count(rental.rental_id) as count, customer.first_name as FirstName, customer.last_name as LastName
FROM sakila.rental
group by customer_id order by count desc

-- WITH JOIN
SELECT rental.customer_id, count(rental.rental_id) as count, customer.first_name as FirstName, customer.last_name as LastName
FROM sakila.rental
JOIN customer ON rental.customer_id = customer.customer_id
group by customer_id order by count desc


-- Bonus: Which is the most rented film? The answer is Bucket Brotherhood This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.