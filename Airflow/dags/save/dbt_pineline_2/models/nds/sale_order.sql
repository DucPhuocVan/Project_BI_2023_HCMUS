WITH cte_usa_sale_order AS (
    SELECT
        SalesOrderID,
        CAST(OrderDate AS DATE) AS OrderDate,
        CAST(DueDate AS DATE) AS DueDate,
        CAST(ShipDate AS DATE) AS ShipDate,
        Status,
        OnlineOrderFlag,
        CustomerID,
        SalesPersonID,
        ShipToAddress,
        tr.TerritoryID,
        CASE 
            WHEN tr.TerritoryID = 6 THEN 'CAD'
            ELSE 'USD'
        END AS Currency,
        CreditCardID,
        SubTotal,
        TransportFee,
        TotalDue
    FROM {{ source('usa', 'USA_SalesOrderHeader')}} us
    LEFT JOIN {{ source('common', 'Territory')}} tr
    ON us.Territory = tr.Name
),
cte_europe_sale_order AS (
    SELECT
        SalesOrderID,
        CAST(OrderDate AS DATE) AS OrderDate,
        CAST(DueDate AS DATE) AS DueDate,
        CAST(ShipDate AS DATE) AS ShipDate,
        Status,
        OnlineOrderFlag,
        CustomerID,
        SalesPersonID,
        ShipToAddress,
        tr.TerritoryID,
        'EUR' AS Currency,
        CreditCardID,
        SubTotal,
        TransportFee,
        TotalDue
    FROM {{ source('eur', 'Europe_SalesOrderHeader')}} es
    LEFT JOIN {{ source('common', 'Territory')}} tr
    ON es.Territory = tr.Name
),
cte_fil_aus_sale_order AS (
    SELECT
        SalesOrderID,
        CAST(OrderDate AS DATE) AS OrderDate,
        CAST(DueDate AS DATE) AS DueDate,
        CAST(ShipDate AS DATE) AS ShipDate,
        Status,
        OnlineOrderFlag,
        CustomerID,
        SalesPersonID,
        ShipToAddress,
        'Australia' AS Territory,
        CreditCardID,
        SubTotal,
        TransportFee,
        TotalDue
    FROM {{ source('aus', 'Australia_SalesOrderHeader')}} aso
),
cte_australia_sale_order AS (
    SELECT
        SalesOrderID,
        OrderDate,
        DueDate,
        ShipDate,
        Status,
        OnlineOrderFlag,
        CustomerID,
        CASE
            WHEN SalesPersonID = '' THEN NULL 
            ELSE SalesPersonID
        END AS SalesPersonID,
        ShipToAddress,
        tr.TerritoryID,
        'AUD' AS Currency,
        CreditCardID,
        SubTotal,
        TransportFee,
        TotalDue
    FROM cte_fil_aus_sale_order aso
    LEFT JOIN {{ source('common', 'Territory')}} tr
    ON aso.Territory = tr.Name
),
cte_merge AS (
    SELECT * FROM cte_usa_sale_order
    UNION ALL
    SELECT * FROM cte_europe_sale_order
    UNION ALL
    SELECT * FROM cte_australia_sale_order
)
SELECT DISTINCT *
FROM cte_merge