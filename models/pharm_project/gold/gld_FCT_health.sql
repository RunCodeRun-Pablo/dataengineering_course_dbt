WITH ref AS (

    SELECT * FROM {{ref("slv_int_gld_pre_fct_health")}}

),

gld_data AS (

    SELECT
        id_period,
        id_country,
        uhc_class_id AS id_uhc_class,
        uhc_index,
        staff_per_10000
    FROM ref
)

SELECT * FROM gld_data

