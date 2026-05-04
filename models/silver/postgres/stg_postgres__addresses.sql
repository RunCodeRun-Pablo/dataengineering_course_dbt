{{config(materialized='table')}}

with 

source as (

    select * from {{ source('postgres', 'addresses') }}

),

renamed as (

    select
        address_id,
        zipcode,
        country,
        address,
        state,
        fivetran_del,
        fivetran_sync

    from source

)

select * from renamed