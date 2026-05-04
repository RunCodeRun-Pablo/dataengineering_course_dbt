{% snapshot users_check_snp%}

SELECT
    app_numb,
    sponsor_name,
    drug_name,
    mkting_status,
    updated_at
FROM {{ source('bronze', 'brnz_drug_pre') }}

{% endsnapshot %}