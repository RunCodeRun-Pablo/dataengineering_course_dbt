with 
    
source as (

    select * from {{ ref('drug_snp') }}
    {% if is_incremental() %}
        WHERE dbt_scd_id NOT IN (
            SELECT dbt_scd_id FROM {{ this }}
        )
    {% endif %}
    
),

slv_drug AS (
    
    SELECT
        id_app_numb,
        app_numb,
        {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
        {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
        {{dbt_utils.generate_surrogate_key(['disease'])}} AS id_disease,
        {{dbt_utils.generate_surrogate_key(['mkting_status'])}} AS id_mkting_status,
        price_per_dose,
        dbt_scd_id,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    FROM source

)

SELECT * FROM slv_drug