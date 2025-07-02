-- models/marts/fact_ev_specs/fact_ev_specs.sql

with raw as (

    select *
    from {{ ref('stg_ev_data') }}

),

dim as (

    select
        model_id,
        brand,
        model
    from {{ ref('dimension_model') }}

),

final as (

    select
        dim.model_id,

        -- Basic specs
        raw.top_speed_kmh,
        raw.battery_capacity_kWh,
        raw.battery_type,
        coalesce(raw.number_of_cells, 0) as number_of_cells,
        coalesce(raw.torque_nm, 0) as torque_nm,
        raw.efficiency_wh_per_km,
        raw.range_km,
        raw.acceleration_0_100_s,
        raw.fast_charging_power_kw_dc,
        raw.fast_charge_port,
        coalesce(raw.towing_capacity_kg, 0) as towing_capacity_kg,
        try_cast(raw.cargo_volume_l as number) as cargo_volume_l,
        raw.seats,

        -- Standardized categoricals
        upper(trim(raw.drivetrain)) as drivetrain_standardized,
        split_part(trim(raw.segment), '-', 1) as segment_group,
        initcap(trim(raw.car_body_type)) as car_body_type_standardized,

        -- Performance category
        case
            when raw.acceleration_0_100_s < 4.0 then 'High'
            when raw.acceleration_0_100_s between 4.0 and 7.0 then 'Medium'
            when raw.acceleration_0_100_s > 7.0 then 'Low'
            else 'Unknown'
        end as performance_category,

        -- Standardized units
        raw.length_mm,
        raw.width_mm,
        raw.height_mm,
        round(raw.length_mm / 1000.0, 2) as length_m,
        round(raw.width_mm / 1000.0, 2) as width_m,
        round(raw.height_mm / 1000.0, 2) as height_m,

        -- Feature Engineering
        case
            when raw.fast_charging_power_kw_dc > 0 then
                round(raw.battery_capacity_kWh / raw.fast_charging_power_kw_dc, 2)
            else null
        end as fast_charging_ratio,

        raw.source_url

    from raw
    left join dim
        on raw.brand = dim.brand
        and raw.model = dim.model

)

select * from final
