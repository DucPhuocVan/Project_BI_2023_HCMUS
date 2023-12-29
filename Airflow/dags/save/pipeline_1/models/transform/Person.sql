{{config(materialized = "table")}}
SELECT 
	p.BusinessEntityID AS PersonID, 
	FirstName, 
	MiddleName, 
	LastName, 
	pp.PhoneNumber, 
	ea.EmailAddress, 
	st.Name AS Territory
FROM {{ source('person', 'Person')}} p
LEFT JOIN {{ source('person', 'PersonPhone')}} pp
	ON p.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN {{ source('person', 'EmailAddress')}} ea
	ON p.BusinessEntityID = ea.BusinessEntityID 
LEFT JOIN {{ source('person', 'BusinessEntityContact')}} bc
	ON p.BusinessEntityID = bc.BusinessEntityID
LEFT JOIN {{ source('person', 'BusinessEntityAddress')}} ba 
	ON p.BusinessEntityID = ba.BusinessEntityID
LEFT JOIN {{ source('person', 'Address')}} a
	ON ba.AddressID = a.AddressID 
LEFT JOIN {{ source('person', 'StateProvince')}} sp 
	ON a.StateProvinceID = sp.StateProvinceID 
LEFT JOIN {{ source('sales', 'SalesTerritory')}} st 
	ON sp.TerritoryID = st.TerritoryID 