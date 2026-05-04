WITH 

source1 AS (
    
    SELECT * FROM {{ ref('brnz_int_slv_drug') }}
),

source2 AS (

    SELECT * FROM {{ref('brnz_int_slv_total_dis')}}
),

cleaned_src1 AS (

    SELECT DISTINCT
        disease AS id_disease
    FROM source1
),

cleaned_src2 AS (

    SELECT DISTINCT
        id_disease
    FROM source2
    UNPIVOT EXCLUDE NULLS(
        value FOR id_disease IN (
            total_prob,
            prob_cancer,
            prob_card,
            prob_diab,
            prob_resp,
            total_inc,
            inc_ets,
            inc_hep,
            inc_hiv,
            inc_resp,
            inc_tub 
))),

metrics_disease_list_mod AS (

    SELECT
        CASE
            WHEN id_disease ILIKE 'total_prob' THEN 'total noninfc'
            WHEN id_disease ILIKE 'prob_cancer' THEN 'cancer'
            WHEN id_disease ILIKE 'prob_card' THEN 'cardiovascular'
            WHEN id_disease ILIKE 'prob_diab' THEN 'diabetes'
            WHEN id_disease ILIKE 'prob_resp' THEN 'chronic respiratory'
            WHEN id_disease ILIKE 'total_inc' THEN 'total infc'
            WHEN id_disease ILIKE 'inc_ets' THEN 'ETS'
            WHEN id_disease ILIKE 'inc_hep' THEN 'hepatitis'
            WHEN id_disease ILIKE 'inc_hiv' THEN 'HIV'
            WHEN id_disease ILIKE 'inc_resp' THEN 'infc respiratory'
            WHEN id_disease ILIKE 'inc_tub' THEN 'tuberculosis'
        END AS id_disease
        FROM cleaned_src2
),

total_diseases_list AS (

    SELECT * FROM cleaned_src1
    UNION
    SELECT *FROM metrics_disease_list_mod
),

type_disease_list AS (

    SELECT DISTINCT
        CASE
            WHEN LOWER(id_disease) IN ('tuberculosis','infc respiratory','total infc','ets','hiv','hepatitis') THEN 'infectious disease'
            WHEN LOWER(id_disease) IN ('diabetes','chronic respiratory','cancer','cardiovascular','total noninfc') THEN 'non infectious disease'
            ELSE 'other'
        END AS id_type_disease
    FROM total_diseases_list
),

final_type_disease_list AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['id_type_disease'])}} AS id_type_disease,
        id_type_disease AS desc_disease
    FROM type_disease_list
)

SELECT * FROM final_type_disease_list