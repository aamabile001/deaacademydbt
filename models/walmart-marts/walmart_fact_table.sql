{{ config(
    materialized='incremental',
    database='WALMART_DB',
    schema='MARTS',
    unique_key=['STORE_ID', 'DEPT_ID', 'DATE_ID', 'VRSN_START_DATE']
) }}

with SOURCE_DATA as (

    select
        s.STORE_ID,
        s.DEPT_ID,
        to_number(to_char(s.STORE_DATE, 'YYYYMMDD')) as DATE_ID,
        st.STORE_SIZE,
        s.WEEKLY_SALES as STORE_WEEKLY_SALES,
        m.FUEL_PRICE,
        m.STORE_TEMPERATURE,
        m.UNEMPLOYEMENT,
        m.CPI,
        m.MARKDOWN1,
        m.MARKDOWN2,
        m.MARKDOWN3,
        m.MARKDOWN4,
        m.MARKDOWN5,
        current_timestamp() as INSERT_DATE,
        current_timestamp() as UPDATE_DATE,
        current_timestamp() as VRSN_START_DATE,
        null::timestamp as VRSN_END_DATE
    from {{ ref('stg_sales') }} s
    left join {{ ref('stg_macro_data') }} m
        on s.STORE_ID = m.STORE_ID
       and s.STORE_DATE = m.STORE_DATE
    left join {{ ref('stg_stores') }} st
        on s.STORE_ID = st.STORE_ID

)

select *
from SOURCE_DATA

{% if is_incremental() %}
where not exists (
    select 1
    from {{ this }} t
    where t.STORE_ID = SOURCE_DATA.STORE_ID
      and t.DEPT_ID = SOURCE_DATA.DEPT_ID
      and t.DATE_ID = SOURCE_DATA.DATE_ID
      and t.STORE_WEEKLY_SALES = SOURCE_DATA.STORE_WEEKLY_SALES
      and coalesce(t.FUEL_PRICE, 0) = coalesce(SOURCE_DATA.FUEL_PRICE, 0)
      and coalesce(t.STORE_TEMPERATURE, 0) = coalesce(SOURCE_DATA.STORE_TEMPERATURE, 0)
      and coalesce(t.UNEMPLOYEMENT, 0) = coalesce(SOURCE_DATA.UNEMPLOYEMENT, 0)
      and coalesce(t.CPI, 0) = coalesce(SOURCE_DATA.CPI, 0)
      and t.VRSN_END_DATE is null
)
{% endif %}