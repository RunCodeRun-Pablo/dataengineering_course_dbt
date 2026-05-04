with 
    
source as (

    select * from {{ ref('brnz_int_slv_drug') }}

),

slv_drug_dis AS (
    SELECT DISTINCT
        app_numb,
        disease
    FROM source
),

slv_drug AS (
    
    SELECT
        {{dbt_utils.generate_surrogate_key(['app_numb'])}} AS id_app_numb,
        {{dbt_utils.generate_surrogate_key(['disease'])}} AS id_disease
    FROM slv_drug_dis

)

SELECT * FROM slv_drug