-- 📊 Sales Analysis SQL Queries
-- This file contains queries used for sales performance and revenue analysis

-- 1. Total revenue and number of orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales
FROM sales;

-- 2. Average order value
SELECT 
    SUM(sales) / COUNT(DISTINCT order_id) AS avg_order_value
FROM sales;

-- 3. sales by year
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales) AS total_sales
FROM sales
GROUP BY year
ORDER BY year;

-- 4. Monthly sales (seasonality)
SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(sales) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;

-- 5. sales by category
SELECT 
    category,
    SUM(sales) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- 6. Top 10 products by sales
SELECT 
    product_name,
    SUM(sales) AS total_sales
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 7. Revenue by region (states)
SELECT 
    state,
    SUM(sales) AS total_sales
FROM sales
GROUP BY state
ORDER BY total_sales DESC;

-- 8. Top 3 regions contribution (CTE)
WITH top_regions AS (
    SELECT 
        state,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY state
    ORDER BY total_sales DESC
    LIMIT 3
)
SELECT 
    SUM(total_sales) AS top_3_sales
FROM top_regions;

-- 9. Share of top 10 products (CTE)
WITH product_sales AS (
    SELECT 
        product_name,
        SUM(sales) AS total_sales
    FROM sales
    GROUP BY product_name
),
top_10 AS (
    SELECT *
    FROM product_sales
    ORDER BY total_sales DESC
    LIMIT 10
)
SELECT 
    SUM(total_sales) AS top_10_sales
FROM top_10;

-- 10. sales growth rate (year-over-year)
WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS sales
    FROM sales
    GROUP BY year
)
SELECT 
    year,
    sales,
    LAG(sales) OVER (ORDER BY year) AS previous_year,
    ROUND(
        (sales - LAG(sales) OVER (ORDER BY year)) 
        / LAG(sales) OVER (ORDER BY year) * 100, 
        2
    ) AS growth_percent
FROM yearly_sales;

-- 11. Top cities by sales
SELECT 
    city,
    SUM(sales) AS total_sales
FROM sales
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;
