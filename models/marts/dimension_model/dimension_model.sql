
-- Use the `ref` function to select from other models

-- models/marts/dim_model/dim_model.sql

with source as (
    select distinct
        brand,
        model
    from {{ ref('stg_ev_data') }}
),

with_ids as (
    select
        row_number() over (order by brand, model) as model_id,
        brand,
        model
    from source
)

select * from with_ids
