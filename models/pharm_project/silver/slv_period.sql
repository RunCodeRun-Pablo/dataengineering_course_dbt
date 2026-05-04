WITH src1 AS (

    SELECT * FROM {{ref('brnz_int_slv_total_dis')}}

),

src2 AS (

    SELECT * FROM {{ref('brnz_int_slv_total_health_staff')}}

),

src3 AS (

    SELECT * FROM {{ref('brnz_int_slv_uhc_coverage')}}

),

disease_periods AS (

    SELECT DISTINCT
        period
    FROM src1

),

health_periods AS (

    SELECT DISTINCT
        period
    FROM src2

),

uhc_periods AS (

    SELECT DISTINCT
        period
    FROM src3

),

joint_periods AS (

    SELECT * FROM disease_periods
    UNION
    SELECT * FROM health_periods
    UNION
    SELECT * FROM uhc_periods

),

hashed_joint_periods AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['period'])}} AS id_period,
        period AS desc_period
    FROM joint_periods
)

SELECT * FROM hashed_joint_periods



