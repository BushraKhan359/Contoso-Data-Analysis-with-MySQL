-- ============================================================
-- Q5. REGIONAL SALES ANALYSIS
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

-- Revenue and profit by country (all channels combined)
WITH all_sales AS (
    SELECT
        g.RegionCountryName,
        fs.salesamount,
        fs.TotalCost
    FROM factsales fs
    JOIN dimstore st USING (StoreKey)
    JOIN dimgeography g USING (GeographyKey)

    UNION ALL

    SELECT
        g.RegionCountryName,
        os.salesamount,
        os.TotalCost
    FROM factonlinesales os
    JOIN dimcustomer c USING (CustomerKey)
    JOIN dimgeography g USING (GeographyKey)
)
SELECT
    RegionCountryName,
    ROUND(SUM(salesamount) / 1e9, 2)                AS revenue_bn,
    ROUND((SUM(salesamount) - SUM(TotalCost))
          / 1e9, 2)                                 AS profit_bn,
    ROUND((SUM(salesamount) - SUM(TotalCost))
          / SUM(salesamount) * 100, 1)              AS profit_margin_pct
FROM all_sales
GROUP BY 1
ORDER BY revenue_bn DESC;
