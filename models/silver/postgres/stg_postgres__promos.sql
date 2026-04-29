{{config(materialized='table')}}
with 

source as (

    select * from {{ source('postgres', 'promos') }}

),

renamed as (

    select
        promo_id,
        discount,
        status,
        fivetran_del,
        fivetran_sync

    from source

)

select * from renamed