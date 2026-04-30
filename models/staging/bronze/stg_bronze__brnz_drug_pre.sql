with 

source as (

    select * from {{ source('bronze', 'brnz_drug_pre') }}

),

renamed as (

    select
        app_numb,
        sponsor_name,
        drug_name,
        mkting_status,
        disease,
        price_per_dose,
        updated_at

    from source

)

select * from renamed