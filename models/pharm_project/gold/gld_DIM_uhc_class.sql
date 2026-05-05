WITH ref AS (

    SELECT * FROM {{ref('slv_uhc_class')}}

),

gld_data AS (

    SELECT
        uhc_class_id,
        desc_uhc_class
    FROM ref

)

SELECT * FROM gld_data