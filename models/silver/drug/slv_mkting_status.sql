with 

source as (

    select * from {{ source('bronze_data','brnz_drug_pre') }}

),

slv_mkting_dis AS (
    
    SELECT DISTINCT
    LOWER(TRIM(mkting_status)) AS mkting_status
    FROM source
    
),

filtered AS (

    SELECT mkting_status FROM slv_mkting_dis
    {% if is_incremental() %}
        WHERE mkting_status NOT IN (SELECT LOWER(TRIM(desc_mkting_status)) FROM {{ this }} )
    {% endif %}
),


slv_mkting AS (SELECT

    {{dbt_utils.generate_surrogate_key(['mkting_status'])}} AS id_mkting_status,
    mkting_status AS desc_mkting_status

FROM filtered)

SELECT * FROM slv_mkting
