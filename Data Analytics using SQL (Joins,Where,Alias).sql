-- Combing through data and checking out distinct values
USE global_data;
SELECT distinct ModelName from global_products;
SELECT distinct Productcolor from global_products;
SELECT distinct country from global_territories;

-- Categorising total sales and total cost per ModelName
SELECT 
 ModelName, 
 SUM(ProductCost) AS Total_Cost, 
 SUM(ProductPrice) AS Total_Return
FROM 
 global_products
GROUP BY 
 ModelName
ORDER BY 2 DESC;

-- Identify which colour sold the most & exclude "NA" Colour
SELECT ProductColor,
COUNT(*) AS Quantity_Sold 
FROM global_products
WHERE ProductColor NOT IN ('NA')
GROUP BY ProductColor
ORDER BY 2 DESC;

-- Calculate sum of sales & frequency of sales per country
SELECT gt.country, SUM(gb.ProductPrice) AS Total_Sales, COUNT(gs.TerritoryKey) AS Quantity_of_Sales_in_Country, AVG(gb.ProductPrice) AS Average_Total_Sales
FROM global_products gb
LEFT OUTER JOIN global_sales_2017 gs
ON gb.ProductKey = gs.ProductKey
LEFT OUTER JOIN global_territories gt
ON gt.SalesTerritoryKey = gs.TerritoryKey
WHERE gt.country IS NOT NULL
GROUP BY gt.country
ORDER BY 4 DESC;

-- Previous query shows us that United States generated the most sales. What were the top three most popular Model Names sold in United States?
SELECT gt.country, gb.ModelName, SUM(gb.ProductPrice) AS Total_Sales, COUNT(gs.TerritoryKey) AS Quantity_of_Sales_in_Country
FROM global_products gb
LEFT OUTER JOIN global_sales_2017 gs
ON gb.ProductKey = gs.ProductKey
LEFT OUTER JOIN global_territories gt
ON gt.SalesTerritoryKey = gs.TerritoryKey
WHERE gt.country IS NOT NULL AND gt.country = "United States"
GROUP BY gt.country,gb.ModelName
ORDER BY 4 DESC
LIMIT 3;

-- Top five popular modelname by number sold
SELECT ModelName, COUNT(ModelName) as Number_Sold
FROM global_products
GROUP BY ModelName
ORDER BY 2 DESC
LIMIT 5;

-- Adding a new column to Global_Customers table
ALTER TABLE global_customers ADD COLUMN Full_Name VARCHAR(50);


-- Updating the new column (newcolumn is called FullName) with concatenation of FullName & LastName
UPDATE global_customers SET Full_Name = CONCAT(FirstName, ' ' ,LastName);


-- Top 10 customers by frequency bought & how much they each contribute to total quantity of sales(percentage wise)
SELECT gc.Full_Name,gc.AnnualIncome,COUNT(gs.TerritoryKey) AS Quantity_Bought ,COUNT(gs.TerritoryKey) / SUM(COUNT(gs.TerritoryKey)) OVER ()*100 AS Percentage_of_overall_items_bought
FROM global_sales_2017 gs
LEFT OUTER JOIN global_customers gc
ON gs.CustomerKey = gc.CustomerKey
GROUP BY Full_Name
ORDER BY 3 DESC
LIMIT 10;

-- Identify the customers who have not purchased an item in 60 days prior to the most recent order date  & mark them as "Dormant Customers"
CREATE VIEW orders_days AS
SELECT 
 gc.Full_Name, 
 MAX(gs.OrderDate) AS Last_Order_Date,
(SELECT MAX(OrderDate) FROM global_sales_2017) AS Last_Order_By_Any_Customer,
DATEDIFF((SELECT MAX(OrderDate) FROM global_sales_2017),MAX(gs.OrderDate)) AS Name_exp_4
FROM 
 global_sales_2017 gs
LEFT OUTER JOIN 
 global_customers gc
USING 
 (CustomerKey)
GROUP BY 
 Full_Name;

-- Return the views created from preview query and use CASE to return "Dormant" based on criteria in line 73.
 SELECT *,
  CASE 
   WHEN Name_exp_4 >= 600 THEN "Dormant"
   ELSE "Null"
   END AS "No Comment"
 FROM orders_days;

