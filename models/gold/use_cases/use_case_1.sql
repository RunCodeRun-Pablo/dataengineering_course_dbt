WITH ref_fct AS (

    SELECT * FROM {{ref("fct_drug")}}

),

ref_disease AS (

    SELECT * FROM {{ref("dim_disease")}}

),

ranking_treatments AS (SELECT
    dis.desc_disease,
    SUM(f.num_treatments)   AS total_treatments
FROM ref_fct f
LEFT JOIN ref_disease dis
    ON f.id_disease = dis.id_disease
GROUP BY dis.desc_disease
ORDER BY total_treatments DESC)

SELECT * FROM ranking_treatments
WHERE desc_disease != 'other'