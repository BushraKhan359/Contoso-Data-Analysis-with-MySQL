-- ============================================================
-- Q6. RFM ANALYSIS — Person Customers Only
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================
-- Segments B2C customers by Recency, Frequency and Monetary value.
-- Note: Uses MAX(datekey) from the dataset as reference date (2009)
--       instead of CURRENT_DATE since this is historical data.
-- Note: Filtered to CustomerType = 'Person' (B2C only) and
--       minimum 2 purchases to exclude one-time buyers.

WITH rfm_base AS (
    SELECT 
        os.customerkey,
        c.CustomerLabel,
        (SELECT MAX(datekey) FROM factonlinesales)       AS dataset_max_date,
        MAX(os.datekey)                                  AS last_purchase_date,
        COUNT(DISTINCT os.SalesOrderNumber)              AS frequency,
        ROUND(SUM(os.salesamount))                       AS monetary
    FROM factonlinesales os
    JOIN dimcustomer c USING (CustomerKey)
    WHERE c.CustomerType = 'Person'
    GROUP BY 1, 2
    HAVING COUNT(DISTINCT os.SalesOrderNumber) >= 2
),
rfm_scored AS (
    SELECT
        customerkey,
        CustomerLabel,
        DATEDIFF(dataset_max_date, last_purchase_date)   AS recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (
            ORDER BY DATEDIFF(dataset_max_date, last_purchase_date) ASC
        )                                                AS R,
        NTILE(5) OVER (ORDER BY frequency DESC)          AS F,
        NTILE(5) OVER (ORDER BY monetary DESC)           AS M
    FROM rfm_base
)
SELECT
    customerkey,
    CustomerLabel,
    recency_days,
    frequency,
    monetary,
    R, F, M,
    CONCAT(R, F, M)                                      AS rfm_score,
    CASE
        WHEN R >= 4 AND F >= 4 AND M >= 4                THEN 'Champions'
        WHEN R >= 3 AND F >= 3                           THEN 'Loyal Customers'
        WHEN R >= 4 AND F <= 2                           THEN 'Recent Customers'
        WHEN R <= 2 AND F >= 3 AND M >= 3                THEN 'At Risk'
        WHEN R <= 2 AND F <= 2 AND M <= 2                THEN 'Lost'
        ELSE                                                  'Potential Loyalists'
    END                                                  AS customer_segment
FROM rfm_scored
ORDER BY monetary DESC;


-- ============================================================
-- RFM SEGMENT SUMMARY
-- ============================================================
WITH rfm_base AS (
    SELECT 
        os.customerkey,
        (SELECT MAX(datekey) FROM factonlinesales)       AS dataset_max_date,
        MAX(os.datekey)                                  AS last_purchase_date,
        COUNT(DISTINCT os.SalesOrderNumber)              AS frequency,
        ROUND(SUM(os.salesamount))                       AS monetary
    FROM factonlinesales os
    JOIN dimcustomer c USING (CustomerKey)
    WHERE c.CustomerType = 'Person'
    GROUP BY 1
    HAVING COUNT(DISTINCT os.SalesOrderNumber) >= 2
),
rfm_scored AS (
    SELECT
        customerkey,
        DATEDIFF(dataset_max_date, last_purchase_date)   AS recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (
            ORDER BY DATEDIFF(dataset_max_date, last_purchase_date) ASC
        )                                                AS R,
        NTILE(5) OVER (ORDER BY frequency DESC)          AS F,
        NTILE(5) OVER (ORDER BY monetary DESC)           AS M
    FROM rfm_base
),
rfm_segmented AS (
    SELECT
        customerkey,
        recency_days,
        frequency,
        monetary,
        CASE
            WHEN R >= 4 AND F >= 4 AND M >= 4            THEN 'Champions'
            WHEN R >= 3 AND F >= 3                       THEN 'Loyal Customers'
            WHEN R >= 4 AND F <= 2                       THEN 'Recent Customers'
            WHEN R <= 2 AND F >= 3 AND M >= 3            THEN 'At Risk'
            WHEN R <= 2 AND F <= 2 AND M <= 2            THEN 'Lost'
            ELSE                                              'Potential Loyalists'
        END                                              AS customer_segment
    FROM rfm_scored
)
SELECT 
    customer_segment,
    COUNT(*)                                             AS customer_count,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 1)    AS pct_of_customers,
    ROUND(AVG(recency_days))                             AS avg_recency_days,
    ROUND(AVG(frequency))                               AS avg_orders,
    ROUND(AVG(monetary))                                AS avg_spend
FROM rfm_segmented
GROUP BY 1
ORDER BY customer_count DESC;
