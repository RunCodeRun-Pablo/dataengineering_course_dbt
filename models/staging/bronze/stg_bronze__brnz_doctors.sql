with 

source as (

    select * from {{ source('bronze', 'brnz_doctors') }}

),

renamed as (

    select
        country,
        period,
        doct_per_10000

    from source

)

select * from renamed