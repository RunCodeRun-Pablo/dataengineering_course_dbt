WITH 

source1 AS (
    
    SELECT * FROM {{ ref('int_disease_list') }}
),

final_disease_listv1 AS (

    SELECT
        CASE
            WHEN LOWER(disease) IN ('tuberculosis','infc respiratory','total infc','ets','hiv','hepatitis') THEN 'infectious disease'
            WHEN LOWER(disease) IN ('diabetes','chronic respiratory','cancer','cardiovascular','total noninfc') THEN 'non infectious disease'
            ELSE 'other'
        END AS id_type_disease,
        {{dbt_utils.generate_surrogate_key(['disease'])}} AS id_disease,
        disease AS desc_disease
    FROM source1
),

final_disease_listv2 AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['id_type_disease'])}} AS id_type_disease,
        id_disease,
        desc_disease
    FROM final_disease_listv1
)

SELECT * FROM final_disease_listv2

