with 
    
source as (

    select * from {{ source('bronze_data','brnz_drug_pre') }}
),

slv_sponsor_dis AS (
    
    SELECT DISTINCT
    sponsor_name
    FROM source

    {% if is_incremental() %}
        WHERE sponsor_name NOT IN (
        SELECT desc_sponsor FROM {{ this }}
        )
    {% endif %}

),


slv_sponsor AS (SELECT

    {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
    sponsor_name AS desc_sponsor

FROM slv_sponsor_dis)

SELECT * FROM slv_sponsor
