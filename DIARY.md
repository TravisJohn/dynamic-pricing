# Diary

One line per session — what it was really about.

---

## Day 0 — Setting up the environment
**A pipeline is only as trustworthy as the plumbing you can re-run, so the first job is a project that builds from scratch on demand.**

- venv, dbt-duckdb, `dbt init`, a profile, and a source pointing at the CSV
- Source vs seed: raw data from elsewhere is a *source*; a small lookup you own is a *seed*
- Read errors literally — "dbt is not recognized" almost always means the venv isn't active

---

## Day 1 — Proving the premise
**The brief claimed the fare ignores the market; the charts had to prove it before any of this work was justified.**

- Built `stg_rides`: rename, reorder, cast — nothing else
- Duration ↔ cost is 0.93; riders-per-driver has no effect on cost per minute at all
- So today's fare = duration + vehicle type, and the market is invisible to it. Premise confirmed
- A chart shows association, not cause — "linked to", never "determined by"

---

## Day 2 — Profiling: what the data can and can't tell us
**Before modelling anything, find out what the data won't give you — because that limitation goes in the memo, not in a test.**

- No natural key: nothing identifies a booking, so one has to be invented
- Quality is clean; the four category columns hold exactly the levels expected
- The real gap: no record of riders declining a price, so **price elasticity is unobservable here**
- Some assumptions can be enforced. Some can only be declared. Knowing which is the skill

---

## Day 3 — Making it enforceable
**Profiling findings are a snapshot of one CSV; tests are what make them true of every future run.**

- Added `ride_id` — md5 of all ten columns, the answer to "no natural key", and the thing tests hang on
- Chose a content hash over `row_number()` because `row_number` can never fail a `unique` test — the test would be decoration
- `unique` + `not_null` on the key is the contract about the *grain*: one row is still one ride
- `not_null` and `accepted_values` on the columns are the contract about the *contents*
- The exercise isn't writing tests, it's choosing the four or five that would catch a real break

---

## Day 4 — Describing the market moment
**A price can only react to what the warehouse describes, so the job was to turn two raw counts into a picture of the market at booking time.**

- `int_ride_market_conditions` adds riders per driver (pressure), market size (scale) and a Balanced / Tight / Scarce band
- Bands use fixed cut-offs, not quantiles, so "Scarce" means the same thing every run
- Scaling and encoding stay out of dbt: they belong to the model, fitted on training data
- `fct_rides` is the thin, stable table everything downstream reads

---

## Day 5 — Finding the moments
**Clustering let the data say which market moments exist, instead of us imposing them.**

- Four standardised market features, then k-means: 3 regimes separate best (silhouette 0.49 vs ~0 for shuffled labels)
- k-means returns only a label per booking and three centres; the names come from reading the centres (the fingerprint)
- Busy, well-supplied (40%) · Driver shortage (11%, riders per driver ~9) · Quiet (50%)
- Location, time and vehicle look the same in every regime: the market moment is independent of where and when

---
