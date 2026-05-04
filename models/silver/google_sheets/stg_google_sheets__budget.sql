{{config(materialized='table')}}

with source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        row_nmb,
        quantity,
        month,
        product_id,
        fivetran_synced

    from source

)

select * from renamed