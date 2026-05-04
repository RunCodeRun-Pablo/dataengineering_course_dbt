with 

source as (

    select * from {{ source('bronze', 'brnz_uhc_coverage') }}
    {% if is_incremental() %}
        WHERE (country,period) NOT IN (SELECT DISTINCT country, period FROM {{this}})
    {% endif %}
),

renamed as (

    select
        country::VARCHAR(256) AS country,
        period::VARCHAR(256) AS period,
        uhc_index::VARCHAR(256) AS uhc_index,
        uhc_class::VARCHAR(256) AS uhc_class

    from source

)

select * from renamed