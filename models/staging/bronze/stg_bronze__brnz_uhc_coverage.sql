with 

source as (

    select * from {{ source('bronze', 'brnz_uhc_coverage') }}

),

renamed as (

    select
        country,
        period,
        uhc_index,
        uhc_class

    from source

)

select * from renamed