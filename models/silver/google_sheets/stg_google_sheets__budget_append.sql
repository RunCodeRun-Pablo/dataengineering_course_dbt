{{config(
    materialized='incremental',
    unique_key='product_id',
    incremental_strategy='append'
    )}}

with source as (

    select * from {{ source('google_sheets', 'budget') }}
    {% if is_incremental() %}
        WHERE fivetran_synced > (SELECT MAX(fivetran_synced) FROM {{this}})
    {% endif %}
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