SELECT 
    TerritoryID AS territory_code,
    Name AS territory_name,
    CountryRegionCode AS country_region_code,
    [Group] AS territory_group,
    CountryRegion AS territory_country
FROM {{source('nds', 'territory')}}