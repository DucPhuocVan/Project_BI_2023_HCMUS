{{config(
    materialized = 'table'
    , on_schema_change='append_new_columns'
)}}

WITH cte_usa_store AS (
    SELECT
        StoreID,
        StoreName,
        SalesPersonID
    FROM {{ source('usa', 'USA_Store')}}
),
cte_europe_store AS (
    SELECT
        StoreID,
        StoreName,
        SalesPersonID
    FROM {{ source('eur', 'Europe_Store')}}
),
cte_australia_store AS (
    SELECT
        StoreID,
        StoreName,
        SalesPersonID
    FROM {{ source('aus', 'Australia_Store')}}
),
cte_merge AS (
    SELECT * FROM cte_usa_store
    UNION ALL
    SELECT * FROM cte_europe_store
    UNION ALL
    SELECT * FROM cte_australia_store
)
SELECT DISTINCT *
FROM cte_merge
WHERE StoreID IS NOT NULL
-- {% if is_incremental() %}
--     AND StoreID IN (SELECT StoreID FROM {{this}})
-- {% endif %}