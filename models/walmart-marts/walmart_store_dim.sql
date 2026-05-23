{{ config(
    materialized='incremental',
    database='WALMART_DB',
    schema='MARTS',
    unique_key=['STORE_ID', 'DEPT_ID']
) }}

select distinct
    s.STORE_ID,
    s.DEPT_ID,
    st.STORE_TYPE,
    st.STORE_SIZE,
    current_timestamp() as INSERT_DATE,
    current_timestamp() as UPDATE_DATE
from {{ ref('stg_sales') }} s
left join {{ ref('stg_stores') }} st
    on s.STORE_ID = st.STORE_ID

{% if is_incremental() %}
where not exists (
    select 1
    from {{ this }} t
    where t.STORE_ID = s.STORE_ID
      and t.DEPT_ID = s.DEPT_ID
)
{% endif %}