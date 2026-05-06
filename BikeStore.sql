Use BikeStores

---1)
---A) Which bike is most expensive?

Select top 1 product_name, list_price, model_year   
from [production].[products]
Order by 2 Desc

---B)  What could be the motive behind pricing this bike at the high price?
---Low discount/limited supply increases price.
---Model year/features raise price for newer or better bikes.
---Brand reputation increases price due to quality perception.

---2) 
---A)How many total customers does BikeStore have? 

Select count(distinct Customer_id) As Total_Customers
from [sales].[customers]

---B) Would you consider people with order status 3 as customers substantiate your answer?
---By joining customers with orders, we can observe that customers with order status 3 (rejected) still exist in the system and have placed orders.
---This indicates that customer identity is independent of order success, and therefore they are still considered valid customers.

---3) How many stores does BikeStore have?


Select count(distinct Store_id) As Total_Stores
from [sales].[stores]

---4) What is the total price spent per order?

SELECT order_id, SUM(list_price * quantity * (1 - discount)) AS total_price
FROM sales.order_items
GROUP BY order_id;

---5) What’s the sales/revenue per store?

SELECT s.store_name, SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS sales_revenue
FROM sales.stores s JOIN sales.orders o
ON s.store_id = o.store_id
JOIN sales.order_items oi
ON o.order_id = oi.order_id
GROUP BY s.store_name

---6) Which category is most sold?
Select top 1 [category_name],sum([quantity]) total_quantity
From [production].[categories] pc join [production].[products] pp
on pc.[category_id] = pp.[category_id]
join [sales].[order_items] soi
on pp.[product_id] = soi.[product_id]
GROUP BY [category_name]

---7) Which category rejected more orders?
Select top 1 [category_name], COUNT(CASE WHEN [order_status] = 3 THEN 1 END) total_rejected
From [production].[categories] pc join [production].[products] pp
on pc.[category_id] = pp.[category_id]
join [sales].[order_items] soi
on pp.[product_id] = soi.[product_id]
join [sales].[orders] so
on soi.[order_id] = so.[order_id]
Group by [category_name]
ORDER BY total_rejected DESC

---8) Which bike is the least sold?

Select top 1 [product_name], Sum([quantity]) total_sold
From [production].[products] pp  join [sales].[order_items] soi
on pp.[product_id] = soi.[product_id]
Group by [product_name]
ORDER BY total_sold Asc

---9) What’s the full name of a customer with ID 259?

Select Concat([first_name],' ',[last_name]) Full_name
From[sales].[customers]
Where customer_id = 259

---10) A) What did the customer on question 9 buy and when? What’s the status of this order?

Select[product_name], [order_date], [order_status]
From [sales].[orders] so join [sales].[order_items] soi
on so.[order_id] = soi.[order_id]
join [production].[products] pp
on pp.[product_id] = soi.[product_id]
Where customer_id = 259

---11) Which staff processed the order of customer 259? And from which store?

Select [store_id], [staff_id]
From [sales].[orders]
where customer_id = 259

---12)A) How many staff does BikeStore have? 

Select count(distinct [staff_id]) #Staff
From [sales].[staffs]

---B) Who seems to be the lead Staff at BikeStore?
Select [manager_id]
From [sales].[staffs]
Where [manager_id] is not null

---13) Which brand is the most liked?
Select top 1 pb. [brand_name],Count(distinct soi. [order_id]) #orders
From [production].[brands] pb join [production].[products] pp
on pb. [brand_id] = pp. [brand_id]
join [sales].[order_items] soi
on pp.[product_id] = soi.[product_id]
Group by pb. [brand_name]
Order by 2 Desc

---14) A)How many categories does BikeStore have?  which one is the least liked?

Select count(distinct[category_id]) Total_Categories
From[production].[categories]

---B) which one is the least liked?
Select top 1 pc.[category_id] , SUM(soi.quantity) AS total_sold
From [production].[categories] pc join [production].[products] pp
on pc.[category_id]  = pp.[category_id]
join [sales].[order_items] soi
on pp.[product_id] = soi.[product_id]
Group by pc.[category_id]
Order by 2 Asc

---15) Which store still have more products of the most liked brand?

Select top 1 ss.[store_name], [brand_name], sum(ps.[quantity]) total_QuantityStock
From [sales].[stores] ss join [production].[stocks] ps
on ss.[store_id] = ps.[store_id]
join [production].[products] pp
on pp.[product_id] = ps.[product_id]
join[production].[brands] pb
on pb.[brand_id] =pp. [brand_id]
WHERE pb.brand_id = (
    SELECT TOP 1 p.brand_id
    FROM production.products p
    JOIN sales.order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.brand_id
    ORDER BY SUM(oi.quantity) DESC
)
Group by  [store_name],[brand_name]
Order by 3 Desc

---16) Which state is doing better in terms of sales?
Select Top 1 [state],sum(list_price * quantity * (1 - discount))  Total_Sales
From [sales].[customers] sc join [sales].[orders] so
On sc.[customer_id] = so.[customer_id]
Join [sales].[order_items] soi
on so.[order_id] = soi.[order_id]
Where [order_status] = 4
Group by [state]
Order by 2 Desc

---17) What’s the discounted price of product id 259?

Select [product_id], [discount], list_price * (1 - discount)  discounted_price
From [sales].[order_items]
Where [product_id] = 259

---18) What’s the product name, quantity, price, category, model year and brand name of product number 44?

Select [product_name], [quantity],soi. [list_price], [category_id], [model_year], [brand_name]
From [sales].[order_items] soi join [production].[products] pp
on soi. [product_id] =pp. [product_id]
Join [production].[brands] pb
On pb. [brand_id] = pp. [brand_id]
Where pp.product_id = 44

---19) What’s the zip code of CA?

Select [zip_code]
From [sales].[customers]
Where [state] = 'CA'

---20) How many states does BikeStore operate in?

Select Count(distinct([state])) #State
From [sales].[customers]

---21) How many bikes under the children category were sold in the last 8 months?

Select sum(soi.[quantity]) total_Bikes
From [sales].[orders] so join [sales].[order_items] soi
on so.[order_id] = soi.[order_id]
join [production].[products] pp
on pp.[product_id] = soi.[product_id]
join [production].[categories] pc
on pc.[category_id] = pp.[category_id]
Where [category_name] = 'Children' AND so.order_date >= DATEADD(MONTH, -8, GETDATE())


---22) What’s the shipped date for the order from customer 523?

Select [shipped_date]
From [sales].[orders]
Where [customer_id] = 523

---23) How many orders are still pending?

Select Count([order_status]) Pending_Orders
From [sales].[orders]
Where [order_status] = 1

---24) What’s the names of category and brand does "Electra white water 3i - 2018" fall under?

Select [category_name], [brand_name]
From [production].[categories] pc join [production].[products] pp
On pc.[category_id] = pp.[category_id]
join [production].[brands] pb
On pb.[brand_id] = pp.[brand_id]
Where  pp.product_name = 'Electra White Water 3i - 2018'



