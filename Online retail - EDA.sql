SELECT  * FROM online_retail_transactions ;
 
 SELECT T1.*
FROM online_retail_transactions  AS T1 
Join online_retail_transactions AS T2 
ON T1.Order_ID = T2.Order_ID 
 AND  T1.Product_Name = T2.Product_Name 
 AND T1.Order_ID <> T2.Order_ID  ;
 
 
 
SELECT * , COUNT(*) 
FROM online_retail_transactions 
GROUP BY Order_ID, Product_Name, Category, City, Order_Date, Quantity, Unit_Price_INR, Total_Amount_INR, Payment_Method, Delivery_Date 
HAVING  COUNT(*) > 1 ;


-- WE DON'T HAVE ANY DUPLICATES  --

-- FISRT LETS CHANGE THE INCOREECTED DATA TYPES THE TABEL -- 

ALTER TABLE online_retail_transactions 
MODIFY COLUMN Order_ID  VARCHAR(20) ;

SELECT STR_TO_DATE(Order_Date , '%Y-%m-%d') 
from online_retail_transactions ;


ALTER TABLE online_retail_transactions 
MODIFY COLUMN Order_Date DATE   ; 

ALTER TABLE online_retail_transactions 
MODIFY COLUMN Delivery_Date DATE   ; 

SELECT  * FROM online_retail_transactions ;


-- -STANDARIZING DATA ---

-- For safer, step-by-step updates 

UPDATE online_retail_transactions
SET Category = 'Gadgets'
WHERE Product_Name = 'Smartwatch';

UPDATE online_retail_transactions
SET Category = 'Accessories'
WHERE Product_Name = 'Mouse';

UPDATE online_retail_transactions
SET Category = 'Electronics'
WHERE Product_Name = 'Monitor';


UPDATE online_retail_transactions
SET Category = 'Gadgets'
WHERE Product_Name = 'Tablet';

UPDATE online_retail_transactions
SET Category = 'Electronics'
WHERE Product_Name = 'Laptop' ;

UPDATE online_retail_transactions
SET Category = 'Gadgets'
WHERE Product_Name = 'Smartphone' ;


UPDATE online_retail_transactions
SET Category = 'Electronics'
WHERE Product_Name = 'Camera' ;

UPDATE online_retail_transactions
SET Category = 'Electronics'
WHERE Product_Name = 'Printer' ;


UPDATE online_retail_transactions
SET Category = 'Accessories'
WHERE Product_Name = 'Headphones' ;


UPDATE online_retail_transactions
SET Category = 'Accessories'
WHERE Product_Name = 'Keyboard' ;


--  verifying the changes:

SELECT DISTINCT Product_Name, Category
FROM online_retail_transactions
ORDER BY Product_Name ;


-- EDA -- 
/*  1. Calculate the total number of transactions.

2.Find the average Total_Amount_INR across all transactions.

3.Determine the maximum and minimum Unit_Price_INR.

4.Calculate the total quantity of products sold for each Category.

5.List the City and the total revenue (sum of Total_Amount_INR) generated from that city.

6.Find the Payment_Method that was used for the highest number of transactions.

7.Determine the Category where the average Unit_Price_INR is greater than 1000.

8.Count the number of unique Product_Name items in each Category.

9.Find the Order_ID and Order_Date for orders that used the 'Debit Card' Payment_Method and had a Total_Amount_INR greater than 10000.

10.Find the Order_ID where the difference between Delivery_Date and Order_Date is more than 7 days (assuming a valid date difference calculation function). */


--  1. Calculate the total number of transactions.  ANS 500

SELECT COUNT(Order_ID) AS total_numberOf_transactions 
FROM online_retail_transactions ;

-- 2.Find the average Total_Amount_INR across all transactions. 

SELECT AVG(Quantity*Unit_Price_INR)  AS AVG_Amount
FROM online_retail_transactions ;

-- 3.Determine the maximum and minimum Unit_Price_INR.

SELECT * FROM  online_retail_transactions 
; 
SELECT MAX(Unit_Price_INR) , MIN(Unit_Price_INR)
FROM online_retail_transactions 
;

-- 4.Calculate the total quantity of products sold for each Category.

SELECT Category , SUM(Quantity) AS  total_quantity 
FROM online_retail_transactions 
GROUP BY Category ;

-- 5.List the City and the total revenue (sum of Total_Amount_INR) generated from that city.

SELECT City , SUM(Quantity*Unit_Price_INR) AS  total_revenue
FROM online_retail_transactions 
GROUP BY 1  
ORDER BY total_revenue DESC ;
 
 -- 6.Find the Payment_Method that was used for the highest number of transactions.

SELECT Payment_Method , COUNT(Payment_Method) AS  numof_transactions
FROM online_retail_transactions 
GROUP BY Payment_Method 
ORDER BY 2 DESC 
LIMIT 1 ;

-- 7.Determine the Category where the average Unit_Price_INR is greater than 1000.

SELECT  * FROM online_retail_transactions ;

SELECT Category , AVG(Unit_Price_INR) 
FROM online_retail_transactions 
GROUP BY 1 
HAVING AVG(Unit_Price_INR) > 1000 
ORDER BY AVG(Unit_Price_INR)  DESC ;

-- 8.Count the number of unique Product_Name items in each Category.

SELECT Category , COUNT( DISTINCT Product_Name) AS  Numberof_unique_items 
FROM  online_retail_transactions 
GROUP BY  1  
ORDER BY  2 DESC ;


-- 9.Find the Order_ID and Order_Date for orders that used the 'Debit Card' Payment_Method and had a Total_Amount_INR greater than 10000.

SELECT * FROM online_retail_transactions ;

SELECT Order_ID , Order_Date , Total_Amount_INR
FROM online_retail_transactions 
WHERE Payment_Method = 'Debit Card'
AND Total_Amount_INR > 10000 ;


-- 10.Find the Order_ID where the difference between Delivery_Date and Order_Date is more than 7 days 


SELECT * 
FROM online_retail_transactions 
WHERE DATEDIFF(Delivery_Date , Order_Date ) > 7 ;

/*  11.Identify the top 5 Product_Name items with the highest total quantity sold.

12.Find the Order_ID and Total_Amount_INR for orders whose total amount is greater than the average Total_Amount_INR of all orders.\
 (Requires a subquery).

13 .Find the Order_ID and Product_Name of the product with the highest Total_Amount_INR in each Category.
 (Requires a subquery or window function).

14. Calculate the running total of Total_Amount_INR based on Order_Date. 
(Requires a window function like SUM() OVER()).

15.For each Order_ID, calculate the rank of the Total_Amount_INR compared to all other orders.
 (Requires a window function like RANK() or DENSE_RANK()).

16.Find the month (extracted from Order_Date) with the highest total sales
 (sum of Total_Amount_INR).

17.List the Order_ID and Product_Name of products that were part of an order where all items in that order were paid for using 'UPI'.
 (Requires a subquery or NOT EXISTS/EXCEPT logic).

18.Determine the percentage contribution of each Category to the total overall revenue.

19 . Find customers who placed multiple orders on the same day --
 
 20.Find the City that had the most transactions on a single day.*/

-- 11.Identify the top 5 Product_Name items with the highest total quantity sold. -- 

SELECT  * FROM online_retail_transactions ;

SELECT Product_Name , SUM(Quantity) AS TOTAL_QUATITY 
FROM online_retail_transactions 
GROUP BY  Product_Name 
ORDER BY   TOTAL_QUATITY  DESC 
LIMIT 5 ;


-- 12.Find the Order_ID and Total_Amount_INR for orders whose total amount is greater than the average Total_Amount_INR of all orders.

-- WITH SUBQUARY -- 

SELECT Order_ID, Total_Amount_INR 
FROM online_retail_transactions
WHERE Total_Amount_INR > 
          (SELECT AVG(Total_Amount_INR) FROM online_retail_transactions );
    
-- WITH CTE ---

WITH CTE AS (
SELECT Order_ID , Total_Amount_INR ,
AVG(Total_Amount_INR) OVER() AS Avg_amount 
FROM  online_retail_transactions 
) 
SELECT *
FROM CTE 
WHERE  Total_Amount_INR > Avg_amount ;

-- 13 .Find the Order_ID and Product_Name of the product with the highest Total_Amount_INR in each Category .
 
SELECT  * FROM online_retail_transactions ; 

WITH CTE  AS ( 
SELECT Order_ID , Product_Name , Category  , Total_Amount_INR ,
ROW_NUMBER() OVER( PARTITION BY  Category ORDER BY Total_Amount_INR DESC ) AS RN 
FROM  online_retail_transactions 
) 
SELECT  * FROM CTE 
WHERE RN = 1 ; 


-- WITH SUBquery -- 
SELECT
    t1.Order_ID,  t1.Product_Name,
    t1.Category, t1.Total_Amount_INR
FROM online_retail_transactions t1
INNER JOIN ( SELECT Category ,  MAX(Total_Amount_INR) as MaxAmount
    FROM  online_retail_transactions
    GROUP BY Category ) t2
    ON t1.Category = t2.Category AND t1.Total_Amount_INR = t2.MaxAmount ; 

-- 14. Calculate the running total of Total_Amount_INR based on Order_Date.  --

SELECT * FROM 
online_retail_transactions ;

WITH CTE AS 
( SELECT Order_Date , Total_Amount_INR ,
SUM(Total_Amount_INR) OVER ( ORDER BY Order_Date ) AS RUNNING_TOTAL
FROM online_retail_transactions
) 
SELECT * FROM CTE 
ORDER BY Order_Date ;

-- 15 . For each Order_ID, calculate the rank of the Total_Amount_INR compared to all other orders. 

SELECT * FROM online_retail_transactions 
;

WITH CTE AS
( SELECT Order_ID , SUM(Total_Amount_INR) AS TOTAL_SALES  ,
DENSE_RANK()OVER(  ORDER BY SUM(Total_Amount_INR) DESC ) AS RANK_
FROM online_retail_transactions 
GROUP BY Order_ID )
SELECT  
* FROM CTE 
ORDER BY  TOTAL_SALES DESC 
;

-- 16.Find the month  with the highest total sales. -- 

SELECT  DATE_FORMAT(Order_Date , '%Y-%m') as sales_month ,
SUM(Quantity*Unit_Price_INR) AS total_Sales 
FROM online_retail_transactions 
GROUP BY sales_month
ORDER BY  total_Sales DESC 
LIMIT 1 ;

-- 17.List the Order_ID and Product_Name of products that were part of an order where all items in that order were paid for using 'UPI'. --


SELECT Order_ID ,  Product_Name ,  Payment_Method
FROM online_retail_transactions 
WHERE Payment_Method LIKE "UPI" ;


-- 18.Determine the percentage contribution of each Category to the total overall revenue. --

SELECT Category,
    SUM(Total_Amount_INR) AS Category_Total_Revenue,
    SUM(SUM(Total_Amount_INR)) OVER () AS Overall_Grand_Total,
    ROUND((SUM(Total_Amount_INR) * 100.0) / SUM(SUM(Total_Amount_INR)) OVER (),2) AS Percentage_Contribution
FROM online_retail_transactions
GROUP BY Category
ORDER BY Percentage_Contribution DESC ;



--  20 . Find customers who placed multiple orders on the same day --

WITH CustomerOrders AS (
    SELECT
        -- 1. Create the assumed Customer ID
        SUBSTR(Order_ID, 1, 5) AS Customer_ID,
        Order_Date,
        Order_ID,
        Product_Name
    FROM
        online_retail_transactions
)
SELECT DISTINCT t1.Customer_ID, t1.Order_Date
FROM CustomerOrders t1
JOIN CustomerOrders t2
ON t1.Customer_ID = t2.Customer_ID    
    AND t1.Order_Date = t2.Order_Date  
    AND t1.Product_Name <> t2.Product_Name  
ORDER BY
    t1.Order_Date,
    t1.Customer_ID ;

--  20.Find the City that had the most transactions on a single day. --
    
    WITH DailyTransactionCount AS (
    SELECT
        City,
        Order_Date,
        -- 1. Count the number of individual transaction lines for each City/Day
        COUNT(*) AS Transactions_Per_Day
    FROM
        online_retail_transactions
    GROUP BY
        City,
        Order_Date
),
RankedCities AS (
    SELECT
        City,
        Order_Date,
        Transactions_Per_Day,
        -- 2. Rank the results based on the highest transaction count (best city/day gets rank 1)
        RANK() OVER (
            ORDER BY Transactions_Per_Day DESC
        ) AS transaction_rank
    FROM
        DailyTransactionCount
)
-- 3. Select only the top-ranked results (rank 1), which includes all ties.
SELECT
    City,
    Order_Date,
    Transactions_Per_Day
FROM
    RankedCities 
WHERE
    transaction_rank = 1;
    
    
    SELECT * FROM online_retail_transactions ;






