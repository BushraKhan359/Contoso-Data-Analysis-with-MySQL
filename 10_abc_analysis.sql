-- ============================================================
-- Q10. ABC ANALYSIS — Product Revenue Contribution
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================
-- Classifies products into tiers based on cumulative revenue contribution:
--   A = Top products driving 70% of revenue
--   B = Next tier driving 20% of revenue  
--   C = Remaining products driving 10% of revenue

WITH product_revenue AS (
    SELECT
        p.ProductKey,
        p.ProductName,
        pc.ProductCategoryName,
        ROUND(SUM(fs.salesamount))                   AS total_revenue
    FROM factsales fs
    JOIN dimproduct p USING (ProductKey)
    JOIN dimproductsubcategory ps USING (ProductSubcategoryKey)
    JOIN dimproductcategory pc USING (ProductCategoryKey)
    GROUP BY 1, 2, 3

    UNION ALL

    SELECT
        p.ProductKey,
        p.ProductName,
        pc.ProductCategoryName,
        ROUND(SUM(os.salesamount))                   AS total_revenue
    FROM factonlinesales os
    JOIN dimproduct p USING (ProductKey)
    JOIN dimproductsubcategory ps USING (ProductSubcategoryKey)
    JOIN dimproductcategory pc USING (ProductCategoryKey)
    GROUP BY 1, 2, 3
),
product_totals AS (
    SELECT
        ProductKey,
        ProductName,
        ProductCategoryName,
        SUM(total_revenue)                           AS total_revenue
    FROM product_revenue
    GROUP BY 1, 2, 3
),
ranked AS (
    SELECT
        *,
        SUM(total_revenue) OVER ()                   AS grand_total,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )                                            AS cumulative_revenue
    FROM product_totals
)
SELECT
    ProductKey,
    ProductName,
    ProductCategoryName,
    total_revenue,
    ROUND(total_revenue / grand_total * 100, 2)      AS pct_of_revenue,
    ROUND(cumulative_revenue / grand_total * 100, 2) AS cumulative_pct,
    CASE
        WHEN cumulative_revenue / grand_total <= 0.70 THEN 'A'
        WHEN cumulative_revenue / grand_total <= 0.90 THEN 'B'
        ELSE                                               'C'
    END                                              AS abc_tier
FROM ranked
ORDER BY total_revenue DESC;
