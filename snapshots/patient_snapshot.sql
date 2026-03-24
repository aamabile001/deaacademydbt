{% snapshot patient_snapshot %}

{{
    config
    (
        strategy = 'check',
        unique_key = 'PATIENT_ID',
        check_cols = ['PATIENT_NAME','PATIENT_CONTACT_NUMBER','PATIENT_EMAIL_ID','PATIENT_ADDRESS']
    )
}}



-- with src as (
-- SELECT * FROM {{source('patient','PATIENT_SRC')}} where DBT_VALID_TO IS NULL
-- ),

-- deduped as (
--     select *
--     from src
--     qualify row_number() over (
--         partition by PATIENT_ID
--         order by CREATED_AT DESC
--     ) = 1
-- )

-- select * from deduped
select * from {{source('patient','PATIENT_SRC')}} 
{% endsnapshot %}