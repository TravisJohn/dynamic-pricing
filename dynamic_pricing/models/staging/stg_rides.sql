-- stg_rides
-- Grain: one row = one ride booking.
-- Staging job: rename, reorder, cast. No business logic, no new features.

with source as (

    select * from {{ source('raw', 'dynamic_pricing') }}

),

renamed as (

    select
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
