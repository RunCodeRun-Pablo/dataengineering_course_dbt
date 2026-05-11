WITH ref AS (

    SELECT * FROM {{ref('drug_snp')}}

),

approved drugs AS (
    SELECT 
    *
    FROM ref
    WHERE mkting_status IN ('over-the-counter','prescription')
)

SELECT * FROM approved_drugs