with 
    
source as (

    select * from {{ ref('brnz_int_slv_drug') }}

),

slv_drug_name_dis AS (
    
    SELECT DISTINCT
    drug_name
    FROM source

),


slv_drug_name AS (SELECT

    {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
    drug_name AS desc_drug_name

FROM slv_drug_name_dis)

SELECT * FROM slv_drug_name