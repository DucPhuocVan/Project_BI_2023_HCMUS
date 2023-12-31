{{config(
    materialized = 'table'
    , on_schema_change='append_new_columns'
)}}
SELECT DISTINCT
    OrderDate AS date_code,
    MONTH(OrderDate) AS month,
    DATEPART(QUARTER, OrderDate) AS quarter,
    YEAR(OrderDate) AS year
FROM {{source('nds', 'sale_order')}} 