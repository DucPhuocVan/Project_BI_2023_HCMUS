{{config(
    materialized = 'table'
    , on_schema_change='append_new_columns'
)}}

SELECT *
FROM {{source('common', 'Territory')}}
-- {% if is_incremental() %}
--     WHERE TerritoryID IN (SELECT DISTINCT TerritoryID FROM {{this}})
--     AND CountryRegionCode IN (SELECT DISTINCT CountryRegionCode FROM {{this}})
-- {% endif %}