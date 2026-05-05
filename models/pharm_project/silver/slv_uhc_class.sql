WITH ref AS (

    SELECT * FROM {{ref('brnz_int_slv_uhc_coverage')}}

),

cleaned_ref AS (

    SELECT DISTINCT
        uhc_class
    FROM ref

),

cleaned_ref_id AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['uhc_class'])}} AS uhc_class_id,
        uhc_class AS desc_uhc_class
    FROM cleaned_ref
)

SELECT * FROM cleaned_ref_id