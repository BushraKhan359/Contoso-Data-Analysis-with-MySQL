-- ============================================================
-- Q8. CUSTOMER DEMOGRAPHICS ANALYSIS
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

-- Revenue and profit by age group and gender
-- Note: Age calculated using 2009 as reference year (dataset end date)
-- Note: NULL gender rows represent Company-type customers (no gender on file)
WITH customer_demo AS (
    SELECT
        c.CustomerKey,
        c.CustomerType,
        c.Gender,
        CASE
            WHEN (2009 - YEAR(c.BirthDate)) < 35    THEN 'Young Adult'
            WHEN (2009 - YEAR(c.BirthDate)) < 55    THEN 'Middle Age'
            ELSE                                          'Senior'
        END                                          AS AgeGroup,
        os.salesamount,
        os.TotalCost
    FROM factonlinesales os
    JOIN dimcustomer c USING (CustomerKey)
)
SELECT
    CustomerType,
    Gender,
    AgeGroup,
    COUNT(DISTINCT CustomerKey)                      AS total_customers,
    ROUND(SUM(salesamount))                          AS total_revenue,
    ROUND(SUM(salesamount) - SUM(TotalCost))         AS total_profit,
    ROUND((SUM(salesamount) - SUM(TotalCost))
          / SUM(salesamount) * 100, 1)              AS profit_margin_pct
FROM customer_demo
GROUP BY 1, 2, 3
ORDER BY total_revenue DESC;
