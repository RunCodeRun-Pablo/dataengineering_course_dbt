WITH ref1 AS (

    SELECT * FROM {{ref('slv_disease_metrics')}}

),

ref2 AS (

    SELECT * FROM {{ref('slv_disease')}}

),

ref3 AS (

    SELECT * FROM {{ref('slv_sex')}}

),

joint_data AS (

    SELECT 
        m.id_country,
        m.id_period,
        dis.id_type_disease,
        dis.id_disease,
        value
    FROM ref1 m
    LEFT JOIN ref2 dis
        ON m.id_disease = dis.id_disease
    LEFT JOIN ref3 s
        ON m.id_sex = s.id_sex
    WHERE s.desc_sex = 'both sexes' AND dis.desc_disease NOT IN ('total noninfc', 'total infc')
)

SELECT * FROM joint_data