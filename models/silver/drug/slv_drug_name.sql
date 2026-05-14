with 


source as (

    select * from {{ source('bronze_data','brnz_drug_pre') }}

),

slv_drug_name_dis AS (
    
    SELECT DISTINCT
    LOWER(TRIM(drug_name)) AS drug_name
    FROM source
    
),

filtered AS (

    SELECT drug_name FROM slv_drug_name_dis
    {% if is_incremental() %}
        WHERE drug_name NOT IN (SELECT LOWER(TRIM(desc_drug_name)) FROM {{ this }})
    {% endif %}

),


slv_drug_name AS (SELECT

    {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
    drug_name AS desc_drug_name

FROM filtered)

SELECT * FROM slv_drug_name