-- =====================================================
-- E-commerce Sales Analysis: Data Cleaning & Setup
-- =====================================================

-- 1. Total record count
SELECT COUNT(*) AS total_orders FROM orders;

-- 2. Check for missing values in key numeric columns
SELECT
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN Product_Base_Margin IS NULL THEN 1 ELSE 0 END) AS null_base_margin
FROM orders;

-- 3. Date range check
SELECT MIN(Order_Date) AS earliest_order, MAX(Order_Date) AS latest_order FROM orders;

-- 4. Distinct categorical values (sanity check)
SELECT DISTINCT Product_Category FROM orders;
SELECT DISTINCT Region FROM orders;
SELECT DISTINCT Customer_Segment FROM orders;

-- 5. Basic descriptive stats
SELECT
    ROUND(MIN(Sales),2) AS min_sales, ROUND(MAX(Sales),2) AS max_sales, ROUND(AVG(Sales),2) AS avg_sales,
    ROUND(MIN(Profit),2) AS min_profit, ROUND(MAX(Profit),2) AS max_profit, ROUND(AVG(Profit),2) AS avg_profit
FROM orders;

-- 6. Orders with negative profit (loss-making orders)
SELECT COUNT(*) AS loss_making_orders
FROM orders
WHERE Profit < 0;
