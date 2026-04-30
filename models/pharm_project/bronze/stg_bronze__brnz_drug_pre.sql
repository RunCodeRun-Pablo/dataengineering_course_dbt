with 

source as (

    select * from {{ source('bronze', 'brnz_drug_pre') }}

),

renamed as (

    select
        app_numb::VARCHAR(256),
        sponsor_name::VARCHAR(256),
        drug_name::VARCHAR(256),
        mkting_status::VARCHAR(256),
        disease::VARCHAR(256),
        price_per_dose::FLOAT4,
        updated_at::TIMESTAMP_NTZ

    from source

)

select * from renamed