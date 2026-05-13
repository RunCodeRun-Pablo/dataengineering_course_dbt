WITH ref AS (

    SELECT * FROM {{ref("slv_disease")}}

),

gld_data AS (

    SELECT
        id_disease,
        desc_disease
    FROM ref
)

SELECT * FROM gld_data