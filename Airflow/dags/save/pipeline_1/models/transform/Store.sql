{{config(materialized = "table")}}
SELECT 
    BusinessEntityID AS StoreID, 
    Name AS StoreName, 
    SalesPersonID
FROM {{ source('sales', 'Store')}}