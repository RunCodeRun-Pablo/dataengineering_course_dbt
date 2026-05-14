WITH ref_uhc_index AS (

    SELECT * FROM {{ref("slv_uhc_index")}}
)

SELECT
    id_country,
    id_period,
    COUNT(*) AS num_rows
FROM ref_uhc_index
GROUP BY id_country, id_period
HAVING COUNT(*) > 1