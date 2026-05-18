WITH ref AS (

    SELECT * FROM {{ref("slv_mkting_status")}}

),

gld_data AS (

    SELECT
        id_mkting_status,
        desc_mkting_status
    FROM ref
)

SELECT * FROM gld_data