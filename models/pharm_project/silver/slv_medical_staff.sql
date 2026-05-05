WITH ref AS (

    SELECT * FROM {{ref("brnz_int_slv_total_health_staff")}}

),

unpivoted AS (
    
    SELECT
        id_medical_staff
    FROM ref
    UNPIVOT INCLUDE NULLS (
        staff_per_10000 FOR id_medical_staff IN (
            doct_per_10000,
            pharm_per_10000
     ))),

unpivoted_clean AS (
    
    SELECT DISTINCT
        CASE
            WHEN LOWER(id_medical_staff) = 'doct_per_10000' THEN 'medical'
            WHEN LOWER(id_medical_staff) = 'pharm_per_10000' THEN 'pharmacist'
        END AS id_medical_staff
    FROM unpivoted
),

final_medical_list AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['id_medical_staff'])}} AS id_medical_staff,
        id_medical_staff AS desc_medical_staff
    FROM unpivoted_clean
)

SELECT * FROM final_medical_list