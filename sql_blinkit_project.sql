-- Overview of Blinkit data

USE blinkit;

SELECT *
FROM blinkit_data;

-- Basic Data Exploration

SELECT COUNT(*)
FROM blinkIt_data;

-- Total COUNT = "8523" reords avaiable

SELECT DISTINCT Item_Fat_Content
FROM blinkit_data;

-- 
SELECT 
		MIN(Outlet_Establishment_Year) starting_store_year,
		MAX(Outlet_Establishment_Year) ending_store_year
FROM blinkit_data;


SELECT DISTINCT item_Type
FROM blinkit_data;

-- how many record are NULL in Item_Weight column

SELECT *
FROM blinkit_data
WHERE Item_Weight IS NULL;

-- 1453 rows are Null 

-- item_Fact_Content column has incorrect records 'reg', 'LF', 'low fact'

SELECT DISTINCT Item_Fat_Content
FROM blinkit_data;

-- how much count of Each outlet_identifer

SELECT Outlet_Identifier,
		COUNT(*) AS Total_Count
FROM blinkit_data
GROUP BY Outlet_Identifier
ORDER BY Total_Count DESC;

-- 'reg', 'LF', 'Low Fat', 'Regular'

SELECT Item_Fat_Content
FROM blinkit_data;

-- 'low fact'


-- Data Cleaning

UPDATE blinkit_data
SET Item_Fat_Content =
	CASE
		WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat' 
		WHEN Item_Fat_Content = 'reg' THEN 'Regular' 
		ELSE Item_Fat_Content
	END;

-- Cross Check

SELECT COUNT (*)
FROM blinkit_data;

SELECT DISTINCT Item_Fat_Content
FROM blinkit_data;

SELECT *
FROM blinkit_data;


-- KPI's Creations


-- Q1. Total Sales : The overall revenue generated from all items sold.​

SELECT 
	CONCAT(
		CAST(SUM (Total_Sales)/1000000 AS decimal(10,2)),
		'M'
		) as Total_Sales_in_Million
FROM blinkit_data;

-- Q2. Average Sales : The average revenue per sale.​

SELECT 
	CONCAT(
		CAST(AVG(Total_Sales) AS decimal(10,1)),
		'M'
		) AS Avg_Total_Sales_Million
FROM blinkit_data;

-- Q3. Number of Items : The total count of different items sold.

SELECT 
	COUNT(*) AS no_of_items_sold
FROM blinkit_data;

-- Q4. Average Rating: The average customer rating for items sold. 

SELECT 
	CAST(AVG(Rating) AS decimal(10,1)) AS avg_rating
FROM blinkit_data;


-- Business Requriments

-- Q5. Total Sales by Fat Content

select *
from blinkit_data;

SELECT Item_Fat_Content,
		CONCAT(
			CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)),
			'M'
			) AS Total_Fat_Content_Million		
FROM blinkit_data
GROUP BY Item_Fat_Content;

-- Q6. Total Sales by Item Type

SELECT Item_Type,
		CONCAT(
				CAST(SUM(Total_Sales)/100000 AS DECIMAL(10,2)),
				'K'
				)AS Total_Item_Type_Lakhs		
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Item_Type_Lakhs DESC;

-- Q7. Fat Content by Outlet for Total Sales

with cte1 as(
SELECT  Outlet_Location_Type,
		Item_Fat_Content,
		CONCAT(
				CAST(SUM(Total_Sales)/100000 AS decimal(10,2)),
				'k'
				)  AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type,Item_Fat_Content)
,cte2 AS(
SELECT 
		Outlet_Location_Type,
		MAX(case when Item_Fat_Content = 'Low Fat' THEN Total_sales end) AS Low_Fat_sales_Lakhs,
		MAX(case when Item_Fat_Content = 'Regular' THEN Total_sales end) AS Regular_sales_Lakhs
FROM cte1
GROUP BY Outlet_Location_Type)

SELECT * FROM cte2;

-- Q8 Total Sales by Outlet Establishment

SELECT	Outlet_Establishment_Year,
		COUNT(*) AS no_of_items,
		CAST(SUM(Total_Sales) AS decimal(10,2)) AS total_sales,
		CAST(AVG(Total_Sales) AS decimal(10,2)) AS avg_sales,
		CAST(AVG(Rating) AS decimal(10,2)) AS avg_rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC;


-- Q9. Percentage of Sales by Outlet Size

SELECT 
		Outlet_Size,
		cast(SUM(Total_Sales) AS decimal(10,2)) AS total_sales,
		cast(
			  SUM(Total_Sales)*100/
			  SUM(SUM(Total_Sales)) over() AS Decimal (10,2)
			  ) AS percentage_growth
FROM blinkit_data
GROUP BY Outlet_Size;
