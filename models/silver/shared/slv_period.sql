WITH src1 AS (

    SELECT * FROM {{ref('int_disease_metrics')}}

),

src2 AS (

    SELECT * FROM {{ref('int_health_staff')}}

),

src3 AS (

    SELECT * FROM {{ref('int_uhc_coverage')}}

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
        period AS desc_period,
        DATE_PART('year', period)::INT AS desc_year,
        DATE_PART('month', period)::INT AS desc_month,
        DATE_PART('day', period)::INT AS desc_day
    FROM joint_periods
)

SELECT * FROM hashed_joint_periods



