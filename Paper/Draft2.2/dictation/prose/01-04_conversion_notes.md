# Conversion notes — Data through Results 5.2

Source transcripts: `01_data-and-stratified-means.md`, `02_correlates-of-risk.md`,
`03_who-has-the-most-risk.md`, `04_construction-framework-and-strategy.md`.
Written into `EARNINGSRISK.tex` §Data, §Empirical Strategy, §Results 5.1, 5.2.
Compiles clean (43 pages, no undefined references).

Every number in the prose was pulled from the file in
`OtherOutput/SecondDraft2/`, not from the transcript. Where the two disagreed,
the file won and the discrepancy is listed below.

---

## Numbers corrected against the tables

| Said | Table | File |
|---|---|---|
| gamma "0.02 in both cases" | 0.0160 hourly, 0.0248 annual | `risk_summary_stats` |
| annual gamma mean "almost double" hourly | 1.55x — written as "about 55 percent above" | `risk_summary_stats` |
| NN/LASSO alpha hourly corr "0.935" | 0.934 | `gamma_alpha_pred_corr` |
| NN/LASSO alpha annual corr "0.8" | 0.837 | `gamma_alpha_pred_corr_fearn` |
| alpha hourly RF pairs "around .6.7" | 0.603 and 0.657 | `gamma_alpha_pred_corr` |
| gamma R² "0.0040, 0.006"; later "0.01 or 0.013 or 0.06, 0.04" | 0.001, 0.004, 0.003, 0.006 — written as the range 0.001–0.006 | `gamma_alpha_ols` |
| alpha R² "0.022, 0.037, 0.04, 0.045" | 0.022, 0.037, 0.040, 0.052 | `gamma_alpha_ols` |
| age reference category "46 to 50" | 46–53 | `gamma_alpha_ols` |
| last age bin has 1/10 the observations of others | 1,252 vs 7,988–24,279 — written as "six times or more" | `stratified_means` |
| OLF significant for alpha "across all three" | all four columns | `gamma_alpha_ols` |
| alpha F tests "at least to a p-value of 0.41" | garbled; all sets significant, cohort weakest (p<0.10 in col 3) | `alpha_ftest` |
| annual tenure predictions "80% / 10% / 10%" | 80.3 / 10.2 / 9.5 | `alpha_fearn_deciles` |
| annual bottom decile "74% ... 18% and 8%" | 73.5 / 18.1 / 8.4 | `alpha_fearn_deciles` |
| bottom decile 6+ tenure "only 32%" | 31.5 | `alpha_deciles` |
| education SHAP "modest in random forest and lasso" (annual) | RF modest at 0.0219, but **LASSO is large at 0.1156** — corrected | `alpha_shap_shares` |

Numbers that came through exactly right and were used as spoken: 57.1 / 51.7 /
45.0 (gamma tenure deciles), 0.0186 (flat NN gamma prediction), 14.1 / 7.5 /
3.9 (alpha education deciles), 72.8 / 11.4 / 11.1 / 59.3 (alpha tenure
deciles), 17.1 / 7.6 (annual education deciles), 54,361 / 20,207 / 752 (race
counts), and the full education orderings for gamma and alpha on both measures.

---

## Two numbers I could not reconcile — please check

1. **"28 percent of people in that bottom 10 percent are in that 0–1 tenure
   bin."** The actual figure for the middle age group is **48.0** percent
   (hourly) and 50.1 percent (annual). 28 does not appear in that row in either
   decile table, in any age group. I used 48.0. If you were reading a different
   row, tell me which.

2. **Sample age range.** You said "men between the ages of 20 and 69," twice.
   The binning code only assigns ages 22–69, every table starts at 22, and
   Draft 1 says 22–69. I wrote 22–69. If the raw extract starts at 20 and the
   analysis sample is 22–69, that's worth one clarifying clause.

---

## Claims softened because the table did not support them as stated

**"None of these methods are really able to capture that pattern" (gamma
education, predicted means).** The neural network is flat at 0.0186 across
essentially the whole table, which supports the point completely. But the
random forest and LASSO *do* track the gamma education and age patterns fairly
closely. Writing "none of these methods" would have been contradicted by the
table on the facing page.

I resolved it in a way that keeps your conclusion and stays accurate: the NN is
flat; RF and LASSO track, but these are fitted values on the full sample rather
than out-of-sample predictions, and `ml_test_mse` has already established that
nothing beats the mean out of sample for gamma. I then pointed at tenure, where
RF and LASSO have gamma *increasing* across bins when the actual values
decrease — a place the in-sample fit visibly fails. That's the honest version
of the point, and it's arguably stronger.

**"Some college and bachelor's degree significant across all four with both at
p of 0.01."** Some College is p<0.05 in the two hourly columns and p<0.01 in
the two annual columns. Written as significant across all four, with bachelor's
degree reaching p<0.01 in both hourly columns.

---

## Added (not in the transcripts)

- One sentence in 5.2 stating that deciles and the "All" benchmark are computed
  **within** each age group, and why. You explained why the three age groups
  exist but not this; without it the table design looks arbitrary.
- One clause noting occupation is the **smallest** SHAP entry in every column
  of `alpha_shap_shares`, despite being strongly significant in the F tests.
  It's a direct F-test-vs-SHAP divergence sitting in a table you discuss.
- The framing that RF/LASSO gamma fits are in-sample, tied back to the MSE
  table (see above).
- Opening sentence of §Empirical Strategy ("two parts").

## Dropped

- The three repeated "the diagonal in this case is the hope" lines — not
  recoverable. **If that sentence mattered, tell me what it was.**
- "represented by photograph" and several other unrecoverable fragments.
- Spoken table numbers ("Table 11", "table sixteen") — replaced with `\ref`.
- The alpha explanation, per your instruction.

---

## Still open

- **The gamma null is reported but not explained.** §5.1 states that no method
  beats the mean out of sample and that this is a thread running throughout,
  but never says whether that's about gamma or about the *estimate* of gamma.
  Not in any transcript, so not in the prose.
- **No occupation or industry rankings.** The rank figure is discussed only as
  method (dis)agreement; which occupations and industries are actually riskiest
  never comes up.
- **Gamma SHAP shares** get no discussion. Worth one sentence — the NN entries
  there are 0.0000–0.0004, which corroborates the flat-prediction finding.
- **Race, cohort, census division** rows in the decile tables are undiscussed.
  Worth noting that the alpha model over-separates by race the same way it does
  by education: predicted bottom decile is 81.1 percent white against 61.7
  percent actual.
- **Row-vs-person train/test split.**
