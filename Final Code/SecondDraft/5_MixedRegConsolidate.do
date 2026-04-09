

* Replication Risk5_MixedREG.do from first draft


* Mixed Regression (Table 5 in Paper)



******use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear


* Load raw gamma and alpha estimates. Each obs is one person-year-J-Q combination,
* meaning a given person-year appears multiple times with different J/Q values.
use "/Users/ethanballou/Documents/Data/Risk/AlphaGammaRaw.dta", clear

* Drop obs where J or Q are missing -- both are required for the mixed model
drop if missing(J) | missing(Q)


* Winsorize gamma and alpha at 1st and 99th percentiles to limit influence of outliers
foreach var in gam_fhwage0_A_ alph_fhwage0_A_ {
    _pctile `var', percentiles(1 99)
    local p1 = r(r1)
    local p99 = r(r2)
    replace `var' = `p1' if `var' < `p1' & `var' != .
    replace `var' = `p99' if `var' > `p99' & `var' != .
}




* ===========================================================================
* GAMMA CONSOLIDATION
*
* Raw gamma estimates vary across J-Q combinations for each person-year.
* The goal is to produce one gamma per person-year by running a mixed model
* that separates a fixed component (shared across all obs) from a random
* intercept that is specific to each person-year. The person-year gamma is
* then: fixed intercept + random intercept (b1).
* ===========================================================================

* Preserve the full dataset so we can restore it after the alpha consolidation
preserve

* Drop obs with missing gamma
drop if missing(gam_fhwage0_A_)

* Keep only variables needed for estimation
keep gam_fhwage0_A_ personid year J Q JplusQ JJQQ

* sumjkq = total number of job spells used to compute this gamma estimate
* (J jobs + Q quarters + 2 for the base categories)
gen sumjkq = J + Q + 2

* Construct a unique person-year ID used as the grouping variable in the mixed model.
* Encoded as 100*personid + (year - 1969) to fit within a long integer.
gen idyear=.
recast long idyear
replace idyear=100*personid+(year-1969)

ren gam_fhwage0_A_ GAMMA

* Mixed model: GAMMA ~ sumjkq + J (fixed effects) + random intercept and
* random slope on sumjkq by person-year (idyear). The unstructured covariance
* allows the random intercept and slope to covary freely. SEs are clustered
* at the person level. The var option displays variance components.
mixed GAMMA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

* Compute the SE for person-year gamma as:
*   SE = sqrt( Var(fixed intercept) + Var(random intercept) )
* Var(fixed intercept) comes from the fixed-effects VCV matrix via _se[_cons].
* Var(random intercept) is G[1,1] -- the (1,1) element of the random-effects
* covariance matrix, which corresponds to the variance of the random intercept (b1).
local var_cons_gamma = _se[_cons]^2
estat recovar
mat G_gamma = r(cov)
local var_re_gamma = G_gamma[1,1]
local se_gammaP = sqrt(`var_cons_gamma' + `var_re_gamma')

* Display the random-effects correlation matrix for inspection
estat recovar, corr

* Predict BLUPs (best linear unbiased predictors) of the random effects.
* b1 = random intercept per idyear; b2 = random slope on sumjkq per idyear.
predict b*, reffects

* Person-year gamma: fixed intercept + person-year-specific random intercept.
* This gives each person-year a single gamma capturing baseline earnings risk,
* net of the slope contributions of sumjkq and J.
gen gammaP_WEIGHTED = _b[_cons] + b1

* 95% CI bounds using the combined SE (same value for all person-years since
* it is derived from model-level variance components, not individual BLUPs)
gen gammaP_se = `se_gammaP'
gen gammaP_ci_lo = gammaP_WEIGHTED - 1.96 * gammaP_se
gen gammaP_ci_hi = gammaP_WEIGHTED + 1.96 * gammaP_se

* Drop estimation inputs; gammaP_WEIGHTED and CI vars are retained
drop J Q sumjkq JJQQ JplusQ GAMMA b1 b2

* Each idyear maps to exactly one person-year, so collapse to one row per person-year
duplicates drop

drop idyear

tempfile gamma_tempfile
save `gamma_tempfile'

restore




* ===========================================================================
* ALPHA CONSOLIDATION
*
* Identical structure to gamma. Raw alpha estimates vary across J-Q combinations
* for each person-year. The mixed model decomposes alpha into a fixed intercept
* and a person-year random intercept. The person-year alpha is:
* fixed intercept + random intercept (b1).
* ===========================================================================

preserve

* Drop obs with missing alpha
drop if missing(alph_fhwage0_A_)

* Keep only variables needed for estimation
keep alph_fhwage0_A_ personid year J Q JplusQ JJQQ

gen sumjkq = J + Q + 2

* JQ = interaction of J and Q; this is the regressor used in the alpha mixed model
gen JQ = J*Q

* Same person-year ID encoding as gamma
gen idyear=.
recast long idyear
replace idyear=100*personid+(year-1969)

ren alph_fhwage0_A_ ALPHA

* Mixed model: ALPHA ~ JQ (fixed) + random intercept and random slope on JQ
* by person-year. Same options as gamma.
mixed ALPHA JQ ||  idyear: JQ, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

* Compute SE for person-year alpha:
*   SE = sqrt( Var(fixed intercept) + Var(random intercept) )
local var_cons_alpha = _se[_cons]^2
estat recovar
mat G_alpha = r(cov)
local var_re_alpha = G_alpha[1,1]
local se_alphaP = sqrt(`var_cons_alpha' + `var_re_alpha')

* Display the random-effects correlation matrix for inspection
estat recovar, corr

* Predict BLUPs of the random effects.
* b1 = random intercept per idyear; b2 = random slope on JQ per idyear.
predict b*, reffects
*predict alpha_real, fitted

* Person-year alpha: fixed intercept + person-year-specific random intercept
gen alphaP_WEIGHTED = _b[_cons] + b1

* 95% CI bounds
gen alphaP_se = `se_alphaP'
gen alphaP_ci_lo = alphaP_WEIGHTED - 1.96 * alphaP_se
gen alphaP_ci_hi = alphaP_WEIGHTED + 1.96 * alphaP_se

* Drop estimation inputs; alphaP_WEIGHTED and CI vars are retained
drop J Q sumjkq JJQQ JplusQ ALPHA b1 b2 JQ

* Collapse to one row per person-year
duplicates drop

drop idyear

tempfile alpha_tempfile
save `alpha_tempfile'

restore




* Reduce main dataset to unique person-years, then merge in consolidated
* gamma and alpha estimates from the tempfiles
keep personid year

duplicates drop


merge 1:1 personid year using `gamma_tempfile', nogen
merge 1:1 personid year using `alpha_tempfile', nogen


* Drop person-years where both gamma and alpha are missing
drop if missing(gammaP_WEIGHTED) & missing(alphaP_WEIGHTED)



save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta", replace




use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", clear



* Merge to get demographic variables

**** DROP THE G VARS BEFORE MERGING

merge 1:1 personid year using "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta"

keep if _merge == 3
drop _merge



*replace veteran = 0 if missing(veteran)



save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma_withDemographics.dta", replace




