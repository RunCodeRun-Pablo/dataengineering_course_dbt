{{config(materialized='view')}}

with

source_drug AS (
    SELECT * FROM {{ ref('brnz_int_slv_drug') }}
),

source_dis AS (
    SELECT * FROM {{ ref('brnz_int_slv_total_dis') }}
),

drug_diseases AS (
    SELECT DISTINCT
        disease
    FROM source_drug
),

unpivoted_diseases AS (
    SELECT DISTINCT
        id_disease
    FROM source_dis
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
        )
)),

metrics_renamed AS (
    SELECT
        CASE
            WHEN id_disease ILIKE 'total_prob'  THEN 'total noninfc'
            WHEN id_disease ILIKE 'prob_cancer' THEN 'cancer'
            WHEN id_disease ILIKE 'prob_card'   THEN 'cardiovascular'
            WHEN id_disease ILIKE 'prob_diab'   THEN 'diabetes'
            WHEN id_disease ILIKE 'prob_resp'   THEN 'chronic respiratory'
            WHEN id_disease ILIKE 'total_inc'   THEN 'total infc'
            WHEN id_disease ILIKE 'inc_ets'     THEN 'ets'
            WHEN id_disease ILIKE 'inc_hep'     THEN 'hepatitis'
            WHEN id_disease ILIKE 'inc_hiv'     THEN 'hiv'
            WHEN id_disease ILIKE 'inc_resp'    THEN 'infc respiratory'
            WHEN id_disease ILIKE 'inc_tub'     THEN 'tuberculosis'
        END AS disease
    FROM unpivoted_diseases
),

all_diseases AS (
    SELECT disease FROM drug_diseases
    UNION
    SELECT disease FROM metrics_renamed
)

SELECT * FROM all_diseases