-- Lab 2

SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_NAME = 'sakila.rental' AND 
     COLUMN_NAME = 'yourColumnName'

-- Question 1
-- Select all the actors with the first name ‘Scarlett’.

use sakila
SELECT * FROM sakila.actor where first_name='Scarlett';

-- Question 2
-- How many films (movies) are available for rent and how many films have been rented?

SELECT count(*) FROM sakila.inventory;

-- Question 3
-- What are the shortest and longest movie duration? Name the values max_duration and min_duration.

select max(length) as 'Max Length', min(length) as 'Min Length' from sakila.film;

-- Question 4
-- What's the average movie duration expressed in format (hours, minutes)?

SELECT floor(avg(length)/60) as 'Average Duration, Hours', round(avg(length) % 60) as Minutes from sakila.film

-- Question 5
-- How many distinct (different) actors' last names are there?

select count(distinct(last_name)) from sakila.actor;

-- Question 6
-- Since how many days has the company been operating (check DATEDIFF() function)?

SELECT DATEDIFF(Max(rental_date), Min(rental_date)) as DateDiff from sakila.rental;

-- Question 7
-- Show rental info with additional columns month and weekday. Get 20 results.

SELECT *,
date_format(rental_date,'%M') as 'Month',
date_format(rental_date, '%W') as 'Weekday'
from sakila.rental
limit 20;

-- Question 8
-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.

SELECT *,
	CASE
    WHEN WEEKDAY(rental_date)=TRUE THEN 'Weekday'
    ELSE 'Weekend'
END as day_type
from sakila.rental;

-- Question 9
-- How many rentals were in the last month of activity?

-- Check Max Date
select date(max(rental_date)) from rental;

-- Select from maxDate-1month
select * from sakila.rental
where rental_date BETWEEN '2006-01-14' and '2006-02-14';

select *, date_format(rental_date,'%M') as Month_, date_format(rental_date,'%Y')  as Year_ from sakila.rental;
having Month_ = 'August' and Year_ = 2005;




