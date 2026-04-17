-- 📊 Sales Analysis SQL Queries
-- This file contains queries used for sales performance and revenue analysis

-- 1. Total revenue and number of orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue
FROM sales;

-- 2. Average order value
SELECT 
    SUM(revenue) / COUNT(DISTINCT order_id) AS avg_order_value
FROM sales;

-- 3. Revenue by year
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY year
ORDER BY year;

-- 4. Monthly sales (seasonality)
SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY month
ORDER BY month;

-- 5. Revenue by category
SELECT 
    category,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- 6. Top 10 products by revenue
SELECT 
    product_name,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 7. Revenue by region (states)
SELECT 
    state,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY state
ORDER BY total_revenue DESC;

-- 8. Top 3 regions contribution (CTE)
WITH top_regions AS (
    SELECT 
        state,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY state
    ORDER BY total_revenue DESC
    LIMIT 3
)
SELECT 
    SUM(total_revenue) AS top_3_revenue
FROM top_regions;

-- 9. Share of top 10 products (CTE)
WITH product_revenue AS (
    SELECT 
        product_name,
        SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY product_name
),
top_10 AS (
    SELECT *
    FROM product_revenue
    ORDER BY total_revenue DESC
    LIMIT 10
)
SELECT 
    SUM(total_revenue) AS top_10_revenue
FROM top_10;

-- 10. Revenue growth rate (year-over-year)
WITH yearly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY year
)
SELECT 
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS previous_year,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year)) 
        / LAG(revenue) OVER (ORDER BY year) * 100, 
        2
    ) AS growth_percent
FROM yearly_revenue;

-- 11. Top cities by revenue
SELECT 
    city,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 10;
