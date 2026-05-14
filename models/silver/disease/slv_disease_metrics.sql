with 
    
source as (

    select * from {{ ref('int_disease_metrics') }}

),

total_dis_unpivoted AS (

    SELECT DISTINCT
        {{dbt_utils.generate_surrogate_key(['country'])}} AS id_country,
        {{dbt_utils.generate_surrogate_key(['period'])}} AS id_period,
        {{dbt_utils.generate_surrogate_key(['sex'])}} AS id_sex,
        id_disease,
        value
    FROM source
    UNPIVOT (
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
        )
    )
),

total_dis AS (

    SELECT
        id_country,
        id_period,
        id_sex,
        CASE
            WHEN id_disease ILIKE '%prob%' THEN 'probability'
            WHEN id_disease ILIKE '%inc%' THEN 'incidence'
        END AS metric_type,
        CASE
            WHEN id_disease ILIKE 'total_prob' THEN 'total noninfc'
            WHEN id_disease ILIKE 'prob_cancer' THEN 'cancer'
            WHEN id_disease ILIKE 'prob_card' THEN 'cardiovascular'
            WHEN id_disease ILIKE 'prob_diab' THEN 'diabetes'
            WHEN id_disease ILIKE 'prob_resp' THEN 'chronic respiratory'
            WHEN id_disease ILIKE 'total_inc' THEN 'total infc'
            WHEN id_disease ILIKE 'inc_ets' THEN 'ets'
            WHEN id_disease ILIKE 'inc_hep' THEN 'hepatitis'
            WHEN id_disease ILIKE 'inc_hiv' THEN 'hiv'
            WHEN id_disease ILIKE 'inc_resp' THEN 'infc respiratory'
            WHEN id_disease ILIKE 'inc_tub' THEN 'tuberculosis'
        END AS id_disease,
        value
    FROM total_dis_unpivoted
),

total_dis_clean AS (
    
    SELECT
        id_country,
        id_period,
        id_sex,
        metric_type,
        {{dbt_utils.generate_surrogate_key(['id_disease'])}} AS id_disease,
        value
    FROM total_dis

)

SELECT * FROM total_dis_clean