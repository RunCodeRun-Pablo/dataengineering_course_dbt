with 
    
source as (

    select * from {{ ref('brnz_int_slv_drug') }}

),

slv_drug AS (
    
    SELECT
        {{dbt_utils.generate_surrogate_key(['app_numb'])}} AS id_app_numb,
        app_numb,
        {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
        {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
        price_per_dose
    FROM source

)

SELECT * FROM slv_drug