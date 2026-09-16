# Day 1: Profiling and descriptive analysis

## What we did

- Answered Q1 (grain): one row = one ride booking
- Built `stg_rides` in dbt: renamed, reordered and cast all 10 columns (`dbt run -s stg_rides` passes)
- Set up the scratch notebook `notebooks/00_probing.ipynb` (DuckDB + a `q()` helper)
- Ran the Round 2 descriptive charts and wrote a narrative insight for each

## Takeaways

**Grain = "one row = one ___"**
- This dataset is not grouped: 4 category columns allow only 72 combinations, but there are 1,000 rows
- Each row mixes three things about one booking: the customer (loyalty, past rides, rating), the market at that moment (riders, drivers), and the trip (duration, cost)
- `Number_of_Riders` is market demand, not the customer

**Staging = rename, reorder, cast. Nothing else**
- No business logic and no new features in staging
- Calculated features (e.g. riders per driver) belong in intermediate
- ML prep (encoding categories) belongs in Python, not dbt

**Notebook vs pipeline**
- Exploring lives in the notebook
- What we keep moves out: features → intermediate model, rules → dbt tests, conclusions → README and memo

**Reading charts**
- A histogram shows the shape, not the reason. Read the overall shape, never a single bar
- A chart shows association, not cause: "linked to", not "determinant"
- Correlation strength: ~0.7+ strong, ~0.4–0.7 moderate, below that weak
- A column correlated with something calculated from it (riders per driver vs driver count) is built in, not a finding

**Narrative insight = 3 parts**
- What we see: only facts you can point to on the chart
- What it likely means: interpretation, worded as a hypothesis
- What we'll do next: turn it into an action

**Running dbt**
- Activate the venv from the outer folder, run dbt from the inner `dynamic_pricing` folder
- "No dbt_project.yml found" means you're in the wrong folder

## Findings

| Chart | Finding |
|---|---|
| Cost distribution | Target is well-behaved: ~$25–$830, wide plateau, slight right lean. Cost per minute has a floor at ~$2.50 and a small high tail |
| Duration vs cost | Strong positive link. Premium sits above Economy. Spread widens on longer rides. Cost doesn't start at $0 |
| Cost per minute by category | Vehicle type is the only category linked to rate (Premium ~$4.15 vs Economy ~$3.50). Location, time of day and loyalty show no difference |
| Riders per driver vs cost per minute | Flat across all demand bands (~$3.90). Today's price does not react to demand or supply |
| Correlation heatmap | Duration ↔ cost 0.93 is the only strong link to the target. Riders ↔ drivers 0.63 (moderate). Everything else near zero |

**In one line:** today's fare is driven by duration and vehicle type, and ignores market conditions.

## Next

1. Finish Stage 0 profiling: Q2 (key), Q3 (quality), Q4 (categories), Q6 (what this data can't tell us)
2. Stage 1: add a surrogate key and tests to `stg_rides`, remove the dbt example models
