WITH src1 AS (

    SELECT * FROM {{ref('brnz_int_slv_total_dis')}}

),

src2 AS (

    SELECT * FROM {{ref('brnz_int_slv_total_health_staff')}}

),

src3 AS (

    SELECT * FROM {{ref('brnz_int_slv_uhc_coverage')}}

),

disease_countries AS (

    SELECT DISTINCT
        country
    FROM src1

),

health_countries AS (

    SELECT DISTINCT
        country
    FROM src2

),

uhc_countries AS (

    SELECT DISTINCT
        country
    FROM src3

),

joint_countries AS (

    SELECT * FROM disease_countries
    UNION
    SELECT * FROM health_countries
    UNION
    SELECT * FROM uhc_countries

),

hashed_joint_countries AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['country'])}} AS id_country,
        country AS desc_country
    FROM joint_countries
)

SELECT * FROM hashed_joint_countries