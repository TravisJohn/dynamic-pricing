-- riders_per_driver divides by market_driver_count.
--
-- Staging asserts the column is never null. Null was never the risk: zero is.
-- Today the minimum is 5, so this passes. That is a fact about this extract,
-- not a promise about the next one -- which is exactly why it is a test and
-- not a comment. A zero driver count fails the build here, at the model that
-- introduced the division.

select
    ride_id,
    market_driver_count
from {{ ref('stg_rides') }}
where market_driver_count is null
   or market_driver_count <= 0
