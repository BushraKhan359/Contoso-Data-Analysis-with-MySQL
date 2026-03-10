-- ============================================================
-- Q9. COHORT ANALYSIS — Monthly Customer Retention
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

WITH first_purchase AS (
    SELECT
        CustomerKey,
        DATE_FORMAT(MIN(datekey), '%Y-%m-01')        AS cohort_month
    FROM factonlinesales
    GROUP BY 1
),
monthly_activity AS (
    SELECT DISTINCT
        os.CustomerKey,
        DATE_FORMAT(os.datekey, '%Y-%m-01')          AS activity_month
    FROM factonlinesales os
),
cohort_data AS (
    SELECT
        fp.cohort_month,
        ma.activity_month,
        TIMESTAMPDIFF(MONTH, fp.cohort_month,
                      ma.activity_month)             AS month_number,
        COUNT(DISTINCT ma.CustomerKey)               AS active_customers
    FROM first_purchase fp
    JOIN monthly_activity ma USING (CustomerKey)
    GROUP BY 1, 2, 3
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT CustomerKey)                  AS cohort_customers
    FROM first_purchase
    GROUP BY 1
)
SELECT
    cd.cohort_month,
    cs.cohort_customers,
    cd.month_number,
    cd.active_customers,
    ROUND(cd.active_customers / cs.cohort_customers * 100, 1) AS retention_rate
FROM cohort_data cd
JOIN cohort_size cs USING (cohort_month)
ORDER BY cd.cohort_month, cd.month_number;
