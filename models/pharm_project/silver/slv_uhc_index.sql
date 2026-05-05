WITH ref AS (

    SELECT * FROM {{ref('brnz_int_slv_uhc_coverage')}}

),

cleaned_ref AS (

    SELECT
        uhc_class,
        country,
        period,
        uhc_index
    FROM ref
),

cleaned_ref_id AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['uhc_class'])}} AS uhc_class_id,
        {{dbt_utils.generate_surrogate_key(['country'])}} AS id_country,
        {{dbt_utils.generate_surrogate_key(['period'])}} AS id_period,
        uhc_index
    FROM cleaned_ref
)

SELECT * FROM cleaned_ref_id