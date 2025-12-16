# COGS 108 Final Project

**Title:** Funding, Sector, and Geography as Drivers of Startup Outcomes (Failure vs. Acquisition)

## Team
- Group 141  
- Members: Zahir Ali, Omar Abbasi, Yasir Rizvi, Mostafa Darwish, Adam Hamadene

---

## 1. Overview
We analyze how funding size, industry sector, and geography relate to startup outcomes and timing. Using two public datasets (a curated startup outcomes table and a larger Crunchbase-derived corpus), we:
- Profile outcomes (acquired/IPO vs. closed vs. still operating)
- Model the likelihood of success vs. failure
- Explore time-to-event dynamics (from founding to acquisition/closure)
- Compare patterns across sectors and locations (e.g., US regions, states, cities)

The goal is to quantify associations, highlight robust signals, and document uncertainties/biases common in startup databases.

---

## 2. Research Questions
- Q1. Association: How strongly are funding size and intensity (total USD raised, count of rounds) associated with ultimate startup outcomes?
- Q2. Sector/geo effects: Do sector and geography meaningfully shift success vs. failure rates, after controlling for funding intensity?
- Q3. Timing: How do funding, sector, and geography shift time-to-event (acquisition vs. closure)?
- Q4. Robustness: Are the above patterns consistent across two related datasets with different coverage?

---

## 3. Background & Prior Work
Prior research and practitioner reports note that early funding magnitude and deal cadence correlate with exit likelihood; sector cycles (e.g., consumer vs. enterprise, web/mobile vs. deep tech) and regional ecosystems (e.g., Bay Area vs. others) also shape access to capital and networks. However, Crunchbase-like datasets are subject to reporting biases, inconsistent taxonomies, and lagged event labels. We therefore emphasize transparent cleaning, standardized taxonomies, and sensitivity analyses (e.g., winsorization/log transforms for heavy-tailed funding).

---

## 4. Hypotheses
- H1 (Funding): Greater funding_total_usd and more funding_rounds are associated with higher odds of success (acquisition/IPO) vs. failure (closure).
- H2 (Sector): Certain sectors (e.g., enterprise software) exhibit higher success odds than others after adjusting for funding intensity.
- H3 (Geography): Startups in established ecosystems (e.g., CA/Bay Area) have higher success odds and longer survival times than emerging regions.
- H4 (Timing): Higher funding correlates with longer time-to-event overall, and faster time-to-acquisition conditional on success.

---

## 5. Datasets

### 5.1 Dataset #1 — Startup Success Prediction (Kaggle)
- Scope: ~923 companies; rich labels (status, funding_total_usd, funding_rounds, geographies, dates)
- Use: Clean “small” table for rapid EDA, schema validation, and cross-checking patterns
- File (after manual download): `data/00-raw/dataset1.csv`

### 5.2 Dataset #2 — Crunchbase Startup Outcomes (Kaggle-derived)
- Scope: ~66k companies; broader coverage with standardized columns (status, category_list, country_code, region, funding, founded_at, last_funding_at)
- Use: Main corpus for modeling and timing analysis
- File (after manual download): `data/00-raw/dataset2.csv`

Manual download links are provided in the notebook to avoid Google Drive “viewer” HTML downloads.

---

## 6. Methods / Analysis Plan

### 6.1 Data Cleaning & Standardization
- Column normalization to snake_case
- Deduplication (exact and entity-level by `name` where appropriate)
- Currency parsing for `funding_total_usd` (strip $, commas; numeric coercion)
- Date parsing: `founded_at`, `acquired_at`, `closed_at`, `last_funding_at`
- Sector taxonomy: collapse messy `labels`/`category_list` to consistent high-level sectors
- Geography normalization: `country_code`, state/region, and city harmonization
- Outlier handling for funding (IQR flags; sensitivity with winsorization / log1p)

### 6.2 Exploratory Data Analysis (EDA)
- Outcome distributions across sector and geography
- Funding distributions (heavy tails) and relationships with outcome
- Missingness audit and simple missingness correlation map to detect systematic gaps

### 6.3 Outcome Modeling
- Framing: success (acquired/IPO) vs. failure (closed); operating treated as censored/other in descriptive stats
- Models: interpretable baselines (logistic regression) and tree-based (random forest/GBM) for nonlinearity
- Features: funding_total_usd (log1p), funding_rounds, sector group, geography, recency (last_funding_at)
- Evaluation: stratified CV; report AUC, precision/recall, calibration, permutation importance

### 6.4 Time-to-Event (Exploratory)
- Derive `event_date` = first of {acquired_at, closed_at}
- Compute `time_to_event_days = event_date - founded_at`
- Compare survival summaries by sector/geography and funding strata (Kaplan-Meier style summary; no heavy statistical survival modeling required for course scope)

### 6.5 Robustness Across Datasets
- Re-estimate key associations on both datasets
- Compare direction/magnitude of coefficients and partial dependence

---

## 7. Privacy / Ethics
- Label lag and reporting bias: “operating” may be censored; “closed” may be delayed; acquisitions may be underreported in small regions
- Coverage bias: Crunchbase-style data favors well-networked sectors/regions; document representativeness limits
- De-identification: Company-level public data, but avoid doxxing-style inferences; focus on aggregate trends
- Transparency: Publish cleaning rules, taxonomies, and limitations; avoid normative claims about “merit”
- Reproducibility: Keep code/data lineage clear; note manual download requirement to avoid HTML artifacts

---

## 8. Limitations
- Non-causal observational data; omitted-variable bias (e.g., team quality, product-market fit)
- Taxonomy noise in sectors; entity resolution challenges (duplicate or ambiguous names)
- Geographic heterogeneity conflates ecosystem maturity with regulation/cost structures
- Time granularity and label lag can distort survival summaries

---

## 9. Deliverables
1) Jupyter notebooks with:
   - Cleaning, EDA, modeling, time-to-event summaries, ethics/privacy discussion, and conclusions  
2) Processed datasets in `data/02-processed/` suitable for analysis  
3) Short video walkthrough (3–5 min): research questions, key plots, main takeaways  
4) This README summarizing scope, methods, limitations, and repo layout

---

## 10. Repository Structure
```text
/
├─ data/
│  ├─ 00-raw/
│  │  ├─ dataset1.csv                     # Startup Success Prediction (manual download)
│  │  └─ dataset2.csv                     # Crunchbase-derived corpus (manual download)
│  ├─ 01-interim/
│  └─ 02-processed/
├─ modules/
│  └─ get_data.py                         # utility (not used for Drive links in notebook)
├─ 00-ProjectProposal.ipynb               # Proposal + data loading/processing
├─ 01-DataCheckpoint.ipynb                # Data checkpoint
├─ 02-EDACheckpoint.ipynb                 # EDA checkpoint
├─ 03-FinalProject.ipynb                  # Final analysis
├─ results/
└─ README.md
```
