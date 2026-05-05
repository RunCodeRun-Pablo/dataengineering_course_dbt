WITH ref AS (

    SELECT * FROM {{ref("slv_country")}}

),

gld_data AS (

    SELECT
        id_country,
        desc_country
    FROM ref
)

SELECT * FROM gld_data