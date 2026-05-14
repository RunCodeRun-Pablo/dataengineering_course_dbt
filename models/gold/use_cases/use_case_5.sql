WITH ref_health AS (

    SELECT * FROM {{ref("fct_health")}}

),

ref_country AS (

    SELECT * FROM {{ref("dim_country")}}

),

ref_uhc_class AS (

    SELECT * FROM {{ref("dim_uhc_class")}}

),

ref_fct_dis AS (

    SELECT * FROM {{ref("fct_dis")}}

),

ref_drug AS (

    SELECT * FROM {{ref("fct_drug")}}

),

ref_disease AS (

    SELECT * FROM {{ref("dim_disease")}}

),

ref_type_disease AS (

    SELECT * FROM {{ref("dim_type_disease")}}

),



high_capacity_countries AS ( --Select countries with an appropriate health system

    SELECT
        f.id_country,
        c.desc_country,
        uc.desc_uhc_class,
        f.clinical_trial_score
    FROM ref_health f
    LEFT JOIN ref_country c
        ON f.id_country = c.id_country
    LEFT JOIN ref_uhc_class uc
        ON f.id_uhc_class = uc.id_uhc_class
    WHERE f.clinical_trial_score >= 60
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY f.id_country
        ORDER BY f.id_period DESC
    ) = 1

),

frequent_diseases AS ( --Values for each disease all over the years within each country with an appropriate health system

    SELECT
        d.id_country,
        d.id_type_disease,
        d.id_disease,
        SUM(d.value)    AS total_burden
    FROM ref_fct_dis d
    INNER JOIN high_capacity_countries h
        ON d.id_country = h.id_country
    GROUP BY d.id_country, d.id_type_disease, d.id_disease

),

treatments_available AS ( --total treatments for a specific disease

    SELECT
        id_disease,
        SUM(num_treatments) AS total_treatments
    FROM ref_drug
    GROUP BY id_disease

)

diseases_w_less_treatments AS (SELECT
    dis.desc_disease,
    td.desc_type_disease,
    SUM(f.total_burden) AS global_burden_high_capacity,
    t.total_treatments,
    ROUND(global_burden_high_capacity/ NULLIF(total_treatments,0), 2) AS treatment_opportunity_index
FROM frequent_diseases f
LEFT JOIN treatments_available t
    ON f.id_disease = t.id_disease
LEFT JOIN ref_disease dis
    ON f.id_disease = dis.id_disease
LEFT JOIN ref_type_disease td
    ON f.id_type_disease = td.id_type_disease
GROUP BY td.desc_type_disease, dis.desc_disease, t.total_treatments
ORDER BY treatment_opportunity_index DESC)

SELECT * FROM diseases_w_less_treatments