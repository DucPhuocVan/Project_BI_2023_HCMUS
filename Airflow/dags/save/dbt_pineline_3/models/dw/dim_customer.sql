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