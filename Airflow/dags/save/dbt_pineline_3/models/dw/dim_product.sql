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