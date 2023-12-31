{{config(
    materialized = 'incremental'
    , incremental_strategy = 'merge'
    , unique_key = 'customer_code'
    , merge_update_columns = ['customer_name','phone_number','email_address','territory_country','territory_group']
    , on_schema_change='append_new_columns'
)}}
SELECT 
    c.CustomerID AS customer_code,
    c.CustomerName AS customer_name,
    c.PhoneNumber AS phone_number,
    c.EmailAddress AS email_address,
    t.territory_country,
    t.territory_group
FROM {{ source('nds', 'customer')}} c
LEFT JOIN {{ref('dim_territory')}} t 
    ON c.TerritoryID = t.territory_code
{% if is_incremental() %}
    AND CustomerID IN (SELECT DISTINCT customer_code FROM {{this}})
{% endif %}