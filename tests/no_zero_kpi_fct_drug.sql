WITH ref_drug AS (

    SELECT * FROM {{ref("fct_drug")}}
)

SELECT
    id_disease,
    id_sponsor,
    num_treatments,
    avg_price_per_dose,
    estimated_revenue_index
FROM ref_drug
WHERE num_treatments <= 0
OR avg_price_per_dose <= 0
OR estimated_revenue_index < 0