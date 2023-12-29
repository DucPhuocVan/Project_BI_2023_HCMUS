WITH cte_usa_employee AS (
    SELECT
        us.BusinessEntityID AS EmployeeID,
        CONCAT(us.FirstName, ' ', us.MiddleName, ' ', us.LastName) AS EmployeeName,
        us.BirthDate,
        us.Gender,
        us.HireDate,
        us.AddressLine1 AS Address,
        us.City,
        us.Salary,
        tr.TerritoryID
    FROM {{ source('usa', 'USA_Staff')}} us
    LEFT JOIN {{ source('usa', 'USA_SalesOrderHeader')}} sod
        ON us.BusinessEntityID = sod.SalesPersonID
    LEFT JOIN {{ ref('territory')}} tr
        ON sod.Territory = tr.Name
),
cte_europe_employee AS (
    SELECT
        ee.SalesPersonID AS EmployeeID,
        ee.SalesPersonName AS EmployeeName,
        ee.BirthDate,
        ee.Gender,
        ee.HireDate,
        ee.AddressLine1 AS Address,
        ee.City,
        ee.Salary,
        tr.TerritoryID
    FROM {{ source('eur', 'Europe_Employee')}} ee
    LEFT JOIN {{ source('eur', 'Europe_SalesOrderHeader')}} sod
        ON ee.SalesPersonID = sod.SalesPersonID
    LEFT JOIN {{ ref('territory')}} tr
        ON sod.Territory = tr.Name
),
cte_add_territory_australia_store AS (
    SELECT
        *,
        'Australia' AS Territory
    FROM {{ source('aus', 'Australia_Store')}}
    WHERE SalesPersonID IS NOT NULL
),
cte_australia_employee AS (
    SELECT
        aus.SalesPersonID AS EmployeeID,
        aus.SalesName AS EmployeeName,
        '' AS BirthDate,
        '' AS Gender,
        '' AS HireDate,
        '' AS Address,
        '' AS City,
        aus.Salary,
        tr.TerritoryID
    FROM cte_add_territory_australia_store aus
    LEFT JOIN {{ source('common', 'Territory')}} tr
        ON aus.Territory = tr.Name
),
-- hardcode for employee because they don't have store => collect from source
cte_employee_lack AS (
    SELECT
        e.BusinessEntityID AS EmployeeID,
        CONCAT(e.FirstName, ' ', e.MiddleName, ' ', e.LastName) AS EmployeeName,
        e.BirthDate,
        e.Gender,
        e.HireDate,
        e.AddressLine1 AS Address,
        e.City,
        e.Salary,
        1 AS TerritoryID
    FROM {{ source('common', 'employee_lack')}} e
),
cte_merge AS (
    SELECT * FROM cte_usa_employee
    UNION ALL
    SELECT * FROM cte_europe_employee
    UNION ALL
    SELECT * FROM cte_australia_employee
    UNION ALL
    SELECT * FROM cte_employee_lack
),
cte_rn AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY EmployeeID ORDER BY TerritoryID) AS rn
    FROM cte_merge
)
SELECT *
FROM cte_rn
WHERE rn = 1