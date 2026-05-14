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
        u.id_uhc_class,
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
        u.id_uhc_class,
        u.uhc_index,
        m.staff_per_10000
    FROM total_medical_staff m
    INNER JOIN UHC_max_period u
    ON m.id_country = u.id_country
),

 kpis AS (
    SELECT 
        id_country,
        id_period,
        id_uhc_class,
        staff_per_10000,
        uhc_index,
        ROUND((uhc_index * 0.7) + (staff_per_10000 * 0.3), 2) AS clinical_trial_score,
    FROM complete_health_data),
    
kpi_ordered AS (
    SELECT
        id_country,
        id_period,
        id_uhc_class,
        staff_per_10000,
        uhc_index,
        clinical_trial_score,
        RANK() OVER(
            PARTITION BY id_period
            ORDER BY clinical_trial_score DESC
        ) AS country_rank
    FROM kpis
    WHERE uhc_index IS NOT NULL
)

SELECT * FROM kpi_ordered


