WITH ref AS (

    SELECT * FROM {{ref("int_fct_health")}}

),

 kpis AS (
    SELECT 
        id_country,
        id_period,
        id_uhc_class,
        staff_per_10000,
        uhc_index,
        ROUND((uhc_index * 0.7) + (staff_per_10000 * 0.3), 2) AS clinical_trial_score,
    FROM ref),
    
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


