{% macro copy_into_raw(table_name, file_name) %}

COPY INTO {{ table_name }}
FROM @WALMART_DB.BRONZE.WALMART_STAGE/{{ file_name }}
FILE_FORMAT = WALMART_DB.BRONZE.CSV_FORMAT
ON_ERROR = 'CONTINUE';

{% endmacro %}