WITH ref1 AS (

    SELECT * FROM {{ref('slv_disease_metrics')}}

),

ref2 AS (

    SELECT * FROM {{ref('slv_disease')}}

),

gld_data AS (

    SELECT 
        m.id_country,
        m.id_period,
        m.id_sex,
        dis.id_type_disease,
        m.id_disease,
        value
    FROM ref1 m
    LEFT JOIN ref2 dis
    ON m.id_disease = dis.id_disease
)

SELECT * FROM gld_data
