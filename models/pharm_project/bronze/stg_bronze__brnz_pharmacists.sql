with 

source as (

    select * from {{ source('bronze', 'brnz_pharmacists') }}

),

renamed as (

    select
        country,
        period,
        pharm_per_10000

    from source

)

select * from renamed