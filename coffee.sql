SELECT * FROM coffee_brand.coffee_shop_sales;

SET SQL_SAFE_UPDATES = 0;


ALTER TABLE coffee_brand.coffee_shop_sales ADD COLUMN transaction_day DATE;
UPDATE coffee_brand.coffee_shop_sales 
SET transaction_date = STR_TO_DATE(transaction_date, '%m/%d/%Y');
ALTER TABLE coffee_brand.coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

UPDATE coffee_brand.coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');
ALTER TABLE coffee_brand.coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

#1.What are the daily, weekly, and monthly sales trends?
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS Month, 
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_brand.coffee_shop_sales
GROUP BY 
    DATE_FORMAT(transaction_date, '%Y-%m');
#2.What is the average transaction value, and how does it vary by store location?
SELECT ROUND(AVG(transaction_qty*unit_price),2) as avg_of_a_transaction, store_location
 FROM  coffee_brand.coffee_shop_sales
GROUP BY store_location;
#3. Which product categories and types contribute most to overall sales?
SELECT product_category, product_type, ROUND(SUM(transaction_qty* unit_price),2) AS total_sales
FROM   coffee_brand.coffee_shop_sales
GROUP BY product_category, product_type
ORDER BY  product_type ASC
LIMIT 10;
#4. What is the revenue and quantity sold for each product?
SELECT ROUND(SUM(transaction_qty*unit_price),2) AS revenue,
       SUM(transaction_qty) AS quantity_sold, product_category
 FROM  coffee_brand.coffee_shop_sales
 GROUP BY product_category;
   
#5. What is sale status of all products?
WITH sales_data AS (
    SELECT 
        product_type,
        SUM(transaction_qty) AS total_quantity_sold,
        AVG(SUM(transaction_qty)) OVER () AS avg_quantity_sold
    FROM 
        coffee_brand.coffee_shop_sales
    GROUP BY 
        product_type
)
SELECT 
    product_type,
    total_quantity_sold,
    avg_quantity_sold,
    CASE 
        WHEN total_quantity_sold > avg_quantity_sold THEN 'Above Average'
        WHEN total_quantity_sold < avg_quantity_sold THEN 'Below Average'
        ELSE 'Average'
    END AS product_status
FROM 
    sales_data;