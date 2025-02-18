USE WALMART;

SELECT * FROM Walmart;

-- Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening. 
-- This will help answer the question on which part of the day most sales are made.

ALTER TABLE Walmart ADD Time_of_day VARCHAR(30);

SELECT TIME,
		CASE
			WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'AfterNoon'
		ELSE 'Evening'
	END AS Time_of_day
FROM WALMART;


UPDATE WALMART
SET Time_of_day =
(CASE
	WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	WHEN TIME BETWEEN '12:01:00' AND '17:00:00' THEN 'AfterNoon'
ELSE 'Evening'
END);


-- Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
-- This will help answer the question on which week of the day each branch is busiest.

SELECT DATENAME(DY, DATE) 'DATE OF YEAR'
FROM WALMART;

SELECT DATENAME(DW, DATE) 'DATE OF YEAR'
FROM WALMART;

SELECT DATENAME(DD, DATE) 'DATE OF YEAR'
FROM WALMART;

SELECT DATENAME(DAYOFYEAR, DATE) 'DATE OF YEAR'
FROM WALMART;


SELECT DATE, DATENAME(DW, DATE) 'DATE OF YEAR'
FROM WALMART;

ALTER TABLE WALMART ADD DAY_NAME CHAR(30);

UPDATE Walmart
SET DAY_NAME = (
SELECT DATENAME(DW, DATE));

ALTER TABLE Walmart ADD MONTH_NAME CHAR(30);

UPDATE Walmart
SET MONTH_NAME = (
SELECT DATENAME(MONTH, DATE));


-- How many unique cities does the data have? -
-- In which city is each branch?


SELECT APPROX_COUNT_DISTINCT (CITY)  AS 'CITY COUNT'
FROM Walmart;

SELECT DISTINCT (CITY)  AS 'CITY COUNT'
FROM Walmart;


SELECT 
	DISTINCT CITY, BRANCH 
FROM Walmart
ORDER BY Branch;


-- Product Analysis:
-- 1. How many unique product lines does the data have?

SELECT DISTINCT(Product_line) as 'Unique products'
FROM Walmart
ORDER BY Product_line;

-- UNIQUE PRODUCTS 
--1. Electronic accessories
--2. Fashion accessories
--3. Food and beverages
--4. Health and beauty
--5. Home and lifestyle
--6. Sports and travel


-- 2. What is the most common payment method?

SELECT Payment,
	count(*) AS Count
FROM Walmart
GROUP BY Payment
ORDER BY COUNT DESC;


/* The most commonn payment methods are 3.
	They are Ewallet, Cash,Credit card.
	In which Ewallet has highest count*/


-- 3. What is the most selling product line?

SELECT TOP 1 SUM(QUANTITY) 'Total Quantity',
		Product_line
FROM Walmart
GROUP BY Product_line
ORDER BY SUM(QUANTITY) DESC;

/* The most selling product line is Electronic accessories with the quantity of 971*/

-- 4. What is the total revenue by month?

SELECT MONTH_NAME,
	   ROUND(SUM(TOTAL),2) 'Total revenue by Month'
FROM Walmart
GROUP BY MONTH_NAME
ORDER BY 'Total revenue by Month' DESC;

/* January Month has the highest revene than any other months*/


-- 5. What month had the largest COGS?

SELECT MONTH_NAME,
	   ROUND(SUM(COGS),2) 'COGS'
FROM Walmart
GROUP BY MONTH_NAME
ORDER BY 'COGS' DESC;

/* January Month has the largest COGS than any other months*/

 -- 6. What product line had the largest revenue?

SELECT Product_line,
	   ROUND(SUM(total),2) 'Product revenue'
FROM Walmart
GROUP BY Product_line
ORDER BY 'Product revenue' DESC;

/* Food and beverages had the largest rvenue followed by Sports and travel and the least revenue is from Health and beauty */

-- 7. What is the city with the largest revenue?


SELECT Branch,
	   City,
	   ROUND(SUM(total),2) 'City revenue'
FROM Walmart
GROUP BY Branch, City
ORDER BY 'City revenue' DESC;

/* Naypyitaw with the Branch C has the largest revenue than any other ity*/


-- 8. What product line had the largest VAT?

SELECT TOP 1 product_line,
			ROUND(MAX(Tax5),2) 'Largest tax'
			from Walmart
GROUP BY Product_line
ORDER BY 'LARGEST TAX' DESC;


SELECT TOP 1 product_line,
			ROUND(AVG(Tax5),2) 'Largest tax'
			from Walmart
GROUP BY Product_line
ORDER BY 'LARGEST TAX' DESC;

/* Home and lifestyle have the largest tax. */

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) 'Average Quantity',
	AVG(TOTAL) 'Average'
FROM Walmart;

SELECT Product_line,
	CASE
		WHEN AVG(total) > 322 THEN 'Good'
		ELSE 'Bad'
	END AS Remark
FROM Walmart
GROUP BY Product_line;

/*
Electronic accessories	Bad
Fashion accessories		Bad
Food and beverages		Good
Health and beauty		Good
Home and lifestyle		Good
Sports and travel		Good
*/

-- 8. Which branch sold more products than average product sold?

SELECT Branch,
	   SUM(Quantity) 'Average'
FROM Walmart
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(QUANTITY) FROM Walmart); 

/* 
BRANCH	AVERAGE
A		1859
B		1820
C		1831
*/

-- 10. What is the most common product line by gender?

SELECT PRODUCT_LINE,Gender,
	   COUNT(GENDER)
FROM Walmart
GROUP BY PRODUCT_LINE,GENDER
ORDER BY COUNT(GENDER) DESC;

SELECT PRODUCT_LINE,Gender,
	   COUNT(GENDER)
FROM Walmart
WHERE GENDER LIKE 'M%'
GROUP BY PRODUCT_LINE,GENDER
HAVING COUNT(GENDER) > 80
ORDER BY COUNT(GENDER) DESC;

-- CUSTOMER Analysis:

-- 1. How many unique customer types does the data have?

SELECT DISTINCT(CUSTOMER_TYPE) AS 'CUSTOMER TYPES'
FROM Walmart
ORDER BY CUSTOMER_TYPE;

-- 2. How many unique payment methods does the data have?

SELECT DISTINCT(Payment) AS 'CUSTOMER TYPES'
FROM Walmart
ORDER BY Payment;

-- 3. Which customer type buys the most?

SELECT TOP 1 Customer_type,
	   SUM(Quantity) as 'most buys'
FROM Walmart
GROUP BY Customer_type;

-- 4.What is the gender of most of the customers?

SELECT TOP 1 GENDER,
	COUNT(GENDER) AS GENDER_COUNT
FROM Walmart
GROUP BY GENDER
ORDER BY GENDER_COUNT DESC;

-- 5. What is the gender distribution per branch?
SELECT BRANCH, GENDER,
	COUNT(GENDER) AS GENDER_COUNT
FROM Walmart
GROUP BY BRANCH,GENDER
ORDER BY BRANCH;

-- 6. Which time of the day do customers give most ratings?

SELECT TIME_OF_DAY, ROUND(avg(RATING),3)
FROM Walmart
GROUP BY TIME_OF_DAY
ORDER BY ROUND(avg(RATING),3) DESC;

-- 7. Which time of the day do customers give most ratings per branch?

SELECT TIME_OF_DAY, ROUND(avg(RATING),3), BRANCH
FROM Walmart
GROUP BY  BRANCH, TIME_OF_DAY
ORDER BY ROUND(avg(RATING),3) DESC;

-- 8. Which day for the week has the best avg ratings?
SELECT DAY_NAME,  ROUND(avg(RATING),3)
FROM Walmart
GROUP BY  DAY_NAME
ORDER BY ROUND(avg(RATING),3) DESC;

-- 9. Which day of the week has the best average ratings per branch?

SELECT DAY_NAME, BRANCH, ROUND(avg(RATING),3)
FROM Walmart
GROUP BY DAY_NAME, BRANCH
ORDER BY DAY_NAME, ROUND(avg(RATING),3) DESC;


*/ -- SALES ANALYSIS
-- 1. Number of sales made in each time of the day per weekday

SELECT Time_of_day,
       Day_name,
       count(Quantity) AS Number_of_sales
FROM Walmart
WHERE Day_name NOT IN ('Sunday',
                       'Saturday')
GROUP BY Time_of_day,
         Day_name
ORDER BY Day_name,
         Number_of_sales DESC;

/* INFERENECES : The highest sale in MONDAY is in EVENING
				 The highest sale in TUESDAY is in EVENING
				 The highest sale in WEDNESDAY is in AFTERNOON
				 The highest sale in THURSDAY is in EVENING
			     The highest sale in FRIDAY is in AFTERNOON
*/ -- 2. Which of the customer types brings the most revenue?

SELECT CUSTOMER_TYPE,
       round(sum(Total), 4) AS Total
FROM Walmart
GROUP BY CUSTOMER_TYPE
ORDER BY Total DESC;

/* INFERENECES : The members brings the most revenue
*/
-- 3. Which city has the largest tax percent/ VAT (*Value Added Tax*)?

SELECT CITY,
       ROUND(AVG(tax5), 4) AS VAT
FROM Walmart
GROUP BY CITY
ORDER BY VAT;

-- 4. Which customer type pays the most in VAT?

SELECT customer_type,
       sum(tax5) AS Total_VAT
FROM Walmart
GROUP BY customer_type
ORDER BY AVG(tax5) DESC;

/* INFERENCES : The members pay more in VAT
*/