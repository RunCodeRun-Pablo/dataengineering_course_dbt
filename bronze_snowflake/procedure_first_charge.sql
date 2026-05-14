CREATE OR REPLACE PROCEDURE PHARM_PROJECT.BRONZE.FIRST_CHARGE()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS '
    BEGIN
    
    --FDA_drug table
    CREATE OR REPLACE TABLE bronze.brnz_drug_pre (
    app_numb VARCHAR(256),
    sponsor_name VARCHAR(256),
    drug_name VARCHAR(256),
    mkting_status VARCHAR(256),
    disease VARCHAR(256),
    price_per_dose FLOAT4);

    COPY INTO bronze.brnz_drug_pre
    FROM (SELECT $1,$2,$3,$6,$7,$8
    FROM ''@"PHARM_PROJECT"."BRONZE"."LANDING_STG"/FDA_drugs.csv'')
    FILE_FORMAT = (FORMAT_NAME = ''bronze.csv_format'')
    ;

    --infc_diseases
    CREATE OR REPLACE TABLE bronze.brnz_infct_dis (
    country VARCHAR(256),
    period VARCHAR(256),
    sex VARCHAR(256),
    inc_resp FLOAT4,
    inc_HIV FLOAT4,
    inc_ETS FLOAT4,
    inc_hep FLOAT4,
    inc_tub FLOAT4,
    total_inc FLOAT4
    );

    COPY INTO bronze.brnz_infct_dis
    FROM ''@"PHARM_PROJECT"."BRONZE"."LANDING_STG"/infc_diseases.csv''
    FILE_FORMAT = (FORMAT_NAME = ''bronze.csv_format'');

    
        --noninfc diseases
       CREATE OR REPLACE TABLE bronze.brnz_noninfct_dis(
            country VARCHAR(256),
            period VARCHAR(256),
            sex VARCHAR(256),
            total_prob FLOAT4,
            prob_cancer FLOAT4,
            prob_card FLOAT4,
            prob_resp FLOAT4,
            prob_diab FLOAT4 
        );

        COPY INTO bronze.brnz_noninfct_dis
        FROM ''@"PHARM_PROJECT"."BRONZE"."LANDING_STG"/non_infc_diseases.csv''
        FILE_FORMAT = (FORMAT_NAME = ''bronze.csv_format'');


    --medical data
    CREATE OR REPLACE TABLE bronze.brnz_doctors (
    country VARCHAR(256),
    period VARCHAR(256),
    doct_per_10000 FLOAT4
);

    COPY INTO bronze.brnz_doctors
    FROM (SELECT $1,$2,$4
    FROM''@"PHARM_PROJECT"."BRONZE"."LANDING_STG"/medicalDoctors.csv'')
    FILE_FORMAT = (FORMAT_NAME = ''bronze.csv_format'');


   
    --pharmacists data
    CREATE OR REPLACE TABLE bronze.brnz_pharmacists (
        country VARCHAR(256),
        period VARCHAR(256),
        pharm_per_10000 FLOAT4
    );

        COPY INTO bronze.brnz_pharmacists
    FROM (SELECT $1,$2,$4
    FROM''@"PHARM_PROJECT"."BRONZE"."LANDING_STG"/pharmacists.csv'')
    FILE_FORMAT = (FORMAT_NAME = ''bronze.csv_format'');

     
    --uhc coverage
    CREATE OR REPLACE TABLE bronze.brnz_UHC_coverage (
    country VARCHAR(256),
    period VARCHAR(256),
    UHC_index INTEGER,
    UHC_class VARCHAR(256)
);

    COPY INTO bronze.brnz_uhc_coverage
    FROM (SELECT $1,$3,$4,
        CASE
            WHEN $4 BETWEEN 0 AND 49 THEN ''WEAK''
            WHEN $4 BETWEEN 50 AND 79 THEN ''INTERMEDIATE''
            WHEN $4 BETWEEN 80 AND 100 THEN ''HIGH''
        END AS $5
    FROM''@"PHARM_PROJECT"."BRONZE"."LANDING_STG"/uhcCoverage.csv'')
    FILE_FORMAT = (FORMAT_NAME = ''bronze.csv_format'');    
    
    RETURN ''FIRST DATA SUCCESSFULLY LOADED'';
    END;
';