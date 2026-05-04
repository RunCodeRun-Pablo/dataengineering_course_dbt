{{config(materialized='table')}}

with 

source as (

    select * from {{ source('postgres', 'products') }}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        fivetran_del,
        fivetran_sync

    from source

)

select * from renamed