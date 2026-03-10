-- ============================================================
-- Q7. CUSTOMER LIFETIME VALUE (CLV)
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

-- Estimates CLV per customer based on total spend and tenure
SELECT
    c.CustomerKey,
    c.CustomerLabel,
    c.CustomerType,
    COUNT(DISTINCT os.SalesOrderNumber)                          AS total_orders,
    ROUND(SUM(os.salesamount))                                   AS total_spend,
    ROUND(
        DATEDIFF(MAX(os.datekey), MIN(os.datekey)) / 365.0, 2
    )                                                            AS customer_tenure_years,
    ROUND(
        SUM(os.salesamount) /
        NULLIF(DATEDIFF(MAX(os.datekey), MIN(os.datekey)) / 365.0, 0)
    )                                                            AS estimated_clv
FROM factonlinesales os
JOIN dimcustomer c USING (CustomerKey)
GROUP BY 1, 2, 3
ORDER BY estimated_clv DESC
LIMIT 50;
