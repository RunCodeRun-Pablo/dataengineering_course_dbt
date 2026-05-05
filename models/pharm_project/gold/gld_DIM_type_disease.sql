WITH ref AS (

    SELECT * FROM {{ref("slv_type_disease")}}

),

gld_data AS (

    SELECT
        id_type_disease,
        desc_type_disease
    FROM ref
)

SELECT * FROM gld_data