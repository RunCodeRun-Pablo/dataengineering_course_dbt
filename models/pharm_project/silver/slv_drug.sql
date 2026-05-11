with 
    
source as (

    select * from {{ ref('brnz_int_slv_approved_drugs') }}

),

slv_drug AS (
    
    SELECT
        id_app_numb,
        app_numb,
        {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
        {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
        {{dbt_utils.generate_surrogate_key(['disease'])}} AS id_disease,
        price_per_dose
    FROM source

)

SELECT * FROM slv_drug