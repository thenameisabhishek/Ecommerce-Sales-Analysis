-- =====================================================
-- E-commerce Sales Analysis: Business Insight Queries
-- =====================================================

-- 1. Total revenue and profit by year
SELECT
    Order_Year,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit
FROM orders
GROUP BY Order_Year
ORDER BY Order_Year;

-- 2. Revenue by Product Category
SELECT
    Product_Category,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit,
    COUNT(*) AS order_count
FROM orders
GROUP BY Product_Category
ORDER BY total_sales DESC;

-- 3. Revenue by Region
SELECT
    Region,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit,
    ROUND(100.0 * SUM(Profit) / SUM(Sales), 2) AS profit_margin_pct
FROM orders
GROUP BY Region
ORDER BY total_sales DESC;

-- 4. Top 10 Product Sub-Categories by revenue
SELECT
    Product_Sub_Category,
    ROUND(SUM(Sales),2) AS total_sales,
    COUNT(*) AS order_count
FROM orders
GROUP BY Product_Sub_Category
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Discount vs Profit relationship (bucketed)
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.1 THEN 'Low (0-10%)'
        WHEN Discount <= 0.3 THEN 'Medium (10-30%)'
        ELSE 'High (30%+)'
    END AS discount_band,
    COUNT(*) AS order_count,
    ROUND(AVG(Profit),2) AS avg_profit,
    ROUND(SUM(Profit),2) AS total_profit
FROM orders
GROUP BY discount_band
ORDER BY avg_profit DESC;

-- 6. Customer Segment performance
SELECT
    Customer_Segment,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit,
    COUNT(DISTINCT Customer_Name) AS unique_customers
FROM orders
GROUP BY Customer_Segment
ORDER BY total_sales DESC;

-- 7. Ship Mode usage and average shipping cost
SELECT
    Ship_Mode,
    COUNT(*) AS order_count,
    ROUND(AVG(Shipping_Cost),2) AS avg_shipping_cost
FROM orders
GROUP BY Ship_Mode
ORDER BY order_count DESC;

-- 8. Order Priority distribution
SELECT
    Order_Priority,
    COUNT(*) AS order_count,
    ROUND(AVG(Profit),2) AS avg_profit
FROM orders
GROUP BY Order_Priority
ORDER BY order_count DESC;

-- 9. Top 10 customers by total sales
SELECT
    Customer_Name,
    ROUND(SUM(Sales),2) AS total_sales,
    COUNT(*) AS order_count
FROM orders
GROUP BY Customer_Name
ORDER BY total_sales DESC
LIMIT 10;

-- 10. Monthly sales trend (all years combined)
SELECT
    Order_Year, Order_Month,
    ROUND(SUM(Sales),2) AS total_sales
FROM orders
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

-- 11. Loss-making orders by category
SELECT
    Product_Category,
    COUNT(*) AS loss_orders,
    ROUND(SUM(Profit),2) AS total_loss
FROM orders
WHERE Profit < 0
GROUP BY Product_Category
ORDER BY total_loss ASC;

-- 12. Profit margin by Product Sub-Category (top 5 healthiest)
SELECT
    Product_Sub_Category,
    ROUND(100.0 * SUM(Profit) / SUM(Sales), 2) AS profit_margin_pct,
    ROUND(SUM(Sales),2) AS total_sales
FROM orders
GROUP BY Product_Sub_Category
HAVING SUM(Sales) > 10000
ORDER BY profit_margin_pct DESC
LIMIT 5;

-- 13. Province-wise top 5 performers
SELECT
    Province,
    ROUND(SUM(Sales),2) AS total_sales
FROM orders
GROUP BY Province
ORDER BY total_sales DESC
LIMIT 5;

-- 14. Average order value by Customer Segment
SELECT
    Customer_Segment,
    ROUND(AVG(Sales),2) AS avg_order_value
FROM orders
GROUP BY Customer_Segment
ORDER BY avg_order_value DESC;

-- 15. Region + Category combined - top 5 revenue combos
SELECT
    Region, Product_Category,
    ROUND(SUM(Sales),2) AS total_sales
FROM orders
GROUP BY Region, Product_Category
ORDER BY total_sales DESC
LIMIT 5;

-- 16. Product Container usage
SELECT
    Product_Container,
    COUNT(*) AS order_count,
    ROUND(AVG(Shipping_Cost),2) AS avg_shipping_cost
FROM orders
GROUP BY Product_Container
ORDER BY order_count DESC;

-- 17. Year-over-year sales growth
SELECT
    Order_Year,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY Order_Year), 2) AS yoy_change
FROM orders
GROUP BY Order_Year
ORDER BY Order_Year;
