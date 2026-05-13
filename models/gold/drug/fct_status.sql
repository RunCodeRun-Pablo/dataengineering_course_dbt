WITH ref AS (

    SELECT * FROM {{ ref('drug_snp') }}

),

ref2 AS (

    SELECT * FROM {{ref('slv_mkting_status')}}
),

ref_desc AS (

    SELECT 
        id_app_numb,
        app_numb,
        id_sponsor,
        id_drug_name,
        id_disease,
        desc_mkting_status AS mkting_status,
        dbt_valid_from,
        dbt_valid_to
    FROM ref r
    LEFT JOIN ref2 m
    ON r.id_mkting_status = m.id_mkting_status

),

status_history AS (
    SELECT
        id_app_numb,
        app_numb,
        id_sponsor,
        id_drug_name,
        id_disease,
        mkting_status AS current_status,
        LAG(mkting_status) OVER (
            PARTITION BY id_app_numb
            ORDER BY dbt_valid_from
        ) AS previous_status,
        dbt_valid_from AS valid_from,
        dbt_valid_to AS valid_to,
        CASE
            WHEN dbt_valid_to IS NULL THEN 'active'
            ELSE 'historical'
        END AS row_status
    FROM ref_desc
)

SELECT * FROM status_history