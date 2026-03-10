-- ============================================================
-- Q2. PRODUCT CATEGORY ANALYSIS
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

-- Which product categories generate the highest revenue and profit?
WITH product_category_data AS (
    SELECT 
        p.productkey,
        pc.ProductCategoryName,
        fs.salesamount,
        fs.TotalCost
    FROM factsales fs
    JOIN dimproduct p USING (ProductKey)
    JOIN dimproductsubcategory ps USING (ProductSubcategoryKey)
    JOIN dimproductcategory pc USING (ProductCategoryKey)

    UNION ALL

    SELECT 
        p.productkey,
        pc.ProductCategoryName,
        os.salesamount,
        os.TotalCost
    FROM factonlinesales os
    JOIN dimproduct p USING (ProductKey)
    JOIN dimproductsubcategory ps USING (ProductSubcategoryKey)
    JOIN dimproductcategory pc USING (ProductCategoryKey)
)
SELECT
    ProductCategoryName,
    COUNT(DISTINCT productkey)                               AS total_products,
    ROUND(SUM(salesamount) / 1e9, 2)                        AS revenue_bn,
    ROUND((SUM(salesamount) - SUM(TotalCost)) / 1e9, 2)     AS profit_bn,
    ROUND((SUM(salesamount) - SUM(TotalCost))
          / SUM(salesamount) * 100, 1)                      AS profit_margin_pct
FROM product_category_data
GROUP BY 1
ORDER BY profit_bn DESC;
