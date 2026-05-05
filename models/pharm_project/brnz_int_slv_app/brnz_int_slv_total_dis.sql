with 

source1 as (

    select * from {{ source('bronze', 'brnz_infct_dis') }}
    {% if is_incremental() %}
        WHERE (country,period,sex) NOT IN (SELECT DISTINCT country, period, sex FROM {{this}})
    {% endif %}

),

source2 as (

    select * from {{ source('bronze', 'brnz_noninfct_dis') }}
    {% if is_incremental() %}
        WHERE (country,period,sex) NOT IN (SELECT DISTINCT country, period, sex FROM {{this}})
    {% endif %}
),

total_diseases as (

    SELECT 
        n.country::VARCHAR(256) AS country,
        TO_TIMESTAMP_NTZ(TO_DATE(n.period::STRING, 'YYYY')) AS period,
        n.sex::VARCHAR(256) AS sex,
        n.total_prob::FLOAT4 AS total_prob,
        n.prob_cancer::FLOAT4 AS prob_cancer,
        n.prob_card::FLOAT4 AS prob_card,
        n.prob_diab::FLOAT4 AS prob_diab,
        n.prob_resp::FLOAT4 AS prob_resp,
        i.total_inc::FLOAT4 AS total_inc,
        i.inc_ets::FLOAT4 AS inc_ets,
        i.inc_hep::FLOAT4 AS inc_hep,
        i.inc_hiv::FLOAT4 AS inc_hiv,
        i.inc_resp::FLOAT4 AS inc_resp,
        i.inc_tub::FLOAT4 AS inc_tub
    FROM source2 n
    LEFT JOIN source1 i
        ON n.country = i.country
        AND n.period = i.period
        AND n.sex = i.sex

)

select * from total_diseases