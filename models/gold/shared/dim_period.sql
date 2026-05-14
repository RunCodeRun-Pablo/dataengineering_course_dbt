WITH ref AS (

    SELECT * FROM {{ref("slv_period")}}

),

gld_data AS (

    SELECT
        id_period,
        desc_period,
        desc_year,
        desc_month,
        desc_day
    FROM ref
)

SELECT * FROM gld_data