-- ============================================================
-- Q3. CUSTOMER SEGMENTATION — Top Customers & B2B vs B2C
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

-- Q3a. Top 20 customers by total spend
SELECT
    c.CustomerKey,
    c.CustomerLabel,
    c.CustomerType,
    COUNT(DISTINCT os.SalesOrderNumber)              AS total_orders,
    ROUND(SUM(os.salesamount))                       AS total_spend
FROM factonlinesales os
JOIN dimcustomer c USING (CustomerKey)
GROUP BY 1, 2, 3
ORDER BY total_spend DESC
LIMIT 20;


-- Q3b. B2B vs B2C revenue and order comparison
SELECT
    c.CustomerType,
    c.CustomerLabel,
    COUNT(DISTINCT os.SalesOrderNumber)              AS total_orders,
    ROUND(SUM(os.salesamount))                       AS total_revenue
FROM factonlinesales os
JOIN dimcustomer c USING (CustomerKey)
GROUP BY 1, 2
ORDER BY total_revenue DESC;
