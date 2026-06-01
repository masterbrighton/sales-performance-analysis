--1. WHAT ARE THE TOTAL SALES?
SELECT 
    sum(sales) as total_sales
FROM superstore;

--2. WHAT ARE THE SALES PER CATEGORY?
SELECT 
    category, sum(sales) as category_profit 
FROM superstore 
GROUP BY category;

--3. WHO ARE THE TOP CUSTOMERS?
SELECT 
customer_name, sum(sales) AS purchase_amount 
FROM superstore 
GROUP BY customer_name 
ORDER BY purchase_amount DESC 
LIMIT 10;

--4. WHAT IS THE MONTHLY GROWTH TREND?
WITH monthly_data AS 
    (
        SELECT 
            extract(year from order_date) AS order_year,
            extract(month from order_date) AS order_month, 
            sum(sales) AS monthly_sales 
        FROM superstore 
        GROUP BY 
            order_year, 
            order_month 
        ORDER BY 
            order_year, 
            order_month
    )
SELECT 
    order_year, 
    order_month, 
    monthly_sales, 
    LAG(monthly_sales) OVER (ORDER BY order_year, order_month) AS previous_month_sales,
    ROUND((monthly_sales - LAG(monthly_sales) OVER (ORDER BY order_year, order_month)) * 100/
    NULLIF (LAG(monthly_sales) OVER (ORDER BY order_year, order_month), 0), 2) AS monthly_growth_percentage
FROM monthly_data;

--5. WHAT IS THE AVERAGE SHIPPING DELAY?
SELECT 
    avg((ship_date - order_date)) AS average_shipping_delay
FROM superstore;