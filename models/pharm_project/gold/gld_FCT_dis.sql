WITH ref AS (

    SELECT * FROM {{ref('slv_int_gld_pre_fct_disease')}}

),


kpi AS (

    SELECT
        id_country,
        id_period,
        id_type_disease,
        id_disease,
        RANK() OVER(
            PARTITION BY id_period
            ORDER BY value DESC
        )
    FROM ref
)
