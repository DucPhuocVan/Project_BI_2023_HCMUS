SELECT 
    e.EmployeeID AS employee_code,
    e.EmployeeName AS employee_name,
    e.BirthDate AS birth_date,
    e.Gender AS gender,
    e.HireDate AS hire_date,
    e.Address AS addrress,
    e.City AS city,
    e.Salary AS salary,
    t.territory_country,
    t.territory_group
FROM {{ source('nds', 'employee')}} e
LEFT JOIN {{ref('dim_territory')}} t 
    ON e.TerritoryID = t.territory_code