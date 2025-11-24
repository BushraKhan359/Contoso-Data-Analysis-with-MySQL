-- 1. What are the total sales and profit trends over time
-- step0: join date table for readable date format and 
-- step1: figure out the total sales
-- step2: break down total sales on yearly basis
SELECT 
	-- d.calendaryear, -- dimdate table have aggregated data, 
    -- d.calendarmonthlabel,
	YEAR(datekey) AS year, -- extract out year from dateky coulum
    MONTH(DateKey) AS month, -- extract month and group on year and month 
    SUM(os.SalesAmount) AS total_sales_revenue, -- sales amount is what customer paid (contoso earned)
    SUM(os.TotalCost) AS total_cost, -- product sourcing price paid by contoso
    -- calculate profit
    (SUM(os.SalesAmount)-SUM(os.TotalCost)) AS profit
FROM factonlinesales os
LEFT JOIN dimdate d
	USING (DateKey)
WHERE 
	d.CalendarYear = '2007' 
	AND d.CalendarQuarterLabel = 'q1'
GROUP BY 1, 2
ORDER BY profit;


-- 2. Which product categories generate the highest revenue and profit margins
-- step1: need to break down/group by the profit and revenue based on product key
CREATE TEMPORARY TABLE ProductKeyData
SELECT 
	count(distinct p.ProductKey) AS productKey,
    p.ProductSubcategoryKey,
    SUM(os.SalesAmount) AS total_sales_revenue, -- sales amount is what customer paid (contoso earned)
    SUM(os.TotalCost) AS total_cost, -- product sourcing price paid by contoso
    -- calculate profit
    (SUM(os.SalesAmount)-SUM(os.TotalCost)) AS profit
    
FROM factonlinesales os
LEFT JOIN dimproduct p 
	USING (productkey)
Group By p.ProductSubcategoryKey;

-- step2: bring in the product category details by joining the product key data from above table, with sub category table
CREATE TEMPORARY TABLE ProductCategory_key
SELECT 
	ps.ProductCategoryKey,
    pd.total_sales_revenue, 
    pd.total_cost,
    pd.profit
FROM ProductKeyData pd
LEFT JOIN dimproductsubcategory ps
	USING (ProductSubcategoryKey)
;

-- step3: join the productcategory_key table with dim productcategory table to know the product category name
SELECT 
	pk.ProductCategoryKey,
    pc.ProductCategoryName,
    pk.total_sales_revenue, 
    pk.total_cost,
    pk.profit
FROM ProductCategory_key pk
LEFT JOIN dimproductcategory pc
	USING (ProductCategoryKey)
ORDER BY pk.ProductCategoryKey
;

-- 3. Who are our top customers by total spend and purchase frequency?

SELECT *
FROM (
    SELECT 
        customerkey,
        SUM(salesamount) AS total_spend,
        COUNT(DISTINCT salesordernumber) AS purchase_frequency,
        DENSE_RANK() OVER (ORDER BY SUM(salesamount) DESC) AS spend_rank,
        DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT salesordernumber) DESC) AS frequency_rank
    FROM factonlinesales
    GROUP BY customerkey
) ranked
WHERE spend_rank <= 5 OR frequency_rank <= 5

-- 4. Which sales channels (Store, Online, Reseller) are most profitable

-- 5. What regions or territories contribute most to sales and growth?

