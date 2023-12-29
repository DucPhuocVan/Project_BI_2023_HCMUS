WITH cte_usa_product AS (
    SELECT
        ProductID,
        Product,
        ProductNumber,
        Color,
        ROUND(StandardCost, 2) AS StandardCost,
        ROUND(ListPrice, 2) AS ListPrice,
        Size,
        SubCategory,
        ProductCategory
    FROM {{ source('usa', 'USA_Product')}}
),
cte_europe_product AS (
    SELECT
        ProductID,
        Product,
        ProductNumber,
        Color,
        ROUND(StandardCost, 2) AS StandardCost,
        ROUND(ListPrice, 2) AS ListPrice,
        Size,
        SubCategory,
        ProductCategory
    FROM {{ source('eur', 'Europe_Product')}}
),
cte_australia_product AS (
    SELECT
        ProductID,
        Product,
        ProductNumber,
        Color,
        ROUND(StandardCost, 2) AS StandardCost,
        ROUND(ListPrice, 2) AS ListPrice,
        Size,
        SubCategory,
        ProductCategory
    FROM {{ source('aus', 'Australia_Product')}}
),
cte_merge AS (
    SELECT * FROM cte_usa_product
    UNION ALL
    SELECT * FROM cte_europe_product
    UNION ALL
    SELECT * FROM cte_australia_product
),
cte_row_number AS (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY StandardCost) AS rn
    FROM cte_merge
)
SELECT *
FROM cte_row_number
WHERE rn = 1