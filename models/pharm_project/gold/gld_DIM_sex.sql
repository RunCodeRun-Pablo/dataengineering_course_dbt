WITH ref AS (

    SELECT * FROM {{ref("slv_sex")}}

),

gld_data AS (

    SELECT
        id_sex,
        desc_sex
    FROM ref
)

SELECT * FROM gld_data