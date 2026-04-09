/* =========================================================
   Project: Customer Spending & Credit Card Analysis
   Author: Abdul Russel Sarkar
   Description: SQL queries for data cleaning, transformation,
                and analysis used in Power BI dashboard
   ========================================================= */


/* =========================
   1. DATA VALIDATION
   ========================= */

-- Check null values in spends
SELECT COUNT(*) AS null_spend_count
FROM fact_spends
WHERE spend IS NULL;

-- Check duplicate customers
SELECT customer_id, COUNT(*) AS count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


/* =========================
   2. MAIN DATASET (JOIN)
   ========================= */

-- Create final dataset for Power BI
SELECT 
    c.customer_id,
    c.age_group,
    c.city,
    c.occupation,
    c.gender,
    c.marital_status,
    c.average_income,
    f.month,
    f.category,
    f.payment_type,
    f.spend
FROM dim_customers c
JOIN fact_spends f
ON c.customer_id = f.customer_id;


/* =========================
   3. KEY METRICS
   ========================= */

-- Total Spend
SELECT SUM(spend) AS total_spend
FROM fact_spends;

-- Average Spend per Customer
SELECT 
    customer_id,
    AVG(spend) AS avg_spend
FROM fact_spends
GROUP BY customer_id;

-- Income Utilization Percentage (Main KPI)
SELECT 
    c.customer_id,
    ROUND(SUM(f.spend) / c.average_income * 100, 2) AS income_utilization_pct
FROM dim_customers c
JOIN fact_spends f
ON c.customer_id = f.customer_id
GROUP BY c.customer_id, c.average_income;


/* =========================
   4. BUSINESS ANALYSIS
   ========================= */

-- Spending by Category
SELECT 
    category,
    SUM(spend) AS total_spend
FROM fact_spends
GROUP BY category
ORDER BY total_spend DESC;

-- Spending by City
SELECT 
    c.city,
    SUM(f.spend) AS total_spend
FROM dim_customers c
JOIN fact_spends f
ON c.customer_id = f.customer_id
GROUP BY c.city
ORDER BY total_spend DESC;

-- Spending by Payment Type
SELECT 
    payment_type,
    SUM(spend) AS total_spend
FROM fact_spends
GROUP BY payment_type
ORDER BY total_spend DESC;

-- Monthly Spending Trend
SELECT 
    month,
    SUM(spend) AS total_spend
FROM fact_spends
GROUP BY month;

-- Spending by Age Group
SELECT 
    c.age_group,
    SUM(f.spend) AS total_spend
FROM dim_customers c
JOIN fact_spends f
ON c.customer_id = f.customer_id
GROUP BY c.age_group
ORDER BY total_spend DESC;


/* =========================
   5. CUSTOMER SEGMENTATION
   ========================= */

-- Segment customers based on spending
SELECT 
    c.customer_id,
    SUM(f.spend) AS total_spend,
    CASE 
        WHEN SUM(f.spend) > 100000 THEN 'High Value'
        WHEN SUM(f.spend) > 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM dim_customers c
JOIN fact_spends f
ON c.customer_id = f.customer_id
GROUP BY c.customer_id;


/* =========================
   END OF FILE
   ========================= */
