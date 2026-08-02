# Outline — *Predictors of Earnings Risk with Machine Learning* (Draft 2.2)

## Changes since Draft 1

- **Alpha added.** Draft 1 was gamma only; the entire alpha analysis is new.
- **Annual earnings added.** Draft 1 used hourly earnings only. Both gamma and
  alpha are now estimated on log real annual earnings as well as log real hourly
  wage — four risk measures instead of one.
- **Random forest added** alongside the neural network and LASSO.
- **Many more exhibits** — expanded tables and plots throughout, and a rebuilt
  output pipeline (`7_Tables.do` → `OtherOutput/SecondDraft2/`).

## Arc

Three movements: **what is gamma/alpha** → **what is it correlated with** →
**who has the most risk**. The first spans the Theoretical Framework, Data, and
Empirical Strategy sections; the other two are the two halves of Results.

---

## 1. Introduction

## 2. Theoretical Framework

## 3. Data

Includes the descriptive picture of the risk measures:

- Summary statistics of the risk measures
- Stratified means by demographic group
- Average earnings profile plots
- Distribution of gamma and alpha
- Distribution of gamma and alpha across age

## 4. Empirical Strategy

## 5. Results

### 5.1 What is correlated with gamma and alpha

- OLS results
- F-test results
- Stepwise selection results
- Out-of-sample test MSE by method
- Correlation of ML predictions
- Occupation/industry SHAP rank plots — one set in body, rest to appendix
- Group SHAP shares of controls

### 5.2 Who has the most risk

- Mean predicted gamma and alpha by demographic group
- Mean predicted risk by education × age bin — one or two sets, rest to appendix
- Top and bottom risk decile characteristics (gamma, alpha)

## 6. Conclusion

## 7. Appendix

---

## Open

- OLS table: Data section or §5.1? Currently placed in §5.1.
- How many of the four education × age bin matrix sets stay in the body.

---

# Dictation prompt sheets

One sheet per dictation unit — a single table or a tightly knit set. Each is
roughly 3–6 minutes of talking and 1–3 paragraphs of prose.

**How to use these.** Open the exhibit, talk through the questions loosely. Skip
ones that aren't interesting, backtrack, contradict yourself — it's raw
material. These are questions rather than bullet points on purpose: bullets
produce narration ("this table shows…"), questions produce argument. Don't
describe what's in the table; the reader can see the table. Say what it *means*
and what you'd be annoyed by if a referee missed it.

**Order.** Start with **R-D** (out-of-sample MSE) — the gamma null is the claim
the rest of §5.1 has to stay consistent with, and it's easier to write
everything else once that framing is settled. Then the rest of §5.1, then §5.2,
then the descriptives, then the front matter last.

---

## Data / descriptives

### D-A · Summary statistics of the risk measures
`risk_summary_stats.tex`

- Is the headline "there's a lot of risk" or "there's a lot of *variation* in
  risk"? Which one is this paper about?
- Gamma is centered near zero by construction. What does a reader need to know
  so they don't read the mean as economically meaningful?
- How different are the hourly and annual measures, and is that difference
  telling you something about hours vs. wage variation — or is it mechanical?
- The top/bottom decile spread — is that the number you'd quote in a seminar?
  What does it mean concretely for a household at each end?
- Why is this the first table in the paper rather than the stratified means?
- Sample sizes differ from later tables. Does the reader need to know that here?

### D-B · Stratified means by demographic group
`stratified_means_gamma_alpha.tex`

- Which single comparison in this table surprised you most?
- Is there a group that's high on alpha but low on gamma, or vice versa? What
  would that mean?
- Where do these patterns match what a labor economist would guess before seeing
  them, and where don't they?
- This is raw and unconditional. What are you worried a reader will over-read?
- Which of these patterns do you expect to survive controls, and which do you
  expect to vanish?

### D-C · Average earnings profile plots
`avg_realearn_by_age_*.png`, `avg_hwage_by_age_*.png`

- These are about earnings *levels*, not risk. What job are they doing here?
- What should the reader notice — the cohort differences, the race gaps, the
  education fan-out?
- Does the reader need all four panels, or does one carry the point?

### D-D · Distribution of gamma and alpha, overall and across age
`distribution_gamma_alpha_panel.png`, `age_density_gamma_alpha_panel.png`

- Describe the shapes in your own words. Is that what the model predicts?
- What happens to dispersion with age — and is that economics, or estimation
  error at the edges of the panel?
- Later tables compute deciles *within* age bins. Does this figure justify that?
  Set it up here.
- Anything odd — tails, mass points, gamma/alpha asymmetry?

---

## §5.1 What is correlated with gamma and alpha

### R-A · OLS results
`gamma_alpha_ols.tex`

- Which coefficients would you actually put in the abstract?
- Where do gamma and alpha disagree in sign or magnitude, and what's the story?
- What changes when occupation and industry go in? What does that tell you about
  where risk lives?
- Give one magnitude in plain units so a reader can feel it.
- Anything significant but economically trivial, or the reverse?
- Does this table belong here, or back in the Data section as description?

### R-B · F-test results
`gamma_ftest.tex`, `alpha_ftest.tex`

- Rank the nine control sets by how much you *believe* they matter. Where does
  the table disagree with you?
- What's the biggest difference between the gamma and alpha columns?
- Anything jointly significant that you suspect is an artifact — year, cohort,
  census division?
- What does it mean when a control set loses significance once occupation and
  industry are added?

### R-C · Stepwise selection
`gamma_alpha_stepwise.tex`

- What survives that you didn't expect? What dies that you expected to survive?
- Stepwise inference isn't valid. How do you want to frame the table —
  descriptive benchmark, continuity with Draft 1, something else?
- Where does it agree with the F-tests, and where not?
- What does this do that LASSO doesn't?

### R-D · Out-of-sample test MSE — **start here**
`ml_test_mse.tex`

- Say the result in one sentence, the way you'd say it out loud.
- Gamma ties the predict-the-mean baseline. Is that about gamma, or about your
  *estimate* of gamma?
- Walk through the candidates: measurement error in the generated regressand,
  genuine idiosyncrasy, not enough features. Which do you actually favor, and
  why?
- What evidence would separate them? Is any of it feasible?
- Is this a failure or a finding? Your answer sets the tone of the whole paper.
- Does alpha's improvement over the baseline feel substantial or marginal?
- What does this force you to do in the rest of the paper?

### R-E · Correlation of ML predictions
`gamma_alpha_pred_corr.tex`, `gamma_alpha_pred_corr_fearn.tex`

- The methods agree on alpha and not on gamma. Is that independent evidence for
  R-D, or the same fact stated twice?
- What would it have meant if all three agreed on gamma but still couldn't beat
  the baseline?
- Do NN and RF correlate more with each other than with LASSO? What would that
  say about nonlinearity?
- Any meaningful hourly vs. annual difference?

### R-F · Occupation and industry SHAP rankings
`*_lasso_{occ,ind}_selection.tex`, `*_rank_*.pdf`

- Which occupations and industries land at the top? Do they make sense?
- Where do the methods disagree on rank — informative, or noise?
- LASSO zeroes out many categories, so its ranking tail is code order rather
  than a ranking. How prominent should that caveat be?
- One set goes in the body. Which, and why that one?

### R-G · Group SHAP shares of controls
`gamma_shap_shares.tex`, `alpha_shap_shares.tex`

- Which control set dominates for alpha? For gamma?
- Compare to the F-test ranking. Where do the flexible models disagree with the
  linear one, and is that evidence of interactions?
- Why per-variable averaging rather than totals? Say it in your own words.
- SHAP is in scaled-target units. Which comparisons are legitimate?
- Given R-D, how much weight should the gamma columns carry at all?

---

## §5.2 Who has the most risk

### R-H · Mean predicted risk by demographic group
`gamma_alpha_pred_means.tex`, `gamma_alpha_pred_means_fearn.tex`

- Do the models reproduce the raw stratified means from D-B? Where do they miss?
- Where do the three methods disagree about a group, and which do you trust?
- Any group notably over- or under-predicted relative to actual?
- What's the takeaway sentence?

### R-I · Predicted risk by education and age bin
`{gamma,alpha}{,_fearn}_pred_matrix_*.tex`

- What's the pattern — does risk fall with education at every age, or is there a
  real interaction?
- Which method's matrix looks most like the actual one? Does that match R-D?
- Four sets exist. Which one or two earn body space, and on what criterion?

### R-J · Top and bottom risk deciles
`gamma_deciles.tex`, `alpha_deciles.tex`

- Describe the person in the top decile. Then the bottom. Plain language.
- Anything counterintuitive about who ends up in the tails?
- Gamma is sorted by actual risk only, alpha both ways. Explain that asymmetry
  to a skeptical referee.
- For alpha: does the predicted ranking find the *same people* as the actual
  ranking? That's the practical payoff — how well does it work?
- Deciles are computed within age bin. Why, and what goes wrong otherwise?
- Do the hourly and annual panels put the same people at the extremes?

---

## Front and back matter — dictate last

### F-A · Theoretical framework
- Explain the RIP setup to a smart grad student who hasn't seen it.
- Why no individual fixed effect? What does that assumption cost you?
- What *is* gamma, in words, to someone who skips the algebra? What is alpha?
- Why does differencing over overlapping windows identify the persistent
  variance? Intuition, not algebra.
- How much derivation belongs here vs. cited to Drewianka & Oberg (2025)?
- The generated-regressand issue — raise it here or in empirical strategy?

### F-B · Data
- Why PSID? What could you not do with any other dataset?
- Walk through the sample restrictions and the reason for each.
- Why carry both hourly wage and annual earnings all the way through?
- What's in the nine control sets, and which were judgment calls?
- What changed from Draft 1 in the data construction?

### F-C · Empirical strategy
- Why is prediction the right frame here? How do you want to handle "this isn't
  causal" in your own voice?
- Why these three ML methods and not others?
- Explain SHAP to an economist who's never seen it.
- Why is per-variable SHAP the analog of an F-test?
- What's the train/test protocol, and why does the baseline comparison carry so
  much weight?
- What are ensemble rank-averaging and within-bin deciles doing for you?

### F-D · Introduction
- If someone reads one sentence of this paper, what is it?
- Why should a consumption/macro person care? A labor person?
- What did Draft 1 not answer that this one does?
- Three closest papers — how is this different?
- Preview the findings, including the null. In what order?

### F-E · Conclusion
- The three or four findings that survive.
- What does the gamma/alpha asymmetry mean intellectually?
- Implications for consumption models, insurance, policy. How far will you push?
- What limitations would you concede before a referee raises them?
- What's the next paper?

### F-F · Abstract
- After all of the above: say it once out loud, no notes, one paragraph.
