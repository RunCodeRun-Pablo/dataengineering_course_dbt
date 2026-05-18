WITH ref AS (

    SELECT * FROM {{ref("slv_drug_name")}}

),

gld_data AS (

    SELECT
        id_drug_name,
        desc_drug_name
    FROM ref
)

SELECT * FROM gld_data