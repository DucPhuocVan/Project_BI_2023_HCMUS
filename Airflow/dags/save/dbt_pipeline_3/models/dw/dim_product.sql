{{config(
    materialized = 'incremental'
    , incremental_strategy = 'merge'
    , unique_key = ['product_code']
    , merge_update_columns = ['product_name','product_color','product_size','standard_cost','price','sub_category','product_category']
    , on_schema_change='append_new_columns'
)}}
SELECT 
    ProductID AS product_code,
    Product AS product_name,
    Color AS product_color,
    Size AS product_size,
    StandardCost AS standard_cost,
    ListPrice AS price,
    Subcategory AS sub_category,
    ProductCategory AS product_category
FROM {{ source('nds', 'product')}} 
{% if is_incremental() %}
    WHERE ProductID IN (SELECT DISTINCT product_code FROM {{this}})
{% endif %}