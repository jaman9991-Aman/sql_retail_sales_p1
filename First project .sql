create database sql_project_p1;

use sql_project_p1;

-- CREATE TABLE 
CREATE TABLE retail_sales
		(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category varchar(15),
			quantity int,
			price_per_unit float,
			cogs float,	
			total_sale float
		);
	
select * from retail_sales;

SELECT COUNT(*) 
FROM retail_sales;

-- Data Cleaning 
SELECT *
FROM retail_sales
LIMIT 10;

SELECT 
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantity,
    price_per_unit,
    cogs,
    total_sale
FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
where total_sale is null;

-- data Exploration

-- how many sales we have ?
select count(*) as total_sale from retail_sales;

-- how many customers we have ? 
select count(distinct customer_id) as total_sale from retail_sales;

-- how many distinct category we have?
select distinct category as total_sale from retail_sales;

-- Data Analysis & Business key problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05' -- 
select * from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022
select * 
from retail_sales
where category = 'Clothing' 
and quantity>=4
and sale_date>='2022-11-01'
and sale_date<'2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as net_sale,COUNT(*) as total_orders from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,round(avg(age),2)
 as avg_age
from retail_sales
where category="Beauty"
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender, count(transactions_id) as total_transactions
from retail_sales
group by category,gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- particular query to find avg sale for each month in each year 
select
	year(sale_date) as year,
    month(sale_date) as month,
    avg(total_sale) as avg_sale
from retail_sales
group by year(sale_date),month(sale_date);

-- to find the best month in each year 
select
	year(sale_date) as year,
    month(sale_date) as month,
    avg(total_sale) as avg_sale
from retail_sales
group by year(sale_date),month(sale_date)
order by year,avg_sale desc;

-- witih ROW_Number concept
with monthly_sales as(
	select
		year(sale_date) as year,
        month(sale_date) as month,
        avg(total_sale) as avg_sale
	from retail_sales
    group by year(sale_date),month(sale_date)
),
ranked_sales AS(
	select *,
		row_number() over(
			partition by year
            order by avg_sale desc
		) as rn
	from monthly_sales
)
select year,month,avg_sale
from ranked_sales
where rn=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as unique_customer
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
	case 
		when extract(hour from sale_time)< 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon' 
        else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;


-- END OF PROJECT
