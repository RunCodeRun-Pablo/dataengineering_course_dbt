with 

source as (

    select * from {{ source('bronze', 'brnz_noninfct_dis') }}

),

renamed as (

    select
        country,
        period,
        sex,
        total_prob,
        prob_cancer,
        prob_card,
        prob_resp,
        prob_diab

    from source

)

select * from renamed