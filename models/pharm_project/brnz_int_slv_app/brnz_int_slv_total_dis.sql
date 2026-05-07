with 

source1 as (

    select * from {{ source('bronze', 'brnz_infct_dis') }}
    {% if is_incremental() %}
        WHERE (LOWER(TRIM(country::VARCHAR(256))),
        TO_TIMESTAMP_NTZ(TO_DATE(period::STRING, 'YYYY'))),
        LOWER(sex::VARCHAR(256)) NOT IN (SELECT DISTINCT country, period FROM {{this}})
    {% endif %}

),

source2 as (

    select * from {{ source('bronze', 'brnz_noninfct_dis') }}
    {% if is_incremental() %}
        WHERE (LOWER(TRIM(country::VARCHAR(256))),
        TO_TIMESTAMP_NTZ(TO_DATE(period::STRING, 'YYYY'))),
        LOWER(sex::VARCHAR(256)) NOT IN (SELECT DISTINCT country, period FROM {{this}})
    {% endif %}
),

total_diseases as (

    SELECT 
        LOWER(TRIM(n.country::VARCHAR(256))) AS country,
        TO_TIMESTAMP_NTZ(TO_DATE(n.period::STRING, 'YYYY')) AS period,
        LOWER(n.sex::VARCHAR(256)) AS sex,
        COALESCE(n.total_prob,0)::FLOAT4 AS total_prob,
        COALESCE(n.prob_cancer,0)::FLOAT4 AS prob_cancer,
        COALESCE(n.prob_card,0)::FLOAT4 AS prob_card,
        COALESCE(n.prob_diab,0)::FLOAT4 AS prob_diab,
        COALESCE(n.prob_resp,0)::FLOAT4 AS prob_resp,
        COALESCE(i.total_inc,0)::FLOAT4 AS total_inc,
        COALESCE(i.inc_ets,0)::FLOAT4 AS inc_ets,
        COALESCE(i.inc_hep,0)::FLOAT4 AS inc_hep,
        COALESCE(i.inc_hiv,0)::FLOAT4 AS inc_hiv,
        COALESCE(i.inc_resp,0)::FLOAT4 AS inc_resp,
        COALESCE(i.inc_tub,0)::FLOAT4 AS inc_tub
    FROM source2 n
    LEFT JOIN source1 i
        ON n.country = i.country
        AND n.period = i.period
        AND n.sex = i.sex

)

select * from total_diseases