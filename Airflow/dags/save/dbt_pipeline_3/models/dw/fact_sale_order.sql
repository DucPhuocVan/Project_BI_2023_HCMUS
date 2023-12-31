WITH cte_first_customer AS (
    SELECT DISTINCT
        CustomerID,
        OrderDate,
        MIN(OrderDate) OVER (PARTITION BY CustomerID) AS first_order_date
    FROM {{source('nds', 'sale_order')}} 
),
cte_sale_order_flag AS (
    SELECT
        so.*,
        CASE 
            WHEN so.OrderDate = fc.first_order_date THEN 1
            ELSE 0
        END AS is_new_customer
    FROM {{source('nds', 'sale_order')}} so
    LEFT JOIN cte_first_customer fc 
        ON so.CustomerID = fc.CustomerID
        AND so.OrderDate = fc.OrderDate
) 
SELECT
    so.OrderDate AS date_code,
    so.SalesPersonID AS employee_code,
    so.TerritoryID AS territory_code,
    SUM(so.TotalDue) * cr.ExchangeRate AS revenue,
    COUNT(DISTINCT so.SalesOrderID) AS number_order,
    -- Order online
    CASE
        WHEN so.OnlineOrderFlag = 1 THEN SUM(so.TotalDue) * cr.ExchangeRate
        ELSE 0
    END AS revenue_online,
    CASE
        WHEN so.OnlineOrderFlag = 1 THEN COUNT(DISTINCT so.SalesOrderID)
        ELSE 0
    END AS number_order_online,
    -- Order offline
    CASE
        WHEN so.OnlineOrderFlag = 0 THEN SUM(so.TotalDue) * cr.ExchangeRate
        ELSE 0
    END AS revenue_offline,
    CASE
        WHEN so.OnlineOrderFlag = 0 THEN COUNT(DISTINCT so.SalesOrderID)
        ELSE 0
    END AS number_order_offline,
    -- New/return customer
    CASE
        WHEN so.is_new_customer = 1 THEN COUNT(DISTINCT so.CustomerID)
        ELSE 0
    END AS number_new_customer,
    CASE
        WHEN so.is_new_customer = 0 THEN COUNT(DISTINCT so.CustomerID)
        ELSE 0
    END AS number_return_customer
FROM cte_sale_order_flag so
LEFT JOIN {{source('nds', 'currency_rate')}} cr 
    ON so.OrderDate = cr.CurrencyRateDate
    AND so.Currency = cr.ToCurrencyCode
WHERE so.OrderDate <= '2014-05-31'
GROUP BY 
    so.OrderDate,
    so.SalesPersonID,
    so.TerritoryID,
    cr.ExchangeRate,
    so.OnlineOrderFlag,
    so.is_new_customer
