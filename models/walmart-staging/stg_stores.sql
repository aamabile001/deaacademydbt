{{ config(materialized='view') }}

select
    STORE::INT as STORE_ID,
    TYPE::VARCHAR as STORE_TYPE,
    SIZE::INT as STORE_SIZE
from {{ source('BRONZE', 'RAW_STORES') }}