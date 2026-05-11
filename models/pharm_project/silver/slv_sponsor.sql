with 
    
source as (

    select * from {{ ref('drug_snp') }}

),

slv_sponsor_dis AS (
    
    SELECT DISTINCT
    sponsor_name
    FROM source

),


slv_sponsor AS (SELECT

    {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
    sponsor_name AS desc_sponsor

FROM slv_sponsor_dis)

SELECT * FROM slv_sponsor
