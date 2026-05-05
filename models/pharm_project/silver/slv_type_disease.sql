WITH 

source1 AS (
    
    SELECT * FROM {{ ref('brnz_int_slv_diseases_list') }}
),

type_disease_list AS (

    SELECT DISTINCT
        CASE
            WHEN LOWER(id_disease) IN ('tuberculosis','infc respiratory','total infc','ets','hiv','hepatitis') THEN 'infectious disease'
            WHEN LOWER(id_disease) IN ('diabetes','chronic respiratory','cancer','cardiovascular','total noninfc') THEN 'non infectious disease'
            ELSE 'other'
        END AS id_type_disease
    FROM source1
),

final_type_disease_list AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['id_type_disease'])}} AS id_type_disease,
        id_type_disease AS desc_type_disease
    FROM type_disease_list
)

SELECT * FROM final_type_disease_list