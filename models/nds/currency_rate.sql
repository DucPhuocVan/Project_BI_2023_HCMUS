SELECT DISTINCT
    CAST(CurrencyRateDate AS DATE) AS CurrencyRateDate,
    FromCurrencyCode,
    ToCurrencyCode,
    ExchangeRate
FROM {{ source('common', 'CurrencyRate')}}
WHERE ToCurrencyCode IN ('USD', 'CAD', 'AUD', 'EUR')