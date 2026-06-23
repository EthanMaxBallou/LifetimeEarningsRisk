

* Replication Risk5_MixedREG.do from first draft

* Mixed Regression (Table 5 in Paper)


* ===========================================================================
* This program consolidates the raw, noisy gamma and alpha estimates into a
* single value per person-year. The raw file stores many estimates per
* person-year (one for each J-Q combination); a mixed model separates a fixed
* component (shared across all obs) from a person-year-specific random
* intercept. The consolidated value is: fixed intercept + random intercept (b1).
*
* The procedure is run for BOTH earnings measures:
*    fhwage = log real hourly wage    -- kept under the generic, unsuffixed
*                                        names gammaP_WEIGHTED / alphaP_WEIGHTED
*                                        because downstream code (6_*.py and
*                                        7_Analysis.do) expects those names
*    fearn  = log real annual earnings -- output names carry a _fearn suffix
* ===========================================================================


******use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear


* Load raw gamma and alpha estimates. Each obs is one person-year-J-Q combination,
* meaning a given person-year appears multiple times with different J/Q values.
use "/Users/ethanballou/Documents/Data/Risk/AlphaGammaRaw.dta", clear

* Drop obs where J or Q are missing -- both are required for the mixed model
drop if missing(J) | missing(Q)


* Winsorize gamma and alpha at 1st and 99th percentiles to limit influence of
* outliers. Done for both earnings measures (fhwage and fearn).
foreach var in gam_fhwage0_A_ alph_fhwage0_A_ gam_fearn0_A_ alph_fearn0_A_ {
    _pctile `var', percentiles(1 99)
    local p1 = r(r1)
    local p99 = r(r2)
    replace `var' = `p1' if `var' < `p1' & `var' != .
    replace `var' = `p99' if `var' > `p99' & `var' != .
}




* ===========================================================================
* GAMMA CONSOLIDATION
*
* Raw gamma estimates vary across J-Q combinations for each person-year. The
* goal is to produce one gamma per person-year by running a mixed model that
* separates a fixed component (shared across all obs) from a random intercept
* specific to each person-year. The person-year gamma is then:
*    fixed intercept + random intercept (b1).
*
* The same procedure is applied to each earnings measure in turn.
* ===========================================================================

tempfile gamma_fhwage gamma_fearn

foreach earn in fhwage fearn {

    * fhwage is the primary measure and keeps the generic (unsuffixed) names;
    * fearn output names get a _fearn suffix.
    if "`earn'" == "fhwage" {
        local sfx ""
    }
    else {
        local sfx "_`earn'"
    }

    * Work on a copy so the full raw dataset is available for the next measure
    preserve

    * Drop obs with missing gamma for this measure
    drop if missing(gam_`earn'0_A_)

    * Keep only variables needed for estimation
    keep gam_`earn'0_A_ personid year J Q JplusQ JJQQ

    * sumjkq = total number of job spells used to compute this gamma estimate
    * (J jobs + Q quarters + 2 for the base categories)
    gen sumjkq = J + Q + 2

    * Construct a unique person-year ID used as the grouping variable in the
    * mixed model. Encoded as 100*personid + (year - 1969) to fit in a long int.
    gen idyear = .
    recast long idyear
    replace idyear = 100*personid + (year - 1969)

    rename gam_`earn'0_A_ GAMMA

    * Mixed model: GAMMA ~ sumjkq + J (fixed effects) + random intercept and
    * random slope on sumjkq by person-year (idyear). The unstructured covariance
    * lets the random intercept and slope covary freely. SEs are clustered at the
    * person level; var displays the variance components.
    mixed GAMMA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

    * SE for person-year gamma:
    *   SE = sqrt( Var(fixed intercept) + Var(random intercept) )
    * Var(fixed intercept) is _se[_cons]^2; Var(random intercept) is G[2,2], the
    * (2,2) element of the random-effects covariance matrix. Stata orders the
    * random effects with the named slope first and _cons (intercept) last, so
    * the intercept variance is the second diagonal element, not the first.
    local var_cons = _se[_cons]^2
    estat recovar
    mat G = r(cov)
    local var_re = G[2,2]
    local se_P = sqrt(`var_cons' + `var_re')

    * Display the random-effects correlation matrix for inspection
    estat recovar, corr

    * Predict BLUPs of the random effects.
    * b1 = random slope on sumjkq per idyear; b2 = random intercept per idyear.
    predict b*, reffects

    * Person-year gamma: fixed intercept + person-year-specific random intercept.
    * This gives each person-year a single gamma capturing baseline earnings risk,
    * net of the slope contributions of sumjkq and J.
    gen gammaP_WEIGHTED`sfx' = _b[_cons] + b2
    gen gammaP_se`sfx'       = `se_P'
    gen gammaP_ci_lo`sfx'    = gammaP_WEIGHTED`sfx' - 1.96 * gammaP_se`sfx'
    gen gammaP_ci_hi`sfx'    = gammaP_WEIGHTED`sfx' + 1.96 * gammaP_se`sfx'

    label variable gammaP_WEIGHTED`sfx' "Consolidated gamma (`earn')"
    label variable gammaP_se`sfx'       "SE of consolidated gamma (`earn')"

    * Drop estimation inputs; gammaP_* vars are retained
    drop J Q sumjkq JJQQ JplusQ GAMMA b1 b2

    * Each idyear maps to exactly one person-year, so collapse to one row each
    duplicates drop
    drop idyear

    save `gamma_`earn''

    restore
}




* ===========================================================================
* ALPHA CONSOLIDATION
*
* Identical structure to gamma. Raw alpha estimates vary across J-Q combinations
* for each person-year. The mixed model decomposes alpha into a fixed intercept
* and a person-year random intercept. The person-year alpha is:
*    fixed intercept + random intercept (b1).
*
* The same procedure is applied to each earnings measure in turn.
* ===========================================================================

tempfile alpha_fhwage alpha_fearn

foreach earn in fhwage fearn {

    if "`earn'" == "fhwage" {
        local sfx ""
    }
    else {
        local sfx "_`earn'"
    }

    preserve

    * Drop obs with missing alpha for this measure
    drop if missing(alph_`earn'0_A_)

    * Keep only variables needed for estimation
    keep alph_`earn'0_A_ personid year J Q JplusQ JJQQ

    * JQ = interaction of J and Q; this is the regressor used in the alpha model
    gen JQ = J*Q

    * Same person-year ID encoding as gamma
    gen idyear = .
    recast long idyear
    replace idyear = 100*personid + (year - 1969)

    rename alph_`earn'0_A_ ALPHA

    * Mixed model: ALPHA ~ JQ (fixed) + random intercept and random slope on JQ
    * by person-year. Same options as gamma.
    mixed ALPHA JQ ||  idyear: JQ, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

    * SE for person-year alpha:
    *   SE = sqrt( Var(fixed intercept) + Var(random intercept) )
    local var_cons = _se[_cons]^2
    estat recovar
    mat G = r(cov)
    local var_re = G[2,2]
    local se_P = sqrt(`var_cons' + `var_re')

    * Display the random-effects correlation matrix for inspection
    estat recovar, corr

    * Predict BLUPs of the random effects.
    * b1 = random slope on JQ per idyear; b2 = random intercept per idyear.
    predict b*, reffects

    * Person-year alpha: fixed intercept + person-year-specific random intercept
    gen alphaP_WEIGHTED`sfx' = _b[_cons] + b2
    gen alphaP_se`sfx'       = `se_P'
    gen alphaP_ci_lo`sfx'    = alphaP_WEIGHTED`sfx' - 1.96 * alphaP_se`sfx'
    gen alphaP_ci_hi`sfx'    = alphaP_WEIGHTED`sfx' + 1.96 * alphaP_se`sfx'

    label variable alphaP_WEIGHTED`sfx' "Consolidated alpha (`earn')"
    label variable alphaP_se`sfx'       "SE of consolidated alpha (`earn')"

    * Drop estimation inputs; alphaP_* vars are retained
    drop J Q JJQQ JplusQ ALPHA b1 b2 JQ

    * Collapse to one row per person-year
    duplicates drop
    drop idyear

    save `alpha_`earn''

    restore
}




* ===========================================================================
* MERGE CONSOLIDATED ESTIMATES
* Reduce the main dataset to unique person-years, then merge in the consolidated
* gamma and alpha estimates for both earnings measures.
* ===========================================================================
keep personid year

duplicates drop

merge 1:1 personid year using `gamma_fhwage', nogen
merge 1:1 personid year using `gamma_fearn',  nogen
merge 1:1 personid year using `alpha_fhwage', nogen
merge 1:1 personid year using `alpha_fearn',  nogen


* Drop person-years with no consolidated estimate for any measure
drop if missing(gammaP_WEIGHTED) & missing(gammaP_WEIGHTED_fearn) ///
      & missing(alphaP_WEIGHTED) & missing(alphaP_WEIGHTED_fearn)



save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta", replace




use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", clear



* Merge to get demographic variables

**** DROP THE G VARS BEFORE MERGING

merge 1:1 personid year using "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta"

keep if _merge == 3
drop _merge



replace twoind = 0 if twoind == 999
replace oneind = 0 if oneind == 999
replace occ = 0 if occ == 999



*replace veteran = 0 if missing(veteran)






save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma_withDemographics.dta", replace



