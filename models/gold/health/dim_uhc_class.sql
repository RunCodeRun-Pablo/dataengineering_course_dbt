WITH ref AS (

    SELECT * FROM {{ref('slv_uhc_class')}}

),

gld_data AS (

    SELECT
        id_uhc_class,
        desc_uhc_class
    FROM ref

)

SELECT * FROM gld_data