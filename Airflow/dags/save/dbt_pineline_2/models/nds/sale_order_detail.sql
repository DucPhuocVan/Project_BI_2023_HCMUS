WITH cte_usa_sale_order_detail AS (
    SELECT
        SalesOrderID,
        SalesOrderDetailID,
        OrderQty,
        ProductID,
        UnitPrice,
        LineTotal
    FROM {{ source('usa', 'USA_SalesOrderDetail')}} us
),
cte_europe_sale_order_detail AS (
    SELECT
        SalesOrderID,
        SalesOrderDetailID,
        OrderQty,
        ProductID,
        UnitPrice,
        LineTotal
    FROM {{ source('eur', 'Europe_SalesOrderDetail')}} es
),
cte_australia_sale_order_detail AS (
    SELECT
        SalesOrderID,
        SalesOrderDetailID,
        OrderQty,
        ProductID,
        UnitPrice,
        LineTotal
    FROM {{ source('aus', 'Australia_SalesOrderDetail')}} aso
),
cte_merge AS (
    SELECT * FROM cte_usa_sale_order_detail
    UNION ALL
    SELECT * FROM cte_europe_sale_order_detail
    UNION ALL
    SELECT * FROM cte_australia_sale_order_detail
)
SELECT DISTINCT *
FROM cte_merge