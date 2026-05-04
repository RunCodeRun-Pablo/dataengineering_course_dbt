{% snapshot drug_timestamp_snp%}

{{config(
    target_database='pharm_project',
    target_schema='snapshots',
    unique_key='app_numb',
    strategy='timestamp',
    updated_at='updated_at'
)}}

SELECT
    app_numb,
    sponsor_name,
    drug_name,
    mkting_status,
    updated_at
FROM {{ source('bronze', 'brnz_drug_pre') }}

{% endsnapshot %}