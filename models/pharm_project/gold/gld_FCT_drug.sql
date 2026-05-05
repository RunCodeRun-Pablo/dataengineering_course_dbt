WITH ref1 AS (

    SELECT * FROM {{ref("slv_drug")}}

),

ref2 AS (

    SELECT * FROM {{ref('slv_drug_disease')}}
),


gld_data AS (

    SELECT
        d.id_sponsor,
        d.id_drug_name,
        dis.id_disease,
        d.price_per_dose
    FROM ref1 d
    LEFT JOIN ref2 dis
    ON d.id_app_numb = dis.id_app_numb
)

SELECT * FROM gld_data