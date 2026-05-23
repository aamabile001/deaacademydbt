{{ config(
    materialized='incremental',
    database='WALMART_DB',
    schema='MARTS',
    unique_key='DATE_ID'
) }}




select distinct
    to_number(to_char(STORE_DATE, 'YYYYMMDD')) as DATE_ID,
    STORE_DATE,
    IS_HOLIDAY,
    current_timestamp() as INSERT_DATE,
    current_timestamp() as UPDATE_DATE
from {{ ref('stg_sales') }}

{% if is_incremental() %}
where to_number(to_char(STORE_DATE, 'YYYYMMDD')) not in (
    select DATE_ID from {{ this }}
)
{% endif %}