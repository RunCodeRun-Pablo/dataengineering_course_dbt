WITH ref_status AS (
    SELECT * FROM {{ ref('fct_status') }}
),

ref_mkting AS (
    SELECT * FROM {{ ref('dim_mkting_status') }}
),

ref_sponsor AS (
    SELECT * FROM {{ ref('dim_sponsor') }}
),

ref_disease AS (
    SELECT * FROM {{ ref('dim_disease') }}
),

ref_drug_name AS (
    SELECT * FROM {{ ref('dim_drug_name') }}
),

joined AS (
    SELECT
        r.id_app_numb,
        sp.desc_sponsor,
        d.desc_drug_name,
        dis.desc_disease,
        curr.desc_mkting_status      AS current_status,
        prev.desc_mkting_status      AS previous_status,
        r.valid_from,
        r.valid_to,
        r.row_status
    FROM ref_status r
    LEFT JOIN ref_mkting curr
        ON r.current_status = curr.id_mkting_status
    LEFT JOIN ref_mkting prev                       -- ← doble join a la misma dim
        ON r.previous_status = prev.id_mkting_status
    LEFT JOIN ref_sponsor sp
        ON r.id_sponsor = sp.id_sponsor
    LEFT JOIN ref_drug_name d
        ON r.id_drug_name = d.id_drug_name
    LEFT JOIN ref_disease dis
        ON r.id_disease = dis.id_disease
),

recently_approved AS (
    SELECT
        desc_sponsor,
        desc_drug_name,
        desc_disease,
        valid_from                      AS approval_date
    FROM joined
    WHERE LOWER(previous_status) = 'none (tentative approval)'
    AND LOWER(current_status) IN ('prescription', 'over-the-counter')
    AND desc_disease != 'other'
),

sponsor_disease_recently_approved AS (
    SELECT
        desc_sponsor,
        desc_disease,
        COUNT(*) AS new_treatments_per_disease
    FROM recently_approved
    GROUP BY desc_sponsor, desc_disease
    ORDER BY new_treatments_per_disease DESC
)

SELECT * FROM sponsor_disease_recently_approved