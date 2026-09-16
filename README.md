# Dynamic Pricing for a Ride-Share Company

A practice take-home: build a dbt data foundation and a first dynamic pricing model for a ride-share company that currently prices trips on duration only.

**Stack:** DuckDB + dbt-core · Python / scikit-learn · Jupyter

See [`BRIEF.md`](BRIEF.md) for the full brief and stages.

## Progress

| Day | Log |
|---|---|
| 0 | [Setup](DAY-0.md) |
| 1 | [Profiling and descriptive analysis](DAY-1.md) |

## Project structure

```
BRIEF.md                 the take-home brief
DAY-*.md                 daily progress logs
data/                    raw CSV (not committed, see below)
notebooks/               exploration notebooks
dynamic_pricing/         dbt project
  models/staging/        sources + stg_rides
```

## Setup

1. **Get the data.** Download `dynamic_pricing.csv` from the [Kaggle Dynamic Pricing Dataset](https://www.kaggle.com/datasets/arashnic/dynamic-pricing-dataset) and put it in `data/`.
2. **Create the environment** (Windows PowerShell):
   ```powershell
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   pip install dbt-duckdb jupyterlab pandas matplotlib scikit-learn
   ```
3. **Run dbt:**
   ```powershell
   cd dynamic_pricing
   dbt run -s stg_rides
   ```
4. **Open the notebook:** `jupyter lab` from the project root, then `notebooks/00_probing.ipynb`.
