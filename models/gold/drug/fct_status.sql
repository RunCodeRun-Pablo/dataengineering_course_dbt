WITH ref AS (

    SELECT * FROM {{ ref('drug_snp') }}

),

status_history AS (
    SELECT
        id_app_numb,
        app_numb,
        sponsor_name,
        drug_name,
        disease,
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
    FROM ref
)

SELECT * FROM status_history