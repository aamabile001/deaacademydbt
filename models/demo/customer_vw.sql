{{
    config
    (
        materialized='view'
    )
}}
select * from {{ ref('customer') }}
WHERE COUNTRY='USA'