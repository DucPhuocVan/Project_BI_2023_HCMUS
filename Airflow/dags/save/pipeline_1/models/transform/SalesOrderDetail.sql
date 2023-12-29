{{config(materialized = "table")}}
SELECT 
	SalesOrderID, 
	SalesOrderDetailID, 
	OrderQty, 
	ProductID, 
	UnitPrice, 
	LineTotal
FROM {{ source('sales', 'SalesOrderDetail')}}