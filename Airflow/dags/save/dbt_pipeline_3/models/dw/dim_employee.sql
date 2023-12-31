{{config(
    materialized = 'incremental'
    , incremental_strategy = 'merge'
    , unique_key = 'employee_code'
    , merge_update_columns = ['employee_name','birth_date','gender','hire_date','addrress','city','salary','territory_country','territory_group']
    , on_schema_change='append_new_columns'
)}}
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
{% if is_incremental() %}
    AND EmployeeID IN (SELECT DISTINCT employee_code FROM {{this}})
{% endif %}