with 
    
source as (

    select * from {{ source('bronze', 'brnz_drug_pre') }}
    {% if is_incremental() %}
        WHERE updated_at > (SELECT MAX(updated_at) FROM {{this}})
    {% endif %}

),

renamed as (

    select
        app_numb::VARCHAR(256) AS app_numb,
        sponsor_name::VARCHAR(256) AS sponsor_name,
        drug_name::VARCHAR(256) AS drug_name,
        disease::VARCHAR(256) AS disease,
        price_per_dose::FLOAT4 AS price_per_dose,
        updated_at::TIMESTAMP_NTZ AS updated_at

    from source
    WHERE LOWER(mkting_status) IN ('over-the-counter','prescription')
)

select * from renamed