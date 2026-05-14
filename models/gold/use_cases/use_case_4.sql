WITH ref_fct_disease AS (

    SELECT * FROM {{ref("fct_dis")}}

),

ref_country AS (

    SELECT * FROM {{ref("dim_country")}}

),

ref_period AS (

    SELECT * FROM {{ref("dim_period")}}

),

ref_disease AS (

    SELECT * FROM {{ref("dim_disease")}}

),

ref_type_disease AS (

    SELECT * FROM {{ref("dim_type_disease")}}

),


numb_one_disease AS (SELECT --More frequent disease in each country for every period
    c.desc_country,
    p.desc_period,
    td.desc_type_disease,
    dis.desc_disease,
    f.value
FROM ref_fct_disease f
LEFT JOIN ref_country c
    ON f.id_country = c.id_country
LEFT JOIN ref_period p
    ON f.id_period = p.id_period
LEFT JOIN ref_fct_disease dis
    ON f.id_disease = dis.id_disease
LEFT JOIN ref_type_disease td
    ON f.id_type_disease = td.id_type_disease
WHERE f.country_disease_rank = 1 AND c.desc_country IN ('spain','united states of america')
ORDER BY c.desc_country, p.desc_period DESC)

SELECT * FROM numb_one_disease