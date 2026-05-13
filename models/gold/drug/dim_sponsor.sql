WITH ref AS (

    SELECT * FROM {{ref("slv_sponsor")}}

),

gld_data AS (

    SELECT
        id_sponsor,
        desc_sponsor
    FROM ref
)

SELECT * FROM gld_data