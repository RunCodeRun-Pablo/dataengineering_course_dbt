{{config(materialized='table')}}

with 

source as (

    select * from {{ source('postgres', 'orderitems') }}

),

renamed as (

    select
        order_id,
        product_id,
        quantity,
        fivetran_del,
        fivetran_sync

    from source

)

select * from renamed