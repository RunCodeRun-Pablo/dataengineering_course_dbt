WITH ref_fct_health AS (

    SELECT * FROM {{ref("fct_health")}}
)

SELECT
    id_country,
    id_period,
    COUNT(*) AS num_rows
FROM ref_fct_health
GROUP BY id_country, id_period
HAVING COUNT(*) > 1