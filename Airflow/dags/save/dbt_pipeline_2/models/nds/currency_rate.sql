{{config(
    materialized = 'table'
    , incremental_strategy = 'merge'
    , unique_key = ['CurrencyRateDate','FromCurrencyCode','ToCurrencyCode']
    , merge_update_columns = ['ExchangeRate']
    , on_schema_change='append_new_columns'
)}}

SELECT DISTINCT
    CAST(CurrencyRateDate AS DATE) AS CurrencyRateDate,
    FromCurrencyCode,
    ToCurrencyCode,
    ExchangeRate
FROM {{ source('common', 'CurrencyRate')}}
WHERE ToCurrencyCode IN ('USD', 'CAD', 'AUD', 'EUR')
{% if is_incremental() %}
    AND (CurrencyRateDate) IN (SELECT CurrencyRateDate FROM {{ this }})
    AND (FromCurrencyCode) IN (SELECT FromCurrencyCode FROM {{ this }})
    AND (ToCurrencyCode) IN (SELECT ToCurrencyCode FROM {{ this }})
{% endif %}