WITH ref AS (

    SELECT * FROM {{ref("slv_drug")}}

),

ref2 AS (

    SELECT * FROM {{ref('slv_mkting_status')}}

),

ref_clean AS (

    SELECT
        id_app_numb,
        id_disease,
        id_sponsor,
        price_per_dose
    FROM ref r
    LEFT JOIN ref2 m
    ON r.id_mkting_status = m.id_mkting_status
    WHERE m.desc_mkting_status IN ('over-the-counter', 'prescription')

),


kpis AS (

    SELECT
        id_disease,
        id_sponsor,
        COUNT(id_app_numb) AS num_treatments,
        AVG(price_per_dose) AS avg_price_per_dose
    FROM ref_clean
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