WITH source AS (

    SELECT * FROM {{ref('int_disease_metrics')}}

),

clean_source AS (
    SELECT DISTINCT
        sex
    FROM source
),

transformed_source AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['sex'])}} AS id_sex,
        sex AS desc_sex
    FROM clean_source
)

SELECT * FROM transformed_source