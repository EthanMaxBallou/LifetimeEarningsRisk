# 7_Tables.do — Documentation

**File:** `Final Code/ThirdDraft/7_Tables.do` (~1,470 lines)
**Purpose:** Single consolidated producer of every table and plot in the third-draft paper (`Paper/Draft3/EARNINGSRISK.tex`). It loads the analysis dataset **once**, handles both earnings measures (hourly wage and annual earnings) side by side, and writes all output to one folder. It replaces the table-producing roles of `7_Analysis.do` (which ran twice via a `$MEAS` global) and `7.1_OtherTables.do`; those two files are kept unchanged as the legacy versions but are no longer the source of the paper's exhibits.

---

## 1. The two risk measures and four outcome variables

The dataset contains one row per person-year with four consolidated risk measures
(from the first stage in `4_GamAlphaCalc.do` and the mixed-model consolidation in
`5_MixedRegConsolidate.do`):

| Variable in dta | Renamed here | Meaning |
|---|---|---|
| `gammaP_WEIGHTED` | `gam_wage` | Gamma (permanent risk), log real **hourly wage** |
| `alphaP_WEIGHTED` | `alph_wage` | Alpha, log real hourly wage |
| `gammaP_WEIGHTED_fearn` | `gam_earn` | Gamma, log real **annual earnings** |
| `alphaP_WEIGHTED_fearn` | `alph_earn` | Alpha, log real annual earnings |

Naming conventions used throughout the file: `gam`/`alph` for the outcome,
`wage`/`earn` for the measure, and (matching the Python exports) the unsuffixed /
`_fearn` filename convention where hourly is the unsuffixed default.

House table style: gamma and alpha are combined into single tables — gamma block
on the left, alpha block on the right, separated by a vertical rule (`|` in the
tabular column spec).

---

## 2. How to run

- **Not called by `master.do`** (deliberate). Run it on its own after the Stata
  pipeline (files 1–5) and the Python scripts (files 6–6.5 plus `6.7_OLS.py`,
  the full-sample OLS baseline predictions) have produced their outputs.
- Runs top to bottom in one pass, ~1–2 minutes. From the command line (the path
  contains a space, and Stata's batch parser splits on spaces, so use a wrapper
  do-file from a space-free directory):

  ```
  # wrapper.do contains one line:
  #   do "/Users/.../Final Code/ThirdDraft/7_Tables.do"
  /Applications/Stata/StataSE.app/Contents/MacOS/stata-se -e do wrapper.do
  grep "^r(" wrapper.log        # empty = clean run (exit code is always 0)
  ```

- **Rerun caveat:** the EARLY DATA PREP section must run immediately after the
  `use` at the top. Re-running it mid-session double-applies the /100 rescaling
  and collides with the `tabulate, generate()` dummies. When in doubt, rerun the
  whole file (it always starts from a fresh `use`). Later sections can be run
  individually in a session where the prep has already run once.

---

## 3. Inputs

| Input | Produced by | Notes |
|---|---|---|
| `Consolidated_AlphaGamma_withDemographics.dta` (in `$DATADIR`) | file 5 | one row per person-year; loaded once at the top |
| `{NN,RF,Lasso,OLS}_predictions_{gamma,alpha}{,_fearn}.csv` (16 files, `$DATADIR`) | 6, 6.1, 6.4, 6.5, 6.7 | columns `personid, year, pred_nn|pred_rf|pred_lasso|pred_ols`; fitted values for every observation of each model's estimation sample, natural units (OLS is fit on the full sample, no train split) |
| `{,RF_,Lasso_}shap_summary_{gamma,alpha}{,_fearn}.csv` (12 files, repo root) | 6.2–6.5 | per-feature mean \|SHAP\| (`Feature`, `Average SHAP Value`) |
| `{,RF_,Lasso_}{occupation,industry}_shap_{gamma,alpha}{,_fearn}.csv` (repo root) | 6.2–6.5 | per-occupation / per-industry mean \|SHAP\| for the rank tables |

All Python-derived inputs are **whatever is currently on disk** — after
retraining any model, rerun this file to refresh every prediction- and
SHAP-derived table.

## 4. Outputs

Everything goes to `$OUTDIR = OtherOutput/ThirdDraft/`. Census: **76 files**
(42 .tex, 10 .png, 24 .pdf), of which one (`ml_test_mse.tex`) is written by
`6.6_MLperformance.py`, not this file. The paper embeds all 76 — the output
folder and the paper's `\input`/`\includegraphics` lists are intentionally 1:1.

---

## 5. Section-by-section reference

Sections appear in the file in this order (matching the paper's narrative:
what is gamma/alpha → what predicts risk → do the methods agree → who has the
most/least risk → appendix).

### S0. Path and spec constants
Globals (not locals, so individual sections can be re-run interactively):
`$DATADIR`, `$REPODIR`, `$OUTDIR`, and the two carried regression
specifications `$RHS_NO` (no occupation/industry controls) and `$RHS_ALL`
(all controls) — exactly models m2 and m5 of `7_Analysis.do`, term order
preserved so results reproduce.

### S1. Early data prep
Everything downstream assumes this ran. In order:
1. **Renames** the four risk measures to `gam_wage`/`alph_wage`/`gam_earn`/`alph_earn`.
2. **Label overrides:** the saved dta's `agebin`/`tenurebin` value labels carry
   "(ref)" markers; they are re-defined here (clean "46-53", "0-1") for table
   display. The dta itself is NOT changed.
3. **Merges the 16 prediction CSVs** (1:1 on personid year, `keep(1 3)`). Every
   CSV uses a generic column name, so each is renamed on import to
   `pred_<nn|rf|lasso|ols>_<gam|alph>_<wage|earn>` — e.g. `pred_lasso_alph_earn`.
4. **`educat`** (0 = less than HS … 4 = Bachelors+), built from `edyrs` to match
   the EDU1–EDU4 dummy definitions; created once here, used by several sections.
5. **Rescaling (/100)** of `EDU1–EDU4 OLF PrRecess ma5aep` — the same scaling
   `7_Analysis.do` used, so regression coefficients read as "×100".
   `currentage` is deliberately NOT rescaled (the profile plots use it raw).
6. **Dummy sets** via `tabulate, generate()`: `race_dum* censdiv_dum* occ_dum*
   year_dum* cohort_dum* twoind_dum* agebin_dum* ten_dum*`, plus `edu_dum1-4`
   copies of the rescaled EDU dummies. These serve the stepwise section (as FE
   sets droppable via `esttab drop(*_dum*)`) and the decile section.

### Summary statistics of the risk measures (`risk_summary_stats.tex`)
The paper's first table. For each of the four actual risk measures, at the
person-year level on the measure's full non-missing sample: mean, SD, the mean
of the bottom and top deciles (spread), person-years, and distinct persons.
No predictions. Note these are the FULL actual samples (e.g. alpha hourly
N = 101,315), slightly larger than the estimation samples used by the
prediction-based sections (there, rows also need all model features present).
The later decile-characteristics tables use a person×age-bin construction —
different by design; this table is the global anchor.

### Table 1: Stratified means (`stratified_means_gamma_alpha.tex`)
Means of all four risk measures by education, race, cohort, age bin, tenure
bin, and income quintiles (annual earnings and hourly wage quintiles via
`xtile`, labeled "1st Quintile" … "5th Quintile"). Built per block with
`collapse`, stacked, exported via `listtex`.

### Age-earnings profile panels (4 .png)
Mean `realearn` / `hwage` (2024 dollars) by age, one panel per cohort × 
white/non-white cell, one line per education group. Two 2×2 grids per measure
(cohort pairs). Lines are **black, distinguished by pattern** in `educwrths`
order: solid = HS Dropout, dashed = HS Graduate, dotted = Some College,
dash-dot = College Graduate. The combined grids have no overall title; a
two-line `note()` states the pattern legend, the measure, and "2024 dollars".

### Mean risk by age across cohorts (4 .png: `mean_{gam,alph}_{wage,earn}_by_age_cohort.png`)
Mean of each raw risk measure by 4-year age bin (`agebin4` bins 1-10 =
ages 22-61; the first stage drops currentage > 61), one line per birth
cohort, one separate PNG per measure (the paper combines them into one 2×2
float, `fig:mean_risk_by_age_cohort`). Same B&W pattern styling as the
profile panels (solid/dash/dot/dash-dot = the four cohorts, oldest first);
no in-plot legend or title — the mapping lives in the paper caption. Fixed
y-ranges so panels compare within measure (0-0.04 gamma, 0-0.2 alpha);
x ticks show the bin ranges at 45°. Rare cohort × bin edge cells with
fewer than 25 person-years are dropped.

### Distribution histograms (`distribution_gamma_alpha_panel.png`)
2×2 histogram panel of the four risk measures.

### Age box plots (`age_density_gamma_alpha_panel.png`)
2×2 panel of box plots over the fine `agebin4` (4-year) bins. Box and whiskers
only: `nooutsides` drops the plotted outside values and `note("")` suppresses
Stata's automatic "excludes outside values" caption; y-axes autoscale.

### OLS tables (`gamma_alpha_ols.tex`)
One 8-column table: Gamma (1)–(4) | divider | Alpha (5)–(8); within each side,
Hourly {No Occ/Ind, All Controls} then Annual {same}. Eight stored `regress`
estimates (`ols_<o>_<meas>_<no|all>`); FE Yes/No rows via `estadd`. The
vertical divider requires a custom `prehead()` supplying
`\begin{tabular}{l*{4}{c}|*{4}{c}}` (esttab cannot emit a piped spec natively).
Stars: * .10 ** .05 *** .01.

### OLS prediction descriptive stats (`ols_pred_summary_stats.tex`)
Distribution of the full-sample OLS fitted values (`pred_ols_*`): Mean,
Median, SD, then (below a divider rule) \% Negative and N. Columns = Annual
(Gamma, Alpha) | Hourly (Gamma, Alpha); moments ×100, \% Negative rendered
with a \% sign, N raw. Sits right after the OLS regression table in the paper.

### F-test tables (`gamma_ftest.tex`, `alpha_ftest.tex`)
Joint significance (testparm) of the 9 control sets (censdiv, year, race,
cohort, occ, ind, education, age bin, tenure) in the No-Occ/Ind and
All-Controls models, both measures → 4 columns per outcome. F and p stored in
matrices, formatted as "F*** (p)"; sets absent from a model print "--".

### Stepwise tables (`gamma_alpha_stepwise.tex`)
Backward elimination (`stepwise, pr(.05)`) of the same two specs per outcome ×
measure, same 8-column combined layout. Checkmark rows = FE sets with at least
one surviving dummy in `e(b)` (one detection loop over prefixes); "Available"
Yes/No rows record what each model was offered. **Wildcard varlists**
(`censdiv_dum*` etc.) are used instead of `7_Analysis.do`'s hard-coded ranges
— this is a correctness fix, not just style: the data now has 36 year and 6
race categories, so the legacy `year_dum1-year_dum27` / `race_dum1-race_dum5`
ranges silently drop candidates. Reference-omitting sets (edu, agebin, tenure)
keep explicit lists. Note: this table inherits esttab's default star levels
(.05/.01/.001), unlike the OLS table — carried over from the original.

### Correlation of ML predictions (`gamma_alpha_pred_corr{,_fearn}.tex`)
Per measure: 3×3 lower-triangle correlations of the NN/RF/LASSO person-year
predictions, Gamma | Alpha, computed on each outcome's estimation sample.
Answers "do the methods agree?" (alpha: yes, ~0.6–0.8; gamma: no — consistent
with gamma's absence of out-of-sample signal).

### Group SHAP shares (`gamma_shap_shares.tex`, `alpha_shap_shares.tex`)
Per-variable average importance of each control set: (sum of the set's mean
\|SHAP\| values) / (number of variables in the set), ×100. Rows = the same 9
control sets as the F-test tables; columns = NN/RF/LASSO for hourly | annual.
Features are assigned to sets by name prefix; the **Age row matches both**
`agebin_*` dummies and the legacy `currentage/currentagesq/currentagecube`
names, so the table works across the feature-spec change in the Python
scripts. Per-variable (not total) averaging is the F-test analog: the F
statistic divides by the number of restrictions, and totals would grow
mechanically with set size. Caveat: SHAP values are in each model's
MinMax-scaled-target units — comparable across methods within a measure,
looser across measures.

### Mean predicted risk by demographic group (`gamma_alpha_pred_means{,_fearn}.tex`)
Per measure: rows = demographic categories in blocks (education, race, cohort,
age bin, tenure bin); columns = Raw | OLS | LASSO | NN | RF | N for Gamma, then
the same six for Alpha ("Raw" is the consolidated risk measure itself; OLS is
the full-sample linear fit from 6.7). Each outcome's block frame is built separately (its
own estimation-sample filter — the samples differ, hence **each side keeps its
own N**) and the two frames are merged on block+category with a row-order key.

### Predicted-risk matrices (16 .tex: `{gamma,alpha}{,_fearn}_pred_matrix_{actual,nn,rf,lasso}.tex`)
Education (rows) × age bin (columns; 5 populated bins, 22-61 — the pipeline's
age-61 cap empties the 62-69 bin) means of actual and each method's
predictions, one small table per outcome × measure × method. The paper stacks
the four methods of a combo into one 2×2 float. Assumes all five age bins are
populated; if one ever empties, the export fails loudly on the missing column.

### Decile characteristics (`{gamma,alpha}{,_fearn}_deciles.tex`)
"Who has really high/low risk": within three broad age bins (22–33, 34–57,
58–61 under the current age-61 cap; `agebin3`, whose third group is coded
58–69 but only 58–61 exists in the data), the percent share of each demographic category (education,
race, cohort, tenure bin, census division) among the top and bottom 10% of
risk, next to the within-bin average ("All"). Key design decisions:
- **Person × age-bin collapse first** (one observation per person per bin;
  category dummies become the person's share of years in the category), done
  **separately per measure** because the estimation samples differ.
- **Gamma is sorted by ACTUAL risk only** — out of sample every method's MSE
  ties the predict-the-mean baseline (see `6.6_MLperformance.py`), so a
  predicted gamma ranking would be noise (and in-sample RF fits would look
  deceptively informative).
- **Alpha is sorted both ways** on the same estimation sample: by the ensemble
  prediction (mean of the three methods' within-bin percentile ranks — rank
  averaging is scale-free) and, independently, by actual risk. The paired
  Pred/Act columns show whether the model's characteristic-based ranking finds
  the same people as the raw values.
- Deciles and All benchmarks are computed **within bin** (otherwise the 58+
  dispersion explosion would make every tail an age proxy).
- Row labels are pulled from the value labels via `levelsof` + `: label`, so
  they stay in sync with the `tabulate, generate()` dummy order automatically.

### Appendix: occ/ind SHAP rank tables (8 .tex) + cross-method rank plots (24 .pdf)
Per outcome × measure × dimension (occupation, industry): a table ranking the
categories by LASSO / NN / RF mean \|SHAP\| (`*_lasso_{occ,ind}_selection.tex`),
followed by the three pairwise cross-method rank scatter plots
(`*_{occ,ind}_rank_{lasso_vs_nn,nn_vs_rf,lasso_vs_rf}.pdf`) with a 45° line.
**Quirk:** LASSO zeroes out a large share of categories, so their SHAP values
tie at exactly 0 and Stata's sort would order them randomly per run; the
category code is used as an explicit tie-break (`gsort -avg_shap code`).
Reproducible — but the tail of any LASSO ranking is code order, not a real
ranking. NN/RF SHAP values are continuous and effectively never tie.

---

## 6. Cross-file notes and known quirks

- **`7_Analysis.do` / `7.1_OtherTables.do`** still exist unchanged (they write
  to `OtherOutput/` and `Plots/`) but are legacy; the paper reads only from
  `OtherOutput/ThirdDraft/`. Their stepwise sections carry the stale
  hard-coded dummy ranges noted above.
- **`6.6_MLperformance.py`** writes `ml_test_mse.tex` into the same output
  folder. It reconstructs the model scripts' train/val/test split by re-running
  `train_test_split` with `random_state=42` on a row-index vector — if the
  seeds or split sizes ever change in files 6/6.1/6.4/6.5, they must change
  there too.
- **Paper-side sizing:** the decile floats use `\resizebox*{!}{0.41\textheight}`
  — the star matters. Unstarred `\resizebox` targets height-above-baseline, and
  baseline-centered tabulars get ENLARGED instead of shrunk.
- **Determinism:** the whole file is deterministic — same inputs give
  byte-identical .tex outputs (used as the standard refactor check).
- **After retraining any Python model:** rerun the relevant 6.x scripts, then
  `python3 6.6_MLperformance.py`, then this file, then recompile the paper.
