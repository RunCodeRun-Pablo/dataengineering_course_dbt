WITH source AS (

    SELECT * FROM {{ref('brnz_int_slv_total_health_staff')}}

),

src_unpivoted AS (

    id_medical_staff,
    country,
    period,
    staff_per_10000
FROM source
    UNPIVOT (
        staff_per_10000 FOR id_medical_staff IN (
            doct_per_10000,
            pharm_per_10000
     ))
),

src_unpivoted_id AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['id_medical_staff'])}} AS id_medical_staff,
        {{dbt_utils.generate_surrogate_key(['country'])}} AS id_country,
        {{dbt_utils.generate_surrogate_key(['period'])}}, AS id_period,
        staff_per_10000

    FROM src_unpivoted
)

SELECT * FROM src_unpivoted_id