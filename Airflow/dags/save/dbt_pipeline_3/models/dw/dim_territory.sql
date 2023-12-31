{{config(
    materialized = 'incremental'
    , incremental_strategy = 'merge'
    , unique_key = 'territory_code'
    , merge_update_columns = ['territory_name','country_region_code','territory_group','territory_country']
    , on_schema_change='append_new_columns'
)}}

SELECT 
    TerritoryID AS territory_code,
    Name AS territory_name,
    CountryRegionCode AS country_region_code,
    [Group] AS territory_group,
    CountryRegion AS territory_country
FROM {{source('nds', 'territory')}} 
{% if is_incremental() %}
    WHERE TerritoryID IN (SELECT DISTINCT territory_code FROM {{this}})
{% endif %}