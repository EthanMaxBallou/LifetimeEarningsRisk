---
unit: F-A (Theoretical framework), F-C (Empirical strategy) — how gamma and
      alpha are constructed, and how they are then analyzed
plan: keep Draft 1's theoretical exposition; append (a) the alpha parts,
      (b) the changes to the gamma/alpha construction, (c) the ML methods
recorded:
status: raw — do not edit
---

<!--
Paste the raw transcript below this line. Leave it exactly as transcribed:
filler, backtracking, garbled terms, and all. Corrections happen downstream in
prose/, never here — this file is the record of what you actually said.

Talking points below are pulled from the actual code (files 3-6.6), so the
specifics are accurate. You don't need to recite them — they're there so you
don't have to reconstruct the pipeline from memory while talking.


=====================================================================
PART 1 — WHAT CARRIES OVER FROM DRAFT 1 (say briefly, don't re-derive)
=====================================================================

  - RIP setup, the u / pi / nu decomposition, the Omega differencing identity,
    and the moment condition. Equations 1-8 are already in the .tex.
  - Just flag what's being reused so the appended material has a seam to attach
    to. The one thing worth re-saying in your own words: what gamma IS to a
    reader who skips the algebra.


=====================================================================
PART 2 — ALPHA (new; the parallel construction)
=====================================================================

  - Gamma = permanent/persistent shock risk. Alpha = transitory shock risk.
    Say what alpha means for a household, and why it's a separate object rather
    than a residual.
  - The two moments are built from the same first-stage residuals but combine
    them differently:
        gamma  =  (1/2) * RG2 * L_j.RG_(j+2+q)
        alpha  =   -1   * RG_q * L_j.RG_j
    Why the sign flip and the different lag structure — that's what separates
    persistent from transitory.
  - J and Q both run from 2 (j = 2..32, q = 2..35-j). Starting at 2 imposes
    MA(1) transitory shocks; starting at 3 would allow MA(2). Worth stating as
    an explicit assumption — it's a modeling choice, not a technicality.
  - Why alpha turns out to be the more predictable of the two (forward
    reference to section 5.1 — transitory shocks are tied to observable job
    position; permanent shocks look idiosyncratic).


=====================================================================
PART 3 — HOW GAMMA AND ALPHA ARE ACTUALLY CALCULATED (the pipeline)
=====================================================================

--- Stage 0: binning (file 4, top) ---
  - agebin: six bins, 22-29 / 30-37 / 38-45 / 46-53 / 54-61 / 62-69.
    46-53 is the reference (the mid-career earnings peak).
  - tenurebin: 0-1 (reference) / 2-5 / 6+.
    UNEMPLOYED ARE ASSIGNED TO THE 0-1 BIN regardless of recorded tenure —
    this is why that bin is so large, and it matters for reading every tenure
    result in the paper. Say it out loud.
  - agebin4: twelve 4-year bins, used only in the first stage.

--- Stage 1: first-stage growth regressions (file 4) — THE CHANGE FROM DRAFT 1 ---
  - Run on earnings DIFFERENCES, not levels. This is the main construction
    change; explain why differencing is the right move.
  - For each horizon z = 1...41: G_z = F_z.y - y, the raw z-year change in log
    earnings, regressed by OLS on time-t characteristics:
        age profiles in 4-year bins interacted with group (race/cohort/
        education) and postgrad; tenure bins; PrRecess; OLF; and census
        division / year / occupation / industry / age fixed effects.
  - The residual RG_z is the part of z-year growth that could NOT be predicted
    from what was observable at time t. Orthogonal to those characteristics at
    every horizon by construction.
  - NO PERSON EFFECTS, deliberately: person intercepts cancel in the
    differencing, and person-specific growth rates are left IN the residuals —
    that's the whole point, since those growth rates are the risk.
  - Run separately for fearn and fhwage.

--- Stage 2: the moment statistics (file 4) ---
  - Products of residuals across horizons, one estimate per person-year per
    (J,Q) pair. So each person-year ends up with MANY noisy estimates.

--- Stage 3: consolidation to one value per person-year (file 5) ---
  - Winsorize at the 1st and 99th percentiles first.
  - Mixed model per person-year (idyear), clustered on person:
        gamma:  GAMMA ~ sumjkq + J,  random intercept + random slope on sumjkq
        alpha:  ALPHA ~ JQ,          random intercept + random slope on JQ
    (sumjkq = J+Q+2; JQ = J*Q; unstructured covariance)
  - The person-year value = fixed intercept + that person-year's random
    intercept (the BLUP). Explain WHY a mixed model rather than an average:
    it shrinks noisy person-years toward the population value instead of
    treating every (J,Q) estimate as equally informative.
  - SE = sqrt(Var(fixed intercept) + Var(random intercept)); CIs at +/- 1.96.
  - Output: four measures — gamma and alpha, each on hourly wage and annual
    earnings.
  - THE GENERATED-REGRESSAND POINT lands here: these four are estimates, and
    section 5 uses them as dependent variables. Say how you want to handle it.


=====================================================================
PART 4 — THE ML METHODS (new)
=====================================================================

--- Shared setup (all three methods) ---
  - Features: year, census division, occupation, two-digit industry, race, age
    bin, PrRecess, OLF, tenure, cohort, and education (EDU1-EDU4 built from
    edyrs: 12-13 / 14-15 / exactly 16 / more than 16).
  - Categoricals one-hot encoded; listwise deletion on missing.
  - Split 70 / 15 / 15 into train / validation / test, seed 42.
  - Features AND target MinMax-scaled, scaler fit on training data only.
    (This is why SHAP values are in scaled-target units — the caveat that shows
    up in the section 5.1 tables.)
  - Predictions inverse-transformed back to natural units and merged back to
    Stata by person-year.

--- Neural network ---
  - Keras: three hidden layers of 500 sigmoid units, dropout 0.5 after the
    first, linear output. Adam, MSE loss, up to 40 epochs, early stopping on
    validation loss with patience 6 and best-weight restore.
  - SHAP via DeepExplainer.

--- Random forest ---
  - 175 trees, max_features 0.75, max_depth 16, min_samples_leaf 5, seed 42.
  - SHAP via TreeExplainer.
  - Say what a forest can capture that OLS can't — this is where your tenure
    finding from section 5.2 comes from.

--- LASSO ---
  - alpha = 1e-5, max_iter 7500. SHAP via LinearExplainer.
  - Note: that penalty is very loose, so this is closer to OLS on the expanded
    dummy set than to an aggressive selection method. Decide how to describe it
    honestly (see the flags below).

--- Interpretation layer ---
  - Mean |SHAP| per feature, summed within control set, DIVIDED BY the number
    of variables in the set. Per-variable, not total — otherwise big sets
    (occupation, year) win mechanically. That division is what makes it the
    F-test analog: an F statistic also divides by the number of restrictions.
  - Benchmark: test MSE against predicting the training mean (file 6.6, which
    rebuilds the same split with seed 42).


=====================================================================
FLAGS — things a referee will ask; decide how you want to answer
=====================================================================

  1. THE SPLIT IS BY ROW, NOT BY PERSON. train_test_split runs on person-year
     rows, so the same individual can appear in both training and test data.
     Risk measures are highly correlated within a person, so some of alpha's
     out-of-sample performance may be the model recognizing people it has
     already seen rather than generalizing to new ones. This is the most
     consequential flag on the list — it bears directly on the headline alpha
     result. Options: re-split grouped by personid and report both, or argue
     why row-splitting is defensible here. Worth deciding before writing.

  2. NO HYPERPARAMETER SEARCH. Depths, widths, tree counts, and the LASSO
     penalty are fixed values, not tuned. The validation set is used only for
     early stopping in the NN. Either tune and report, or say plainly that
     these are reasonable defaults and the finding doesn't hinge on them.

  3. THE LASSO PENALTY IS ~ZERO (1e-5). Hard to call it variable selection.
     The appendix tables are titled "selection results" but rank categories by
     SHAP rather than by what survived the penalty. Reconcile the naming, or
     re-fit at a cross-validated penalty.

  4. UNEMPLOYED SIT IN THE 0-1 TENURE BIN. Every tenure result in the paper —
     including the ML-beats-OLS finding in section 5.2 — is partly a statement
     about unemployment. Needs saying once, explicitly.
-->



So the calculation of this
of these actual risk measures is done.
By first taking a regression of the earnings profile.
With...
Just about all the variables we use later now...
...except for earnings.
So, like annual earnings percentile.
We do not use that variable in the construction of.
The age earnings profiles. So these age earnings.
Profiles can vary in all the variables.
census division Tenure cohort
Race Education also things like
probably a recession, whether in the labor force or not.
And...
all the earnings profiles can vary in all of these.
All of these variables. It's worth...
...noting unemployed people are assigned...
...tenure of zero. So people in the zero one bin...
...tenure can be unemployed in this case.
And so...
This is done, and then...
From there... We have these...
Essentially residuals... Though with a method we use...
There are different residuals. And then those are constructed based on the...
theoretical model and the moments conditions outlined.
In the Druenka Olber paper.
Based off the diff...
... from windows. So... ... there's different horizons.
That were different horizons of residual differences.
And using those moment conditions, the alpha...
...and gamma are constructed. This gives us alpha and gamma.
These correlations across...
all these different windows. So...
In the...
theoretical derivation from the paper before.
The expected value of gamma or the expected value of alpha...
...is in terms of jq and these are these shifting windows.
To calculate the...
Correlation as, you know, this correlation...
is the correlation across these windows essentially.
And so we have the data in terms of...
Person Year JQ or...
For Gamma and Alpha it'd be Gamma or Alpha.
I T J Q and we want to get it to I T J Q.
So just in terms of person years. And so we do this.
We use a mixed...
We use a mixed regression clustered at the person level.
We first wind our eyes. The...
data at this stage, so... after the moment.
Conditions are calculated.
We then wins our eyes and take out the first and 90-ninth.
Percentiles and wins our eyes based on that too.
Try to curb some of the extreme outliers from biasing the sample.
And then we do this mixed regression.
And to consolidate across J and Q.
And to consolidate across J and Q.
And so for gamma.
If you look at the moment condition. The expected value of.
Gamma itjq is equal to sigma squared or.
The correlation this.
Variants. Across shocks.
Plus two extra terms. One term as in terms of...
J plus K plus Q and another term as just in terms of J.
And so we remove this variation in J plus K.
K plus Q and the variation in J in this mixed regression format.
K plus Q and the variation in J in this mixed regression format.
And for alpha we do the same thing.
Except for the alpha.
Moment condition. The expected value converges to...
sigma squared plus a term in term.
An extra term that's in terms of J and Q.
And so, in addition to this...
Both of these, you have a random intercept.
And a slope, so for gamma you have a random intercept and you have a random slope.
In terms of some of JKQ.
And then for alpha you have a random intercept plus.
A random slope of jq.
To get each person's value.
We take the fixed intercept from the main model in both of them.
And then the random intercept.
From the persons. From each in a.
Visuals. Random intercepts.
The mixed regression has an intercept for everyone. And then it has a...
Random intercept for each person.
A year because it's clustered on the...
...person year level or it's clustered on person but the model is...
from a person year random effects.
And so the sum of the main intercept plus the person years.
Intercept gives you.
the actual person's value of either gamma or alpha.
And we do this whole...
workflow this whole method...
...for both annual earnings and...
...hourly earnings... ...that's been annualized.
sout
you know this is
all of these variables were put into the age earnings.
So let's look at this profile point.
For that is to say that each person's earnings profile can...
...vary and all these variables we're going to use later. So as much as before...
...all the variables like, you know, race...
occupation, cohort, industry, education, age...
tenure...all the age earnings profiles can vary in this, which is...
The reason we're trying to use these kind of machine learning methods...
Part of the reason why we kind of want to use these machine learning methods...
Because...
We don't want to misspecify this age earnings profile part and...
The variation that's not being captured there... It's just been captured at...
at the later stage, and we're attributing that to, you know...
These people have more risk of those people have more risk when...
...by construction.
There's a variation being left out because those variables weren't included.
Age running profiles couldn't vary in these variables in the first place.
Such that the variation is purely our thought.
The diagonal in this case is the hope.
The diagonal in this case is the hope.
The diagonal in this case is the hope.
Moving on to the methods however.
So we have three main methods.
So have a neural network with...
three hidden layers of 500 nodes.
There is a sigmoid transformation function.
For all of these, to maintain kind of a smooth gradient.
This is done instead of a relu.
Transformation function.
As much of this should be...
continuous and
predicting on such a small, tight distribution.
And the sigma function was able to perform better in general.
And across the board.
50% dropout after the first layer was done too.
Try to add at least robust enough learning.
As much of this...
would only last a few epochs. So...
With a dropout of 50%, I was hoping that, you know...
there would be some robustness in the training.
And this...this meth...this meth...
that uses the MSE loss.
It trains up to 40 epochs with the early...
Stop patience of six and restore it to the best way.
Stop patience for random forests.
I have a standard set up of 175 trees.
With a max step of 16.
And a minimum sample, leave at 5.
And a minimum sample, leave at 5.
The ability of these two methods to kind of capture.
Interdependencies is really their strength compared to like.
Or less and frankly compared to even LASA.
The ability for them to capture the kind of...
special interdependencies of these is...
Relator Strength. All these are split three ways.
So finally Lasso.
It's just a standard Lasso model with a somewhat loose.
Penalty, but still a penalty nevertheless.
No, it is not too far from LLS.
But it doesn't have exceptionally aggressive selection.
But for all across all three of these...
methods the data is split 70.
15 15 into training validation.
Test data.
Test data.
And the variables used are the same variables.
The variable is used in the OLS and F-test.
The variable is used in the OLS models that have all the controls. So, occupation and industry.
Industry is allowed in all of these.
And then from there, the mean...
...SHAP value... ...is taken.
...for a variable.
And this is done to kind of ...
show the explanatory power of each variable.
Alright well so to speak in this sense.