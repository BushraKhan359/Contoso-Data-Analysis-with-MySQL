-- ============================================================
-- Q4. SALES CHANNEL ANALYSIS
-- Author: Bushra Khan | thedataalchemist.co
-- Dataset: Contoso Retail Data Warehouse (MySQL)
-- ============================================================

-- Revenue, profit and margin by sales channel
WITH all_sales AS (
    SELECT
        ch.ChannelName,
        fs.salesamount,
        fs.TotalCost
    FROM factsales fs
    JOIN dimchannel ch USING (ChannelKey)

    UNION ALL

    SELECT
        'Online'                                     AS ChannelName,
        os.salesamount,
        os.TotalCost
    FROM factonlinesales os
)
SELECT
    ChannelName,
    ROUND(SUM(salesamount) / 1e9, 2)                AS revenue_bn,
    ROUND((SUM(salesamount) - SUM(TotalCost))
          / 1e9, 2)                                 AS profit_bn,
    ROUND((SUM(salesamount) - SUM(TotalCost))
          / SUM(salesamount) * 100, 1)              AS profit_margin_pct
FROM all_sales
GROUP BY 1
ORDER BY revenue_bn DESC;
