WITH ref_disease_metrics AS (

    SELECT * FROM {{ref("slv_disease_metrics")}}
)

SELECT
    id_country,
    id_period,
    id_sex,
    id_disease,
    COUNT(*) AS num_rows
FROM ref_disease_metrics
GROUP BY id_country, id_period, id_sex, id_disease
HAVING COUNT(*) > 1