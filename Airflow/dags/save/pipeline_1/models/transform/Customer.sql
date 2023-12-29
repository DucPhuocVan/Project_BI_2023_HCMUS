{{config(materialized = "table")}}
SELECT 
	CustomerID, 
	PersonID, 
	StoreID, 
	st.Name AS SalesTerritory
FROM {{ source('sales', 'Customer')}} c
LEFT JOIN {{ source('sales', 'SalesTerritory')}} st 
	ON c.TerritoryID = st.TerritoryID