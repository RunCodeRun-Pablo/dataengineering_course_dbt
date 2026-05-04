with 

source1 as (

    select * from {{ source('bronze', 'brnz_doctors') }}
    {% if is_incremental() %}
        WHERE (country,period) NOT IN (SELECT DISTINCT country, period FROM {{this}})
    {% endif %}
),

source2 as (
    
    select * from {{ source('bronze','brnz_pharmacists') }}
    {% if is_incremental() %}
        WHERE (country,period) NOT IN (SELECT DISTINCT country, period FROM {{this}})
    {% endif %}

),

total_health_staff as (

     SELECT
        m.period,
        m.country,
        m.doct_per_10000,
        p.pharm_per_10000
    FROM source1 m
    LEFT JOIN source2 p
    ON m.period = p.period
    AND m.country = p.country

),

total_health_staff_clean AS (
    SELECT
        period::VARCHAR(256) AS period,
        country::VARCHAR(256) AS country,
        CAST(CASE
            WHEN doct_per_10000 IS NOT NULL THEN doct_per_10000
            ELSE 0
        END AS FLOAT4) AS doct_per_10000,
        CAST(CASE
            WHEN pharm_per_10000 IS NOT NULL THEN pharm_per_10000
            ELSE 0
        END AS FLOAT4) AS pharm_per_10000
    FROM total_health_staff

)

select * from total_health_staff_clean