create database salesdatawalamrt;
create table if not exists sale(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar (30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
 quantity int not null,
 VAT float not null,
 total decimal(12,4) not null,
 date datetime not null,
 time TIME not null,
 payment_method varchar(15) not null,
 cogs decimal(10,2) not null,
 gross_margin_pct float,
 gross_income decimal(12,4) not null,
 rating float
);








-----------------------------------------------------------------------------------------------------------------
-- ------------------------------------Feature engineerning-------------------------------------------------------

-- time_of_day
select
time,
    (case
      when time between "00:00:00" and "12:00:00" then "morning"
      when time between "12:01:00" and "16:00:00" then "Afternoon"
      else "evening"
   end
   ) as time_of_date
from sale;

alter table sale add column time_of_day varchar(20); 
update sale
set time_of_day = (
case
      when time between "00:00:00" and "12:00:00" then "morning"
      when time between "12:01:00" and "16:00:00" then "Afternoon"
      else "evening"
   end
);


--------------------------------------------------------------------------------------------------------------------------------
--  day_name--------------------
select
  date,
  dayname(date) as day_name
  from sale;
  
  alter table sale add column day_name varchar(10);
  
  update sale
  set day_name = dayname(date);
  
  
  -- month_name
  
  select
       date,
       monthname(date)
       from sale;
  
  alter table sale add column month_name varchar(50);
  
  update sale
  set month_name = monthname(date);

  -------------------------------------------------------------------------------------------------------------------------------


-- --------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------Generic------------------------------------------------------------------

-- How many unique cities does the data have?
select
 distinct city
 from sale;
 
 -- In which city is each branch?
 select
   distinct branch
   from sale;
     
     
   select
   distinct city,
   branch
   from sale;

-- --------------------------------------------------------------------------------------------------------------
--  ------------------------------------------------product-----------------------------------------------------

-- How many unique product lines does the data have?

select
count(distinct product_line)
from sale;

-- What is the most common payment method?

select
payment_method,
 count(payment_method) as cnt
  from sale
group by payment_method
order by cnt desc;


-- What is the most selling product line?

select
product_line,
 count(product_line) as cnt
  from sale
group by product_line
order by cnt desc;


-- What is the total revenue by month?

select
month_name as month,
sum(total) as total_revenue
from sale
group by month_name
order by total_revenue;


-- What month had the largest COGS?

select
month_name as month,
 sum(cogs) as cogs
from sale
group by month_name
order by cogs;

-- What product line had the largest revenue?

select
  product_line,
  sum(total) as total_revenue
  from sale
  group by product_line
  order by total_revenue;
  
  
  -- What is the city with the largest revenue?
  
  select
  branch
  city,
  sum(total) as total_revenue
  from sale
  group by city, branch
  order by total_revenue desc;
  
  -- What product line had the largest VAT?
  
  select
  product_line,
  avg(vat) as avg_tax
  from sale
  group by product_line
  order by avg_tax;
  
  -- Which branch sold more products than average product sold?
  
  select
  branch,
  sum(quantity) as qty
  from sale
  group by branch 
  having sum(quantity) > (select avg(quantity) from sale);
  
  
  -- What is the most common product line by gender?
  
  select
  gender, product_line,
  count(gender) as total_cnt
  from sale
  group by gender, product_line
  order by total_cnt desc;
  
  
  -- what is the avg rating of each product line?
  
  select
  round (avg(rating),2) as avg_rating,
  product_line
  from sale
  group by product_line
  order by avg_rating desc;
  
  -- ---------------------------------------------------------------------------------------------------------------
  -- Number of sales made in each time of the day per weekday?
  
  select
  time_of_day,
  count(*) as total_sales
  from sale
  where day_name = "monday"
  group by time_of_day
  order by total_sales desc;
  
  
  -- -----------------------------------------------------------------------------------------------------------------------
  -- Which of the customer types brings the most revenue?
  
  select
  customer_type,
  sum(total) as total_revenue
  from sale
  group by customer_type
  order by total_revenue desc;
  
  -- Which city has the largest tax percent/ VAT (Value Added Tax)?
  
  select
  city,
  avg(vat) as vat
  from sale
  group by city 
  order by vat desc;
  
  -- Which customer type pays the most in VAT?
  
  select
  customer_type,
  sum(vat) as total_vat
  from sale
  group by customer_type
  order by total_vat desc;
  
  
  
  -- -----------------------------------------------end----------------------------------------------------------------------------------
  
  
  
  
  