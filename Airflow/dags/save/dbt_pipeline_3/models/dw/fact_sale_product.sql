
WITH cte_sale_order_detail AS (
    SELECT
        sod.*,
        so.Currency,
        so.TerritoryID,
        so.OrderDate,
        so.CustomerID,
        so.OnlineOrderFlag
    FROM {{source('nds', 'sale_order_detail')}} sod
    LEFT JOIN {{source('nds', 'sale_order')}} so
        ON sod.SalesOrderID = so.SalesOrderID
)
SELECT
    sod.OrderDate AS date_code,
    sod.TerritoryID AS territory_code,
    sod.ProductID AS product_code,
    sod.CustomerID AS customer_code,
    SUM(sod.LineTotal) * cr.ExchangeRate AS revenue_product,
    CASE
        WHEN sod.OnlineOrderFlag = 1 THEN SUM(sod.LineTotal) * cr.ExchangeRate
        ELSE 0
    END AS revenue_product_online,
    CASE
        WHEN sod.OnlineOrderFlag = 0 THEN SUM(sod.LineTotal) * cr.ExchangeRate
        ELSE 0
    END AS revenue_product_offline
FROM cte_sale_order_detail sod
LEFT JOIN {{source('nds', 'currency_rate')}} cr 
    ON sod.OrderDate = cr.CurrencyRateDate
    AND sod.Currency = cr.ToCurrencyCode
WHERE sod.OrderDate <= '2014-05-31'
GROUP BY 
    sod.OrderDate,
    sod.TerritoryID,
    sod.ProductID,
    sod.CustomerID,
    cr.ExchangeRate,
    sod.OnlineOrderFlag
