{{config(
    materialized = 'table'
    , incremental_strategy = 'merge'
    , unique_key = 'SalesOrderDetailID'
    , merge_update_columns = ['OrderQty','ProductID','UnitPrice','LineTotal']
    , on_schema_change='append_new_columns'
)}}

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
{% if is_incremental() %}
    WHERE SalesOrderID IN (SELECT DISTINCT SalesOrderID FROM {{this}})
{% endif %}
