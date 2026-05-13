{{config(
    materialized='incremental'
    incremental_strategy='merge'
    unique_key='id_app_numb'
)}}

with 
    
source as (

    select * from {{ source('bronze_data', 'brnz_drug_pre') }}
    
    {% if is_incremental() %}
    WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
    {% endif %}
    
),

slv_drug AS (
    
    SELECT
        LOWER(app_numb::VARCHAR(256))      AS app_numb,
        LOWER(sponsor_name::VARCHAR(256))  AS sponsor_name,
        LOWER(drug_name::VARCHAR(256))     AS drug_name,
        LOWER(disease::VARCHAR(256))       AS disease,
        LOWER(mkting_status::VARCHAR(256)) AS mkting_status,
        price_per_dose::FLOAT4      AS price_per_dose,
        loaded_at::TIMESTAMP_LTZ AS loaded_at
    FROM source
),

slv_drug_id AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['app_numb','drug_name'])}} AS id_app_numb,
        app_numb,
        {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
        {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
        {{dbt_utils.generate_surrogate_key(['disease'])}} AS id_disease,
        price_per_dose,
        loaded_at
    FROM slv_drug
    WHERE mkting_status IN ('prescription','over-the-counter')
)

SELECT * FROM slv_drug_id