with 
    
source as (

    select * from {{ ref('drug_snp') }}

),

slv_status_dis AS (
    
    SELECT DISTINCT
    mkting_status
    FROM source

),


slv_sponsor AS (SELECT

    {{dbt_utils.generate_surrogate_key(['mkting_status'])}} AS id_mkting_status,
    mkting_status AS desc_mkting_status

FROM slv_status_dis)

SELECT * FROM slv_sponsor
