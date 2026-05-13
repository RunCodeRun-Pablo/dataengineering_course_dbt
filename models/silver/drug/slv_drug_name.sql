with 
    
source as (

    select * from {{ ref('drug_snp') }}
    WHERE dbt_valid_to IS NULL
),

slv_drug_name_dis AS (
    
    SELECT DISTINCT
    drug_name
    FROM source
    {% if is_incremental() %}
    WHERE drug_name NOT IN (
    SELECT desc_drug_name FROM {{ this }}
        )
    {% endif %}
),


slv_drug_name AS (SELECT

    {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
    drug_name AS desc_drug_name

FROM slv_drug_name_dis)

SELECT * FROM slv_drug_name