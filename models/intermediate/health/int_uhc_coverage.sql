with 

source as (

    select * from {{ source('bronze_data', 'brnz_uhc_coverage') }}
    {% if is_incremental() %}
        WHERE (LOWER(TRIM(country::VARCHAR(256))),
        TO_TIMESTAMP_NTZ(TO_DATE(period::STRING, 'YYYY'))) NOT IN (SELECT DISTINCT country, period FROM {{this}})
    {% endif %}
),

renamed as (

    select
        LOWER(TRIM(country::VARCHAR(256))) AS country,
        TO_TIMESTAMP_NTZ(TO_DATE(period::STRING, 'YYYY')) AS period,
        uhc_index::FLOAT4 AS uhc_index,
        uhc_class::VARCHAR(256) AS uhc_class

    from source

)

select * from renamed