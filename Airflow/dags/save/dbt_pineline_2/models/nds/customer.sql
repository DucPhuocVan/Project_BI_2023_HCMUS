WITH cte_usa_customer AS (
    SELECT
        uc.CustomerID,
        CONCAT(up.FirstName, ' ', up.MiddleName, ' ', up.LastName) AS CustomerName,
        up.PhoneNumber,
        up.EmailAddress,
        tr.TerritoryID
    FROM {{ source('usa', 'USA_Customer')}} uc 
    LEFT JOIN {{ source('usa', 'USA_Person')}} up 
        ON uc.PersonID = up.PersonID
    LEFT JOIN {{ ref('territory')}} tr
        ON uc.Territory = tr.Name
),
cte_europe_customer AS (
    SELECT
        ec.CustomerID,
        CONCAT(ec.FirstName, ' ', ec.MiddleName, ' ', ec.LastName) AS CustomerName,
        ec.PhoneNumberCustomer,
        ec.EmailAddressCustomer,
        tr.TerritoryID
    FROM {{ source('eur', 'Europe_Customer')}} ec
    LEFT JOIN {{ ref('territory')}} tr
        ON ec.TerritoryCustomer = tr.Name
),
cte_australia_customer AS (
    SELECT
        ac.CustomerID,
        ac.CustomerName AS CustomerName,
        ac.PhoneNumberCustomer AS PhoneNumber,
        ac.EmailAddressCustomer AS EmailAddress,
        tr.TerritoryID
    FROM {{ source('aus', 'Australia_Customer')}} ac
    LEFT JOIN {{ ref('territory')}} tr
        ON ac.TerritoryCustomer = tr.Name
),
cte_merge AS (
    SELECT * FROM cte_usa_customer
    UNION ALL
    SELECT * FROM cte_europe_customer
    UNION ALL
    SELECT * FROM cte_australia_customer
)
SELECT DISTINCT 
    *
FROM cte_merge