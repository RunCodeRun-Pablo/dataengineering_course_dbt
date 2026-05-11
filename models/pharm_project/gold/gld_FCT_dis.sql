WITH ref AS (

    SELECT * FROM {{ref('slv_int_gld_pre_fct_disease')}}

),


kpi AS (

    SELECT
        id_country,
        id_period,
        id_type_disease,
        id_disease,
        value,

        ROUND(AVG(value) OVER (
            PARTITION BY id_country, id_disease
        ), 2) AS avg_hist_value,

        RANK() OVER (
            PARTITION BY id_period, id_country
            ORDER BY value DESC
        ) AS country_disease_rank
        
    FROM ref
)

SELECT * FROM kpi