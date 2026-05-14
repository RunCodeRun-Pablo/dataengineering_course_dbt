WITH ref_drug AS (

    SELECT * FROM {{ref("fct_status")}}
),

recently_approved AS (SELECT
    id_app_numb,
    sponsor_name,
    drug_name,
    disease
FROM gld_FCT_status
WHERE previous_status = 'none (tentative approval)'
AND current_status IN ('prescription', 'over-the-counter')),

sponsor_disease_recently_approved AS (SELECT
    sponsor_name,
    disease,
    COUNT(disease) AS new_treatments_per_disease
FROM recently_approved
WHERE disease != 'other'
GROUP BY sponsor_name, disease
ORDER BY new_treatments_per_disease DESC)

SELECT * FROM sponsor_disease_recently_approved