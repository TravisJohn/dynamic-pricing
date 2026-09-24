-- int_ride_market_conditions
--
-- Grain: one row = one ride booking. Unchanged from stg_rides.
--        This model adds width, not grain.
--
-- Job:   describe the market conditions each booking happened in, using only
--        what was knowable before the ride was priced.
--
-- What is deliberately NOT here:
--
--   * No scaling / z-scores. A z-score is fitted from the data it is computed
--     over, so writing one into a table freezes today's mean and standard
--     deviation into every row. Next run, new rows shift the statistics and
--     every historical value silently changes meaning. Scaling belongs inside
--     the model pipeline, fitted on train and applied to test.
--
--   * No one-hot encoding. Which encoding is correct depends on the model
--     (k-means wants scaled numerics, trees want neither), and a new category
--     level would silently add a column. The warehouse serves meaning --
--     'Urban' -- and the model pipeline decides how to represent it.
--
--   * No quantile-derived bands. A quantile is recomputed on every run, so the
--     same unchanged ride could move bands because other rides arrived. The
--     thresholds below are fixed, stated, and defensible to a stakeholder.

with rides as (

    select * from {{ ref('stg_rides') }}

),

market as (

    select
        *,

        -- Demand pressure. Riders competing for each available driver.
        -- Dimensionless, so a value is comparable across locations and times.
        -- nullif guards the division; a singular test asserts the divisor is
        -- positive, so a zero would fail the build rather than produce a null.
        market_rider_count::double / nullif(market_driver_count, 0)
            as riders_per_driver,

        -- Size of the moment. Three riders per driver out of 90 people is a
        -- different operational event to three riders per driver out of 25.
        market_rider_count + market_driver_count
            as market_activity_volume

    from rides

)

select

    ride_id,

    -- market: the moment
    market_rider_count,
    market_driver_count,
    riders_per_driver,
    market_activity_volume,

    -- Human-readable label for the same signal. The model uses the ratio;
    -- reports and segment cuts use the band.
    --
    -- Thresholds are a judgment, not a measurement:
    --   under 2 : a driver can serve roughly two riders within a pricing
    --             window, so supply is effectively keeping up
    --   2 to 4  : riders are waiting, but the market clears
    --   4+      : most riders will not get a driver at the current price
    case
        when riders_per_driver < 2 then 'Balanced'
        when riders_per_driver < 4 then 'Tight'
        else 'Scarce'
    end as market_pressure_band,

    -- ride context
    location_category,
    booking_time_of_day,
    vehicle_type,

    -- customer
    customer_loyalty_status,
    customer_past_ride_count,
    customer_avg_rating,

    -- trip
    expected_ride_duration_minutes,

    -- target, carried through for downstream consumers.
    -- Leakage is about what you feed a model, not what sits in a table:
    -- the notebook selects its feature columns explicitly.
    historical_ride_cost

from market
