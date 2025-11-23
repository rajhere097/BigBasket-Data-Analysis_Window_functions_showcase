use internshala;

describe bigbasket;

select count(*)
from bigbasket;
# _______________________________________________________________________________________
 #Task 1 How can you assign a unique row number to each product based on the market price?

select * from bigbasket;

select product, market_price,
row_number() over(order by market_price) as rn
from bigbasket;

# Task 2 How can you retrieve each product along with the previous product in terms of market price?

select product, market_price, lag(product,1) over(order by market_price desc) as previous_product_price
from bigbasket;


# Task 3 How can you categorize products based on their market price into 'Budget', 'Standard', and 'Premium'?

select product, market_price,
case 
when market_price >= 10000 then 'Premium'
when market_price >= 5000 then 'Standard'
else 'Budget'
end as 'Product listing'
from bigbasket
order by market_price desc;

# Task 4 Which stored procedure retrieves products with a sale price lower than the market price?

Delimiter //

create procedure raj_ratnajit()
begin
	select product, sale_price, market_price
	from bigbasket
	where sale_price < market_price;
end //

Delimiter ;

call raj_ratnajit();


# Task 5  Which SQL statement creates a view to show all products with a rating above 3 and a sale price below 200?

create view Ratnajit_raj as
select product, rating, sale_price
from bigbasket
where rating > 3 and sale_price  < 200;

select * from Ratnajit_raj;

# Task 6 Find the top 3 most expensive products in each category.

with expensive3 as
(select category, product,
dense_rank() over(partition by category order by product desc) as rn
from bigbasket)
select * from expensive3
where rn in (1,2,3);

# Task 7 Find products whose sale price is greater than the average sale price of their category.

select a.product, a.category, a.sale_price
from bigbasket a where a.sale_price >
(select avg(b.sale_price) as sp
from bigbasket b
where b.category = a.category);

# Task 8 Show products with the highest discount percentage in each category.

select product, market_price, sale_price, round((market_price - sale_price) * 100/nullif(market_price, 1), 2) as discount_per,
rank() over(order by (market_price - sale_price) * 100/nullif(market_price, 1) desc) as rn
from bigbasket;

# Task 9 Calculate the running total of sales (sale_price) for each category ordered by market_price.

select product, market_price, sale_price, sum(sale_price) over(partition by category order by market_price) as cummulative_sales
from bigbasket;

# Task 10  Which query ranks products within each category based on their rating?

select product, category, rating,
dense_rank() over(partition by category order by rating desc) as rn
from bigbasket;