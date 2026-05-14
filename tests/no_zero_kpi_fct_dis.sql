WITH ref_disease AS (

    SELECT * FROM {{ref("fct_dis")}}
)

SELECT
    id_country,
    id_period,
    id_disease,
    value
FROM ref_disease
WHERE value < 0