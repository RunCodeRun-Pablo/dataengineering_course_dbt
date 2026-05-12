WITH ref AS (

    SELECT * FROM {{ref("slv_drug")}}

),


kpis AS (

    SELECT
        id_disease,
        id_sponsor,
        COUNT(id_app_numb) AS num_treatments,
        AVG(price_per_dose) AS avg_price_per_dose
    FROM ref
    GROUP BY id_disease, id_sponsor
),

kpis_refined AS (

    SELECT
        id_disease,
        id_sponsor,
        num_treatments,
        ROUND(avg_price_per_dose, 2) AS avg_price_per_dose,
        ROUND(num_treatments*avg_price_per_dose, 2) AS estimated_revenue_index
    FROM kpis
)

SELECT * FROM kpis_refined