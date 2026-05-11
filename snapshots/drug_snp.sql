{% snapshot drug_snp%}

{{config(
    target_database='pharm_project',
    target_schema='snapshots',
    unique_key='id_app_numb',
    strategy='check',
    check_cols=['mkting_status']
)}}

SELECT
        {{dbt_utils.generate_surrogate_key(['app_numb', 'drug_name'])}} AS id_app_numb,
        app_numb::VARCHAR(256)      AS app_numb,
        sponsor_name::VARCHAR(256)  AS sponsor_name,
        drug_name::VARCHAR(256)     AS drug_name,
        LOWER(disease::VARCHAR(256))       AS disease,
        LOWER(mkting_status::VARCHAR(256)) AS mkting_status,
        price_per_dose::FLOAT4      AS price_per_dose
FROM {{ source('bronze', 'brnz_drug_pre') }}
WHERE LOWER(mkting_status) != 'discontinued'

{% endsnapshot %}