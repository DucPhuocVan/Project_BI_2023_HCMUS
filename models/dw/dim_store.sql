SELECT 
    s.StoreID,
    s.StoreName,
    e.territory_country,
    e.territory_group
FROM {{ source('nds', 'store')}} s 
LEFT JOIN {{ ref('dim_employee')}} e
    ON s.SalesPersonID = e.employee_code