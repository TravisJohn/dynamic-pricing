-- stg_rides
-- Grain: one row = one ride booking.
-- Staging job: rename, reorder, cast, and add a surrogate key.
-- No business logic, no derived features.

with source as (

    select * from {{ source('raw', 'dynamic_pricing') }}

),

renamed as (

    select
        -- surrogate key
        -- The source has no natural key (Stage 0, Q2), so we build one from the
        -- full contents of the row. Content-based, not position-based: the id for
        -- a given ride is the same no matter what order the rows arrive in.
        md5(concat_ws('|',
            cast(Location_Category       as varchar),
            cast(Time_of_Booking         as varchar),
            cast(Vehicle_Type            as varchar),
            cast(Customer_Loyalty_Status as varchar),
            cast(Number_of_Past_Rides    as varchar),
            cast(Average_Ratings         as varchar),
            cast(Number_of_Riders        as varchar),
            cast(Number_of_Drivers       as varchar),
            cast(Expected_Ride_Duration  as varchar),
            cast(Historical_Cost_of_Ride as varchar)
        )) as ride_id,

        -- ride context (categories)
        cast(Location_Category       as varchar) as location_category,
        cast(Time_of_Booking         as varchar) as booking_time_of_day,
        cast(Vehicle_Type            as varchar) as vehicle_type,
        cast(Customer_Loyalty_Status as varchar) as customer_loyalty_status,

        -- customer
        cast(Number_of_Past_Rides    as integer) as customer_past_ride_count,
        cast(Average_Ratings         as double)  as customer_avg_rating,

        -- market at booking time
        cast(Number_of_Riders        as integer) as market_rider_count,
        cast(Number_of_Drivers       as integer) as market_driver_count,

        -- trip
        cast(Expected_Ride_Duration  as integer) as expected_ride_duration_minutes,

        -- target
        cast(Historical_Cost_of_Ride as double)  as historical_ride_cost

    from source

)

select * from renamed
