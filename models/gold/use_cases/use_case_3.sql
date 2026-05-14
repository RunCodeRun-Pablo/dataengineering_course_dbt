WITH ref_health AS (

    SELECT * FROM {{ref("fct_health")}}

),

ref_country AS (

    SELECT * FROM {{ref("dim_country")}}

),

ref_period AS (

    SELECT * FROM {{ref("dim_period")}}

),

ref_uhc_class AS (

    SELECT * FROM {{ref("dim_uhc_class")}}

),


clinical_trial_countries AS (SELECT --Filtering countries with an appropriate health system to carry clinical trials
    c.desc_country,
    p.desc_period,
    uc.desc_uhc_class,
    f.clinical_trial_score,
    f.country_rank
FROM ref_health f
LEFT JOIN ref_country c
    ON f.id_country = c.id_country
LEFT JOIN ref_period p
    ON f.id_period = p.id_period
LEFT JOIN ref_uhc_class uc
    ON f.id_uhc_class = uc.id_uhc_class
WHERE f.country_rank <= 20
ORDER BY p.desc_period DESC, f.country_rank ASC)

SELECT * FROM clinical_trial_countries