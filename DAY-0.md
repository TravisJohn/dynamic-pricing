# Day 0: Setup

## What we did

- Picked the format: coached step by step, dbt model layer + pricing model, full take-home size
- Wrote the brief (`BRIEF.md`): 7 stages, 4 deliverables, how it gets judged
- Built the project: venv, dbt-duckdb, `dbt init`, profile, source pointing at the CSV

## Takeaways

**The problem in one line**
Today the fare depends only on ride duration. Dynamic pricing means the fare also reacts to riders vs drivers.

**venv = the project's own toolbox**
- `(.venv)` in the prompt means the toolbox is open
- Every new terminal starts with it closed, so activate it again
- "dbt is not recognized" almost always means the venv isn't active

**profiles.yml = where dbt finds the database**
- `dbt_project.yml` says *which* profile to use; `profiles.yml` says *where* the database is
- The two names must match exactly
- dbt looks in the project folder first, then `~/.dbt`

**DuckDB = a database that's just one file**
- No server, no password
- Think of it as SQLite, but built for analytics

**Source, not seed**
- Seed = a small lookup table you own (like a region mapping)
- Source = raw data that comes from somewhere else
- The rides CSV is a source, read in place with `external_location`

**Read the error literally**
- "not recognized": the tool isn't on the path
- "profiles.yml is empty": the file really was empty (it hadn't been saved)

## Next: Part B, profile the data

1. Grain: what is one row?
2. Key: is there a primary key? If not, what would you do?
3. Quality: nulls, duplicates, strange ranges?
4. Categories: every value in the 4 text columns
5. Duration vs cost: correlation, and what it says about today's pricing
6. The gap: what you'd need to set a price that this data doesn't have
