WITH ref1 AS (

    SELECT * FROM {{ref('slv_period')}}

),

ref2 AS (

    SELECT * FROM {{ref('slv_uhc_index')}}

),

ref3 AS (

    SELECT * FROM {{ref('slv_freq_health_staff')}}

),

periods AS (
    SELECT DISTINCT
        u.id_period,
        p.desc_period
    FROM ref2 u
    LEFT JOIN ref1 p
    ON u.id_period = p.id_period
),

max_period AS (

    SELECT * FROM periods
    WHERE desc_period = (SELECT MAX(desc_period) FROM periods)
),

UHC_max_period AS(
    SELECT
        u.uhc_class_id,
        u.id_country,
        u.uhc_index
    FROM ref2 u
    INNER JOIN max_period m
    ON u.id_period = m.id_period
),

total_medical_staff AS (
    SELECT
        id_country,
        id_period,
        SUM(staff_per_10000) AS staff_per_10000
    FROM ref3
    GROUP BY id_country, id_period
),

complete_health_data AS (

    SELECT
        m.id_period,
        m.id_country,
        u.uhc_class_id,
        u.uhc_index,
        m.staff_per_10000
    FROM total_medical_staff m
    LEFT JOIN UHC_max_period u
    ON m.id_country = u.id_country
)

SELECT * FROM complete_health_data


