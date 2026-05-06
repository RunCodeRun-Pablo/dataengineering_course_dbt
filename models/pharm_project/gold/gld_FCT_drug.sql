WITH ref AS (

    SELECT * FROM {{ref("slv_drug")}}

),


gld_data AS (

    SELECT
        id_sponsor,
        id_drug_name,
        id_disease,
        price_per_dose
    FROM ref
)

SELECT * FROM gld_data