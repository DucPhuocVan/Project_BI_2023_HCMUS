{{config(materialized = "table")}}
SELECT
    SalesOrderID, 
	OrderDate, 
	DueDate, 
	ShipDate, 
	Status, 
	OnlineOrderFlag, 
	SalesOrderNumber, 
	CustomerID, 
    SalesPersonID,
	CONCAT(p.FirstName,' ',p.MiddleName,' ',p.LastName) AS SalesName, 
	st.Name AS Territory, 
	BillToAddressID, 
	ShipToAddressID, 
	ShipMethodID, 
	CreditCardID, 
	CurrencyRateID, 
	SubTotal, 
	Freight AS TransportFee, 
	TotalDue
FROM {{ source('sales', 'SalesOrderHeader')}} so
LEFT JOIN {{ source('sales', 'SalesPerson')}} sp 
	ON so.SalesPersonID = sp.BusinessEntityID 
LEFT JOIN {{ source('person', 'Person')}} p 
	ON sp.BusinessEntityID = p.BusinessEntityID 
LEFT JOIN {{ source('sales', 'SalesTerritory')}} st 
	ON so.TerritoryID = st.TerritoryID