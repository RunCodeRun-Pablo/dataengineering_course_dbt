WITH ref_health_staff AS (

    SELECT * FROM {{ref("slv_freq_health_staff")}}
)

SELECT
    id_medical_staff,
    id_country,
    id_period,
    COUNT(*) AS num_rows
FROM ref_health_staff
GROUP BY id_medical_staff,id_country,id_period
HAVING COUNT(*) > 1