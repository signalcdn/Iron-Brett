-- Q1 Get number of monthly active customers.
use sakila;


drop view June
create view June as 
select count(customer) as CustCountJune from (
select distinct(rentals_june.customer_id) as customer from customer 
join rentals_june on
customer.customer_id = rentals_june.customer_id where active=1)sub

select count(distinct customer_id), date_format(rental_date, "%Y") as year_,
date_format(rental_date,"%M") as month_
from sakila.rental
group by year_, month_;

-- Q2 Active users in the previous month.

drop view May
create view May as 
select count(customer) as CustCountMay from (
select distinct(rentals_may.customer_id) as customer from customer 
join rentals_may on
customer.customer_id = rentals_may.customer_id where active=1)sub

select (counts-lag(counts, 1) over())/counts*100 as lags, year_, month_
from
(
select count(distinct customer_id) as counts, date_format(rental_date, "%Y") as year_,
date_format(rental_date,"%m") as month_
from rental
group by year_, month_)sub;

-- Q3 Percentage change in the number of active customers.
with combi as (
select * from May, June
)

select (((CustCountJune-CustCountMay)/CustCountJune)*100) as MonthlyChange from combi


with cte1 as (
select distinct customer_id, date_format(rental_date, "%Y") as year_,
date_format(rental_date, "%m") as month_
from rental)

select count(c1.customer_id) as retained, c1.year_, c1.month_
from cte1 as c1
join cte1 as c2
on c1.customer_id = c2.customer_id where c1.month_ = c2.month_ + 1
group by 2,3

-- Q4 Retained customers every month

-- Get May Customers
create view MayCust as (
select distinct(rentals_may.customer_id) as customer from customer 
join rentals_may on
customer.customer_id = rentals_may.customer_id
where active=1)


-- Get June Customers
create view JuneCust as (
select distinct(rentals_june.customer_id) as customer from customer 
join rentals_june on
customer.customer_id = rentals_june.customer_id
where active=1)

-- combine and test

select distinct(JuneCust.customer) from JuneCust
join MayCust m on
JuneCust.customer <> MayCust.customer
group by


