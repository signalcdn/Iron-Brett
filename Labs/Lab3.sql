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
VALUES ('16050', CURRENT_TIMESTAMP, '2', '130', CURRENT_TIMESTAMP, '1', CURRENT_TIMESTAMP);

select customer_id from sakila.rental
where rental_id = 16050;


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