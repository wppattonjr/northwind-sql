--1. What is the undiscounted subtotal for each Order (identified by OrderID).
select o.OrderID, sum(od.Quantity * od.UnitPrice) as Undiscounted
from Orders o
	join [Order Details] od
	on o.OrderID = od.OrderID
group by o.OrderID

--2. What products are currently for sale (not discontinued)?
select p.*
from Products p where p.Discontinued = 0

--3. What is the cost after discount for each order?  Discounts should be applied as a percentage off.
select o.OrderDate, o.OrderID, sum(od.Quantity * od.UnitPrice * (1 - Discount)) as CostAfterDiscount
from Orders o
	join [Order Details] od	on o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate

--4. I need a list of sales figures broken down by category name.  Include the total $ amount sold over all time and the total number of items sold.
select c.CategoryName, sum(od.UnitPrice * Quantity * (1 - Discount)) as TotalRevenue, count(od.Quantity) as TotalAmountSold
from Products p
	join [Order Details] od on od.ProductID = p.ProductID
	join Categories c on c.CategoryID = p.CategoryID
group by c.CategoryName
order by TotalRevenue desc

--5. What are our 10 most expensive products?
select top 10 *
from Products
order by UnitPrice desc

--6. In which quarter in 1997 did we have the most revenue?
select top 1 datepart(quarter, OrderDate) as WhichQuarter,
sum(od.UnitPrice * Quantity * (1 - Discount)) as TotalRevenue
from Orders o
	join [Order Details] od
		on od.OrderID = o.OrderID
where year(OrderDate) = 1997
group by datepart(quarter, OrderDate)
order by TotalRevenue desc

--7. Which products have a price that is higher than average?
select ProductName, UnitPrice
from Products
where UnitPrice > (select avg(UnitPrice) from Products)
group by ProductName, UnitPrice 


