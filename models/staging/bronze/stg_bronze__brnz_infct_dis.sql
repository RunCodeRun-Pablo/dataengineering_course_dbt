with 

source as (

    select * from {{ source('bronze', 'brnz_infct_dis') }}

),

renamed as (

    select
        country,
        period,
        sex,
        inc_resp,
        inc_hiv,
        inc_ets,
        inc_hep,
        inc_tub,
        total_inc

    from source

)

select * from renamed