with 

source as (

    select * from {{ source('bronze_data','brnz_drug_pre') }}

),

slv_sponsor_dis AS (
    
    SELECT DISTINCT
    LOWER(TRIM(sponsor_name)) AS sponsor_name
    FROM source
    
),

filtered AS (

    SELECT sponsor_name FROM slv_sponsor_dis
    {% if is_incremental() %}
        WHERE sponsor_name NOT IN (SELECT LOWER(TRIM(desc_sponsor)) FROM {{ this }} )
    {% endif %}
),


slv_sponsor AS (SELECT

    {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
    sponsor_name AS desc_sponsor

FROM filtered)

SELECT * FROM slv_sponsor
