{% snapshot slv_drug_snp%}

{{config(
    target_database=env_var('DBT_ENVIRONMENTS') ~ '_silver_pharm',
    target_schema='snapshots',
    unique_key='id_app_numb',
    strategy='check',
    check_cols=['id_mkting_status', 'price_per_dose']
)}}

WITH src AS (
    SELECT * FROM {{ source('bronze_data', 'brnz_drug_pre') }}
),

transf_columns AS (
    SELECT
        LOWER(app_numb::VARCHAR(256))      AS app_numb,
        LOWER(sponsor_name::VARCHAR(256))  AS sponsor_name,
        LOWER(drug_name::VARCHAR(256))     AS drug_name,
        LOWER(disease::VARCHAR(256))       AS disease,
        LOWER(mkting_status::VARCHAR(256)) AS mkting_status,
        price_per_dose::FLOAT4      AS price_per_dose,
        loaded_at::TIMESTAMP_LTZ AS loaded_at
    FROM src
),

column_id AS(
    SELECT
        {{dbt_utils.generate_surrogate_key(['app_numb','drug_name'])}} AS id_app_numb,
        app_numb,
        {{dbt_utils.generate_surrogate_key(['sponsor_name'])}} AS id_sponsor,
        {{dbt_utils.generate_surrogate_key(['drug_name'])}} AS id_drug_name,
        {{dbt_utils.generate_surrogate_key(['disease'])}} AS id_disease,
        {{dbt_utils.generate_surrogate_key(['mkting_status'])}} AS id_mkting_status,
        price_per_dose,
        loaded_at
    FROM transf_columns
)

SELECT * FROM column_id

{% endsnapshot %}