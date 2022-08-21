-- Creating the Table Structure 

CREATE TABLE NFT_BAYC_Sales 
  (Asset_ID INT, Purchase_Date DATETIME, ENS_Domain_Name VARCHAR(20), City VARCHAR(30), Sales_Amount_USD DECIMAL(10,2));
  
-- Inserting the data values into the Table
INSERT INTO NFT_BAYC_Sales
SELECT '5850','2022-08-16','Nick.ETH','Miami',12239.89
UNION ALL	  
SELECT '3113','2022-08-16','Easygoing.ETH','New York',177409.89
UNION ALL	  
SELECT '9012','2022-08-15','Tons.ETH','London',59915.74
UNION ALL	  
SELECT '2731','2017-01-25','Oti.ETH','San Juan',57456.60
UNION ALL	  
SELECT '7151','2022-08-15','David Williams.ETH','London',139538.77
UNION ALL	  
SELECT '609','2022-08-14','Paum.ETH','Los Angeles',3020.12
UNION ALL	 
SELECT '1007','2017-01-09','Hands.ETH','Miami',150000.00
UNION ALL	  
SELECT '1538','2017-01-02','David.ETH','Sydney',24567.97
UNION ALL	  
SELECT '1009','2017-01-04','Chris.ETH','London',12347.69
UNION ALL	  
SELECT '1010','2017-01-06','Oti.ETH','San Juan',10000;


-- Converting data type from DATETIME to DATE for Purchase_Date column 
ALTER TABLE NFT_BAYC_Sales 
MODIFY Purchase_Date DATE;

-- Total Sales per City DESC (using aggregate function) 

SELECT City, SUM(Sales_Amount_USD) AS Total_Sales
FROM NFT_BAYC_Sales NBS
GROUP BY City
ORDER BY 2 DESC;

-- Total Sales per City (using window functions)
SELECT City, ENS_Domain_Name, Purchase_Date, SUM(Sales_Amount_USD) OVER (PARTITION BY City) AS Total_Sales
FROM  NFT_BAYC_Sales
ORDER BY 1,4 DESC;

-- Average Sales per City (using window functions)
SELECT Purchase_Date, ENS_Domain_Name, City, ROUND(AVG(Sales_Amount_USD) OVER (PARTITION BY City),2) AS Average_Sales
FROM NFT_BAYC_Sales
ORDER BY 3,4 DESC;


-- Total City Sales & Percentage of total sales from each city
SELECT City, SUM(Sales_Amount_USD),SUM(Sales_Amount_USD) / SUM(SUM(Sales_Amount_USD)) OVER ()*100 AS City_Percentage
FROM NFT_BAYC_Sales
GROUP BY City
ORDER BY 3;

-- Total Sales from each individual + % of total sales from each individual
SELECT ENS_Domain_Name, SUM(Sales_Amount_USD) AS Total_Sales,  SUM(Sales_Amount_USD) / SUM(SUM(Sales_Amount_USD)) OVER()*100 AS Percentage_Total_Sales
FROM NFT_BAYC_Sales
GROUP BY ENS_Domain_Name
ORDER BY 2;

-- Update date of particular London sale

UPDATE NFT_BAYC_Sales
SET Purchase_Date = "2022-8-16"
WHERE Asset_ID = 7151;


