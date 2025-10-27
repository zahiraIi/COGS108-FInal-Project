This is your group repo for your final project for COGS108.

This repository is private, and is only visible to the course instructors and your group mates; it is not visible to anyone else.

Template notebooks for each component are provided. The numbers on the notebook filenames provides the order things are due.  See the syllabus for the due dates in your quarter.

You will be graded based solely on the numbered Jupyter notebooks in this repository.  You will recieve your grade and feedback on how to improve via GitHub Issues on this repository. 

We have created a suggested organization for your repo, including directory structures for storing `./data`, `./results`, and for creating `./modules` that your notebooks can import. 

Its worth noting that `./data` is for storing local copies of the data, but by default this repo is configured to **not** allow you to store common datafiles in GitHub.  This is because GitHub has low limits on maximum file and repo size.  So instead you would download your data direct from its original provider or from your personal cloud storage. There are scripts inside some of the notebooks to download data from any URL to `./data`.  If you wish to remove this limitation and store small data files directly in your GitHub you should edit your `.gitignore` file.

But this is *your* repo. You are free to manage the repo as you see fit, edit this README, add data files anywhere you want, etc. So long as there are the four numbered Jupyter notebooks in place on the due dates with the required information, the rest is up to you. 

At the final project date there is an option to make your final project visible to others.  If you choose this option your repo will become publicly visible. 

Also, you are encouraged to share this project after the course and to add it to your portfolio. If your repo is public you may fork it. If it is private you may follow [these instructions](https://docs.google.com/document/d/1_PP-vlsyWjNegGGsmeDB5B-ltjYW1Db14q9dx3HM9e4/edit?usp=sharing)

# COGS 108 Final Project  
**Title:** Evaluating Generalizability and Equity in Heart Disease Risk Prediction

## Team
- Group 141  
- Members: [Zahir Ali], [Omar Abbasi], [Yasir Risvi], [Mostafa Darwish], [Adam Hamadene]

---

## 1. Overview
We build a machine learning classifier to predict whether an individual is at risk of heart disease using standard clinical features such as age, blood pressure, cholesterol, and stress test results. We then evaluate whether this model generalizes across different patient populations drawn from multiple clinical sites (Cleveland Clinic, Hungary, Switzerland, VA Long Beach). Finally, we contextualize any performance gaps by looking at population-level cardiometabolic health patterns in a national health surveillance dataset.

---

## 2. Research Questions
**Q1. Predictive performance:**  
Can we accurately classify individuals as "at risk for heart disease" vs. "not at risk" using clinical features (age, resting blood pressure, cholesterol, etc.)?

**Q2. Generalizability / fairness:**  
Does a classifier trained on one population (e.g. Cleveland patients) perform equally well on patients from other regions (Hungary, Switzerland, VA Long Beach), or does performance degrade?

**Q3. Cardiometabolic context:**  
Do group-level differences in cardiometabolic risk factors (blood pressure, obesity, diabetes, smoking, activity) observed in large-scale population health data align with the differences we see in model performance across regions?

---

## 3. Background & Prior Work
Decades of cardiovascular research, including the Framingham Heart Study, have shown that blood pressure, cholesterol, smoking, and diabetes are strong risk factors for coronary heart disease over 5–10 year horizons. Risk calculators built on those cohorts are routinely used in clinical screening.

However, most historical datasets are not demographically balanced. Clinical guidelines and diagnostic heuristics are known to work better for some groups than others (for example, underdiagnosis and undertreatment in women and certain non-majority populations has been documented in cardiology literature). That motivates fairness questions: if we train a "risk model" on one hospital’s patients, does it still work for a totally different population?

This project extends standard heart disease prediction work by explicitly:
- training a model,
- then stress-testing it across subpopulations,
- and then interpreting differences through the lens of real-world cardiometabolic risk distributions in the broader U.S. population.

We do **not** claim causation or genetics. We treat "region" as a proxy for different underlying populations (which could reflect biology, diet, clinical practice, and structural/social factors).

---

## 4. Hypotheses
**H1 (Predictive Features):**  
Age, cholesterol level, resting blood pressure, and exercise-induced indicators (e.g., max heart rate achieved during stress testing, exercise-induced angina) will be among the most important predictors of heart disease status.

**H2 (Generalization Gap):**  
A model trained on one site (e.g. Cleveland Clinic) will perform best on that same site's patients and will show reduced recall (miss more true cases) when tested on other sites (Hungary, Switzerland, VA Long Beach).  
Interpretation: the same "risk signature" does not fully transfer across populations.

**H3 (Population Health Link):**  
Differences we observe in performance across regions will align with differences in cardiometabolic profiles (rates of hypertension, high cholesterol, obesity, diabetes, smoking, physical inactivity) seen in national survey data. In other words, groups with distinctly different risk factor distributions may also be harder to classify using a model trained elsewhere.

---

## 5. Datasets

### 5.1 Multi-Region Heart Disease Clinical Dataset
- Source: The classic UCI Heart Disease dataset and its related cohorts (Cleveland Clinic, Hungarian Institute of Cardiology, University Hospital Zurich, and the VA Medical Center in Long Beach).
- Each row = one patient clinical record.
- Core features typically include:
  - `age` (years)
  - `sex` (0/1 encoding)
  - `cp` (chest pain type)
  - `trestbps` (resting blood pressure, mm Hg)
  - `chol` (serum cholesterol, mg/dL)
  - `fbs` (fasting blood sugar > 120 mg/dL, yes/no)
  - `restecg` (resting ECG result)
  - `thalach` (max heart rate achieved during stress test)
  - `exang` (exercise-induced angina, yes/no)
  - `oldpeak` (ST depression induced by exercise)
  - `slope` (slope of the ST segment)
  - `ca` (number of major vessels observed by fluoroscopy)
  - `thal` (type of thalassemia / perfusion result)
  - `site` (origin: Cleveland, Hungary, Switzerland, LongBeachVA)
- Target variable:
  - `heart_disease` (binary: 1 = presence of heart disease, 0 = no disease)

We will:
- Train a binary classifier.
- Compute accuracy, precision, recall, F1, ROC AUC.
- Measure these metrics separately for each `site`.

This dataset supports:
- Modeling (for Q1).
- Cross-site fairness / generalization (for Q2).

---

### 5.2 Population Cardiometabolic Health Dataset
We will use a large, de-identified U.S. health surveillance dataset such as BRFSS-derived "Heart Disease Health Indicators" or NHANES-derived cardiometabolic risk data. These datasets typically include:
- Demographics (age, sex)
- Behavioral risk factors (smoking, physical activity)
- Clinical risk factors / diagnoses (high blood pressure, high cholesterol, diabetes, BMI/obesity)
- Self-reported cardiovascular disease diagnosis OR linked cardiovascular outcomes

We will not train our main model on this dataset. Instead, we will:
- Summarize prevalence of cardiometabolic risk factors across demographic groups.
- Visualize differences across subgroups (e.g. % hypertensive, % diabetic).
- Use these summaries to interpret and discuss why a model trained in one setting may underperform elsewhere.

This dataset supports:
- Interpretation & fairness narrative (for Q3).
- Privacy/Ethics section, because it surfaces structural and behavioral differences rather than blaming individuals.

---

## 6. Methods / Analysis Plan

### 6.1 Data Cleaning
- Handle missing values in the clinical dataset (`ca` and `thal` sometimes have `?` / NaN).
- Encode categorical variables (e.g. `cp`, `thal`) as numeric / one-hot.
- Confirm binary target: convert multi-class heart disease score into {0 = no disease, 1 = disease}.
- Remove rows with impossible values (e.g. negative blood pressure).

For the population cardiometabolic dataset:
- Recode responses into consistent numeric indicators:
  - `has_hypertension` (0/1)
  - `obese` (BMI ≥ 30)
  - `diabetic` (0/1)
  - `physically_inactive` (0/1)
- Drop rows with missing critical fields.

We'll document all cleaning decisions in the notebook.

---

### 6.2 Exploratory Data Analysis (EDA)
On the clinical dataset:
- Visualize distributions of key features (histograms of `age`, `chol`, `trestbps`).
- Plot correlation heatmap among numeric predictors.
- Boxplots / violin plots: compare `chol`, `trestbps`, `thalach` for heart_disease = 0 vs 1.
- Bar chart: heart disease prevalence by `site`.

On the population dataset:
- Bar charts of cardiometabolic risk factors across demographic groups.
- Prevalence tables (e.g., % with high BP by sex or by age group).

We will interpret each figure in text.

---

### 6.3 Model Training
- Split the multi-region clinical dataset into train/test.
- Baseline model: Logistic Regression (interpretable coefficients).
- Optionally: Random Forest or Gradient Boosted Trees to capture nonlinear relationships.

Outputs we’ll save:
- ROC curve and AUC.
- Confusion matrix.
- Feature importance / regression coefficients.

We will discuss: Which features are most predictive? Are they modifiable (blood pressure, cholesterol, etc.) or not (age, sex)?

---

### 6.4 Cross-Region Generalization / Fairness Analysis
We will:
1. Train a model using only data from one site (e.g. Cleveland).
2. Evaluate that model separately on:
   - Cleveland (in-sample population)
   - Hungary
   - Switzerland
   - LongBeachVA
3. Record metrics per site: accuracy, precision, recall (sensitivity), F1.

Why recall matters: in a medical triage tool, missing a true positive can delay care.

We will visualize recall by site as a bar plot.

If performance is uneven, we will interpret this as a potential bias / lack of portability of a single-site model.

---

### 6.5 Linking to Cardiometabolic Context
We will then summarize high-level cardiometabolic risk differences from the population dataset (e.g. differences in hypertension, obesity, or diabetes prevalence between demographic groups). We will compare those distributions qualitatively to the clinical sites.

Goal: show that what looks like "model bias" might actually be the model encountering a different physiological / lifestyle baseline than it was trained on.

We will be careful to say correlation ≠ causation.

---

## 7. Privacy / Ethics Considerations
- **Bias & fairness:**  
  If a model under-identifies heart disease risk for a certain site/population, deploying that model clinically could worsen health disparities (missed diagnoses for that group).
- **Generalization limits:**  
  A model trained in one hospital may silently encode that hospital’s demographic mix, diet patterns, access to care, and typical presentation. Applying it elsewhere without auditing is risky.
- **Self-report bias (population dataset):**  
  Survey-based health data can under- or over-report conditions due to recall, access to a diagnosis, or stigma.
- **Data sensitivity:**  
  Clinical heart disease data is de-identified. In real healthcare settings, these same predictors (blood pressure, cholesterol, smoking) are protected health information (PHI). Any deployment must respect HIPAA and avoid secondary misuse (e.g., insurance discrimination).
- **Framing:**  
  We avoid framing cardiovascular risk as purely "personal responsibility." Structural factors (food environment, stress, medical access, occupation, air quality) are real drivers. Our interpretation will make this explicit.

---

## 8. Limitations
- We cannot infer causality, only statistical association.
- Clinical sites differ in more than just "genetics": they also differ in referral patterns, healthcare systems, and which patients even get tested. That means `site` is a noisy mix of biology, environment, and healthcare access.
- The UCI-style clinical dataset is relatively small compared to modern hospital-scale EHRs.
- The population dataset is survey-based and may not map 1:1 to those exact hospital cohorts.

We will clearly acknowledge these in the Conclusion & Discussion.

---

## 9. Deliverables / Outputs We Will Produce
1. **Notebook** (`FinalProject_groupXXX-Fa25.ipynb`):
   - Data cleaning steps (with rationale)
   - EDA visualizations (≥3, labeled axes)
   - Model training and evaluation
   - Cross-site fairness analysis
   - Cardiometabolic context plots
   - Ethics discussion
   - Final conclusion

2. **Short Video (3–5 min)**:
   - Research questions
   - Key plots:
     - ROC curve for the classifier
     - Recall-by-site fairness bar chart
     - Cardiometabolic prevalence comparison
   - Main takeaway for a non-technical audience:
     - "A single heart disease model doesn't fit everyone equally, and that's a health equity issue."

3. **README (this file)**:
   - High-level framing, methods, ethical considerations.

---

## 10. Repository Structure (planned)
```text
/
├─ data/
│  ├─ heart_disease_multisite.csv        # Cleveland / Hungary / etc.
│  ├─ population_cardio_dataset.csv      # BRFSS- or NHANES-style cardiometabolic data
│  └─ data_dictionary.md
├─ FinalProject_groupXXX-Fa25.ipynb      # Main analysis notebook
├─ README.md                             # This file
└─ figures/
   ├─ roc_curve.png
   ├─ recall_by_site.png
   └─ risk_factor_prevalence.png
