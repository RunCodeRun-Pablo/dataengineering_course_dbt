{{config(materialized='table')}}

with 

source as (

    select * from {{ source('postgres', 'users') }}

),

renamed as (

    select
        user_id,
        updated_at,
        address_id,
        last_name,
        created_at,
        phone_number,
        total_orders,
        first_name,
        email,
        fivetran_del,
        fivetran_sync

    from source

)

select * from renamed