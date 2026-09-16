# Take-Home Brief — Dynamic Pricing for a Ride-Share Company

**Timebox:** 1–2 weeks, across several sessions
**Stack:** DuckDB + dbt-core (model layer) · Python / scikit-learn (pricing model)
**Data:** Kaggle "Dynamic Pricing Dataset" (Möbius) — `dynamic_pricing.csv`, ~1,000 rides, 10 columns

---

## The scenario

A ride-share company prices every trip on **one thing: expected ride duration.**
Rain, a concert letting out, three drivers for fifty riders — the price doesn't move.

Leadership wants a **dynamic price**: a fare that reacts to demand and supply.
You've been handed a year-old extract of historical rides and asked:

> "Build us the data foundation and a first pricing model.
> Tell us what it would do to revenue — and what we'd need to trust it."

## The columns

| Column | What it is |
|---|---|
| Number_of_Riders | Riders wanting a ride (demand) |
| Number_of_Drivers | Drivers available (supply) |
| Location_Category | Urban / Suburban / Rural |
| Customer_Loyalty_Status | Regular / Silver / Gold |
| Number_of_Past_Rides | Customer's ride history |
| Average_Ratings | Customer rating |
| Time_of_Booking | Morning / Afternoon / Evening / Night |
| Vehicle_Type | Economy / Premium |
| Expected_Ride_Duration | Minutes |
| Historical_Cost_of_Ride | What was charged — **the target** |

---

## What you'll hand in

1. **A dbt project** — sources, staging, intermediate, marts. Tested and documented.
2. **A pricing notebook** — baseline model, better model, dynamic pricing rule, revenue simulation.
3. **A README** — how to run it, what you built, the decisions you made and why.
4. **A one-page stakeholder memo** — plain English, numbers up front, risks called out.

## How it gets judged

| Area | What "good" looks like |
|---|---|
| Modelling judgment | Grain stated. Right-sized layers — no star schema for its own sake. |
| Data quality | Tests on the things that would actually break decisions. |
| Pricing logic | Beats a duration-only baseline, and shows by how much. |
| Honesty | Says what the data *can't* prove (hint: how riders react to price). |
| Communication | A non-technical exec gets it in 2 minutes. |

---

## The stages

We go one at a time. You attempt → I review → you get a model answer.

| # | Stage | You'll produce |
|---|---|---|
| 0 | **Setup + profile the data** | Working dbt-duckdb project, 6 written observations |
| 1 | **Staging** | `stg_rides` — clean names, types, a key, tests |
| 2 | **Intermediate** | `int_ride_market_conditions` — demand/supply features |
| 3 | **Marts** | `fct_rides` + a pricing-segment summary mart |
| 4 | **Baseline vs better model** | Duration-only model vs full model, MAE + R² |
| 5 | **Dynamic pricing rule** | Surge multiplier + revenue simulation under scenarios |
| 6 | **Write-up** | README + stakeholder memo |

---

## Vocabulary to own by the end

- **Grain** — what one row means. "One row = one ride."
- **Surrogate key** — an ID you make because the data didn't come with one.
- **Staging / intermediate / mart** — clean it · combine it · serve it.
- **Baseline** — the dumbest reasonable model. The bar to beat.
- **MAE** — average dollars you're off by. Easy to say to an exec.
- **Supply–demand ratio** — riders per driver. The heart of surge.
- **Price elasticity** — if price goes up 10%, how many rides do you lose?
- **Leakage** — a feature that secretly contains the answer.
