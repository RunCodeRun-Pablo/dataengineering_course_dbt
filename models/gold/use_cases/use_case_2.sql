WITH ref_drug AS (

    SELECT * FROM {{ref("fct_drug")}}

),

ref_disease AS (

    SELECT * FROM {{ref("dim_disease")}}

),

ref_sponsor AS (

    SELECT * FROM {{ref("dim_sponsor")}}

),

ranking_treatments_sponsor AS (SELECT
    dis.desc_disease,
    sp.desc_sponsor,
    f.num_treatments,
    f.estimated_revenue_index,
    ROW_NUMBER() OVER (
        PARTITION BY f.id_disease
        ORDER BY f.estimated_revenue_index DESC
    )                       AS rank_by_revenue
FROM ref_drug f
LEFT JOIN ref_disease dis
    ON f.id_disease = dis.id_disease
LEFT JOIN ref_sponsor sp
    ON f.id_sponsor = sp.id_sponsor
WHERE dis.desc_disease != 'other'
ORDER BY dis.desc_disease, rank_by_revenue),

top_5 AS (

    SELECT * FROM ranking_treatments_sponsor
    WHERE rank_by_revenue BETWEEN 1 AND 5
)

SELECT * FROM top_5