WITH ref_status AS (

    SELECT * FROM {{ref("fct_status")}}

)

SELECT
    id_app_numb,
    COUNT(*) AS active_rows
FROM {{ ref('fct_status') }}
WHERE row_status = 'active'
GROUP BY id_app_numb
HAVING COUNT(*) > 1