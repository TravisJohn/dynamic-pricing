-- fct_rides
--
-- Grain: one row = one ride booking.
--
-- Job:   the serving layer. This is the table consumers read -- the pricing
--        notebook, any dashboard, any later summary mart. Nothing reaches
--        outside the project except through here.
--
-- Deliberately thin. It adds no transformation on top of the intermediate
-- layer; it exists to be the stable, explicitly-listed contract that
-- downstream work depends on. Renaming a column in the intermediate layer
-- should be an internal change, not a break for the notebook.
--
-- Materialized as a table (marts are read repeatedly, by tools that should not
-- pay to re-run the upstream views each time).

with rides as (

    select * from {{ ref('int_ride_market_conditions') }}

)

select

    ride_id,

    -- the moment
    market_rider_count,
    market_driver_count,
    riders_per_driver,
    market_activity_volume,
    market_pressure_band,

    -- where and when
    location_category,
    booking_time_of_day,
    vehicle_type,

    -- who
    customer_loyalty_status,
    customer_past_ride_count,
    customer_avg_rating,

    -- the trip
    expected_ride_duration_minutes,

    -- what was charged under the current, duration-only pricing policy
    historical_ride_cost

from rides
