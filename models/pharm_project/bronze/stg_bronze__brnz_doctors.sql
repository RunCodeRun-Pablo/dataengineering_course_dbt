with 

source as (

    select * from {{ source('bronze', 'brnz_doctors') }}

),

renamed as (

    select
        country::VARCHAR(256),
        period::VARCHAR(256),
        doct_per_10000::FLOAT4

    from source

)

select * from renamed