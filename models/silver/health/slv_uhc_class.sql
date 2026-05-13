WITH ref AS (

    SELECT * FROM {{ref('int_uhc_coverage')}}

),

cleaned_ref AS (

    SELECT DISTINCT
        uhc_class
    FROM ref

),

cleaned_ref_id AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['uhc_class'])}} AS id_uhc_class,
        uhc_class AS desc_uhc_class
    FROM cleaned_ref
)

SELECT * FROM cleaned_ref_id