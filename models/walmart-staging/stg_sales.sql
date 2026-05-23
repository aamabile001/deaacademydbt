{{ config(materialized='view') }}

select
    store::int as store_id,
    dept::int as dept_id,
    date::date as store_date,
    weekly_sales::decimal(18,2) as weekly_sales,
    isholiday::boolean as is_holiday
from {{ source('BRONZE', 'RAW_SALES') }}