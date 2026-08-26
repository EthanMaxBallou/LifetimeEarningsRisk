

* THERE ARE A FEW DATA CLEANING STEPS STILL - weeks, add student and OLF and unemp status

* After data is cleaned, gamma nad alpha are calculated in the interstage section of the replication





*** This program implements the first stage on earnings DIFFERENCES rather than levels.
*** For each horizon z (1-41), the raw z-year change in log earnings, Gz = Fz.y - y, is
*** regressed by OLS on time-t characteristics: age profiles in 4-year age bins interacted
*** with newgroup (race/cohort/education) and postgrad, tenure bins, PrRecess, OLF, and
*** census division / year / occupation / industry fixed effects.

*** The residuals RGz are the component of z-year earnings growth that could NOT be
*** predicted from time-t characteristics; they are orthogonal to those characteristics
*** at every horizon by construction.

*** No person effects are included: person intercepts cancel in the differencing, and
*** person-specific growth rates are deliberately left in the residuals.

*** The gamma and alpha statistics at the end of the file are computed from the RG residuals.


clear all

set maxvar 20000

use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", clear




***********************************************************************
**                                                                   **
** AGE AND TENURE BINNING                                            **
** Bins are created here (start of the gamma/alpha stage) and saved  **
** back into FullData_CombinedwithTEN so they flow through the       **
** demographics merge in 5_MixedRegConsolidate to 7_Analysis.        **
**                                                                   **
***********************************************************************

capture drop agebin
capture drop tenurebin

* Age bins: 6 bins spanning the 22-69 sample: 22-29, 30-37, 38-45, 46-53, 54-61, 62-69
* The 46-53 bin (middle-age earnings peak) is the reference category downstream.
gen agebin = .
replace agebin = 1 if currentage>=22 & currentage<=29
replace agebin = 2 if currentage>=30 & currentage<=37
replace agebin = 3 if currentage>=38 & currentage<=45
replace agebin = 4 if currentage>=46 & currentage<=53
replace agebin = 5 if currentage>=54 & currentage<=61
replace agebin = 6 if currentage>=62 & currentage<=69

label define agebin_lbl 1 "22-29" 2 "30-37" 3 "38-45" 4 "46-53 (ref)" 5 "54-61" 6 "62-69", replace
label values agebin agebin_lbl
label variable agebin "Age bin (6 groups, 46-53 = reference)"

* Tenure bins (tenure is in whole years): 0-1 (reference), 2-5, 6+
* Unemployed are assigned to the 0-1 reference bin regardless of recorded tenure.
gen tenurebin = .
replace tenurebin = 1 if tenure>=0 & tenure<=1
replace tenurebin = 2 if tenure>=2 & tenure<=5
replace tenurebin = 3 if tenure>=6 & tenure!=.
replace tenurebin = 1 if unemp==1

label define tenurebin_lbl 1 "0-1 (ref)" 2 "2-5" 3 "6+", replace
label values tenurebin tenurebin_lbl
label variable tenurebin "Tenure bin (0-1 = reference; unemployed assigned to 0-1)"

* Fine age bins for the first-stage growth regressions: twelve 4-year bins spanning 22-69
capture drop agebin4
gen agebin4 = floor((currentage-22)/4) + 1 if currentage>=22 & currentage<=69

label define agebin4_lbl 1 "22-25" 2 "26-29" 3 "30-33" 4 "34-37" 5 "38-41" 6 "42-45" ///
    7 "46-49" 8 "50-53" 9 "54-57" 10 "58-61" 11 "62-65" 12 "66-69", replace
label values agebin4 agebin4_lbl
label variable agebin4 "Age bin (12 groups of 4 years, first stage)"


save "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", replace



* Average earnings age profile for each group (group = white + cohort + educwrths)

preserve
collapse (mean) fearn, by(currentage group)
twoway line fearn currentage, by(group, cols(6) title("Average Log Earnings by Age, by Group")) ///
    xtitle("Age") ytitle("Mean fearn")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/avg_fearn_by_age_group.png", replace width(2000)
restore





***********************************************************************
**                                                                   **
** FIRST-STAGE GROWTH REGRESSIONS                                    **
** For each horizon z, regress the raw z-year change in log earnings **
** on time-t characteristics; the residual RG is the part of growth  **
** that could not be predicted at time t. No person effects: person  **
** intercepts cancel in the differencing, and person-specific growth **
** rates are deliberately left in the residuals.                     **
**                                                                   **
***********************************************************************


sort personid year

drop if fearn==. & fhwage==. 

* Build the 41 forward differences in wide form first
forvalues z=1(1)41 {
	gen G`z'_fearn  = F`z'.fearn  - fearn if F`z'.fearn !=. & fearn !=.
	gen G`z'_fhwage = F`z'.fhwage - fhwage if F`z'.fhwage !=. & fhwage !=.
}

* Reshape to long: one row per person-year-horizon
reshape long G@_fearn G@_fhwage, i(personid year) j(z)

label variable z        "horizon (years ahead)"
label variable G_fearn  "z-year change in fearn (t to t+z)"
label variable G_fhwage "z-year change in fhwage (t to t+z)"

drop if G_fearn==. & G_fhwage==.



drop if mod(z, 2) == 1
drop if currentage > 61




compress

gen z2 = z^2
gen z3 = z^3
gen z4 = z^4
gen z5 = z^5


save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_simpleSPEC_difference.dta", replace





capture mkdir "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/ThirdDraft"
capture log close zpoly
log using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/ThirdDraft/4_zpoly_growth.log", ///
	replace text name(zpoly)



reg G_fearn z z2 z3 z4 z5

reg G_fhwage z z2 z3 z4 z5


reg G_fearn i.z

reg G_fhwage i.z

reg G_fearn c.z##i.(race educwrths postgrad censdiv year currentage)



log close zpoly






***********************************************************************
**                                                                   **
** DISTRIBUTION OF EARNINGS GROWTH ACROSS HORIZON (2x2 panel)        **
**                                                                   **
** The z-dimension analogue of the gamma/alpha-across-age panel in   **
** 7_Tables.do. Top row: box plots of the raw z-year change in log   **
** earnings, one per measure, over BINNED horizons (four-year        **
** periods, matching the agebin4 convention, rather than one box per **
** z -- 41 boxes was unreadable). Bottom row: mean profile at full   **
** z resolution                                                      **
** with a 95% CI band -- this is the object the i.z dummies in the   **
** exploratory regressions above are picking up.                     **
** Box and whiskers only (nooutsides; note("") kills the automatic   **
** "excludes outside values" caption).                               **
**                                                                   **
** READ WITH CARE: z is mechanically tied to the age span covered.   **
** A 41-year change is only observable for someone in their twenties **
** at t (mean age 25 at t, 66 at t+z), so the decline at long        **
** horizons is the life-cycle earnings profile, not a horizon effect.**
**                                                                   **
***********************************************************************

preserve

local lbl_fearn  "Annual earnings"
local lbl_fhwage "Hourly wage"

* Horizon bins for the box plots: four-year periods, mirroring the agebin4
* convention used for age. z=41 is folded into the last bin rather than
* standing alone. Defined from z so it is unaffected by whether odd
* horizons are dropped upstream.
capture drop zbin4
gen zbin4 = min(floor((z-1)/4) + 1, 10)
label define zbin4_lbl 1 "1-4" 2 "5-8" 3 "9-12" 4 "13-16" 5 "17-20" ///
    6 "21-24" 7 "25-28" 8 "29-32" 9 "33-36" 10 "37-41", replace
label values zbin4 zbin4_lbl
label variable zbin4 "Horizon bin (4-year periods, years ahead)"

foreach x in fearn fhwage {
    graph box G_`x', over(zbin4, label(angle(45) labsize(vsmall))) ///
        nooutsides note("") ///
        title("`lbl_`x'': growth by horizon", size(medium)) ///
        ytitle("z-year change in log `x'") ///
        name(g_box_z_`x', replace)
}

* Collapse to one row per horizon for the mean profile. The named graphs
* above survive this, so the combine below still finds them.
collapse (mean)   mG_fearn=G_fearn  mG_fhwage=G_fhwage ///
         (semean) seG_fearn=G_fearn seG_fhwage=G_fhwage, by(z)

foreach x in fearn fhwage {
    gen lo_`x' = mG_`x' - 1.96*seG_`x'
    gen hi_`x' = mG_`x' + 1.96*seG_`x'

    twoway (rarea lo_`x' hi_`x' z, color(gs13) lwidth(none)) ///
           (line mG_`x' z, lcolor(black) lwidth(medthick)) ///
         , yline(0, lpattern(dash) lcolor(gs8)) legend(off) ///
           title("`lbl_`x'': mean profile", size(medium)) ///
           xtitle("Horizon z (years)") ytitle("Mean z-year change") ///
           xlabel(1(5)41, labsize(small)) ///
           name(g_prof_z_`x', replace)
}

graph combine g_box_z_fearn g_box_z_fhwage g_prof_z_fearn g_prof_z_fhwage, ///
    cols(2) name(g_z_panel, replace) ysize(6) xsize(8)

graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/growth_by_horizon_panel.png", ///
    replace width(2000)

restore



***********************************************************************
**                                                                   **
** VARIANCE OF EARNINGS GROWTH ACROSS HORIZON (2x2 panel)            **
**                                                                   **
** Top row: Var(Gz) against z with two fitted benchmarks. For the    **
** canonical permanent-transitory model                              **
**     y = p + e,   p_t = p_{t-1} + eta                              **
** the z-year difference has                                         **
**     Var(Gz) = 2*Var(e) + z*Var(eta),                              **
** i.e. AFFINE in z: intercept = twice the transitory variance,      **
** slope = the permanent shock variance. Adding heterogeneous        **
** individual growth rates (which this first stage deliberately      **
** leaves in the residual) contributes a z^2 term. So the linear and **
** quadratic fits are not curve-fitting -- their coefficients ARE    **
** the variance decomposition, and the gap between them is the       **
** evidence for growth-rate heterogeneity.                           **
**                                                                   **
** A ray through the origin is deliberately NOT used as the          **
** benchmark: it would anchor on z=1, the noisiest horizon (a        **
** one-year difference doubles any transitory/measurement error),    **
** and a pure random walk is not the relevant null once a transitory **
** component exists.                                                 **
**                                                                   **
** Bottom row: the variance ratio Var(Gz)/z = 2Var(e)/z + Var(eta)   **
** + Var(beta)*z. It falls as the transitory term is amortised, then **
** flattens toward the permanent variance (the dashed asymptote) and **
** turns UP again if growth-rate heterogeneity is present. A         **
** nonparametric preview of what gamma and alpha summarise, needing  **
** no first-stage regression.                                        **
**                                                                   **
** The fits are unweighted: each horizon is one observation about    **
** the SHAPE, and weighting by cell size would let z=1-2 dominate.   **
**                                                                   **
** CAVEAT: long horizons rest on few observations (N falls by three  **
** orders of magnitude from z=2 to z=41) and no confidence bands are **
** drawn here -- a variance CI under normality would badly overstate **
** precision for earnings growth. Bootstrap by personid before this  **
** goes in the paper.                                                **
**                                                                   **
***********************************************************************

preserve

local lbl_fearn  "Annual earnings"
local lbl_fhwage "Hourly wage"

collapse (sd) sdG_fearn=G_fearn sdG_fhwage=G_fhwage, by(z)

quietly summarize z
local zmin = r(min)
local zmax = r(max)

foreach x in fearn fhwage {
    gen double vG_`x' = sdG_`x'^2
    gen double vr_`x' = vG_`x' / z

    * Permanent-transitory fit: intercept = 2*Var(transitory),
    * slope = Var(permanent shock).
    quietly reg vG_`x' z
    local a_`x' = _b[_cons]
    local b_`x' = _b[z]
    predict double fitlin_`x', xb

    * Add a quadratic term to pick up heterogeneous growth rates.
    quietly reg vG_`x' c.z##c.z
    local c_`x' = _b[c.z#c.z]
    predict double fitquad_`x', xb

    display "VARDECOMP `x': 2*Var(transitory)=" %8.4f `a_`x'' ///
        "  Var(permanent)=" %8.4f `b_`x'' "  z^2 (growth het.)=" %9.6f `c_`x''

    twoway (line vG_`x' z, lcolor(black) lwidth(medthick)) ///
           (line fitlin_`x' z, lcolor(gs8) lpattern(dash)) ///
           (line fitquad_`x' z, lcolor(gs8) lpattern(shortdash)) ///
         , legend(order(1 "Var(Gz)" 2 "Perm-transitory fit" 3 "+ quadratic") ///
             size(vsmall) rows(1) position(6) ring(1)) ///
           title("`lbl_`x'': variance by horizon", size(medium)) ///
           xtitle("Horizon z (years)") ytitle("Var(z-year change)") ///
           xlabel(`zmin'(5)`zmax', labsize(small)) ///
           name(g_var_z_`x', replace)

    * Asymptote of the ratio is the permanent shock variance.
    twoway (line vr_`x' z, lcolor(black) lwidth(medthick)) ///
         , yline(`b_`x'', lpattern(dash) lcolor(gs8)) legend(off) ///
           title("`lbl_`x'': variance ratio", size(medium)) ///
           xtitle("Horizon z (years)") ytitle("Var(z-year change) / z") ///
           xlabel(`zmin'(5)`zmax', labsize(small)) ///
           note("Dashed: fitted permanent variance", size(vsmall)) ///
           name(g_vr_z_`x', replace)
}

graph combine g_var_z_fearn g_var_z_fhwage g_vr_z_fearn g_vr_z_fhwage, ///
    cols(2) name(g_var_panel, replace) ysize(6) xsize(8)

graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/variance_ratio_by_horizon.png", ///
    replace width(2000)

restore









set matsize 1200

local DVLIST "fearn fhwage"

foreach x of local DVLIST {
	sort personid year



	quietly reg G_`x' c.z##c.z##i.(group postgrad race OLF unemp student occ twoind)##i.agebin4 c.z##c.z##(ib1.tenurebin) c.z##c.z##i.(censdiv year occ twoind currentage occ twoind)

	predict R_`x' if e(sample), r
	label variable R_`x' "residual growth of `x' between years t+1 and t+`=`z'+1' (1st stage)"


	display "First-stage growth regressions done: `x'"
}






*****************************************************
**			 GAMMA			   **
*****************************************************

   * gam_[VAR]_jjqq     = (1/2)*(RG2_[VAR])*(Ljj.RG[jj+2+qq]_[VAR])

   * Output names keep the legacy "0_A_" suffix so 5_MixedRegConsolidate
   * and 7_Analysis run unchanged.


global DVLIST "fearn fhwage"







tempfile stats_long_gamma
preserve
    clear
    * create an empty shell dataset for gamma results
    set obs 0
    gen personid   = .
    gen year  = .
    gen J     = .
    gen Q     = .
    gen JplusQ = .
    gen JJQQ   = .
	gen gam_fearn0_A_ = .
	gen gam_fhwage0_A_ = .

	label variable JplusQ "=J+Q"
	label variable JJQQ "1st two dig=J, 2nd two dig=Q"

    save `stats_long_gamma', replace
restore




gen gam_fearn0_A_ = .
gen gam_fhwage0_A_ = .



forvalues j=2(1)32 {
	forvalues q=2(1)`=(35-`j')' {



**NOTE: HERE IS WHERE WE ARE COMPUTING THE GAMMA STATISTICS
**NOTE: BY STARTING J AND Q FROM 2, WE ARE IMPOSING THE BELIEF THAT TRANSITORY SHOCKS ARE MA(1)
**NOTE: WE WOULD START J AND Q FROM 3 IF WE WANT TO ALLOW FOR TRANSITORY SHOCKS TO BE MA(2)

		foreach x in $DVLIST {

			replace gam_`x'0_A_ = (1/2)*(RG2_`x')*(L`j'.RG`=`j'+2+`q''_`x')

		}

		preserve
            keep personid year gam_*
            
			egen anygamma = rownonmiss(gam_*)
			keep if anygamma > 0
			drop anygamma

            * If no obs have non-missing gamma, skip
            count
            if r(N) {
                gen J       = `j'
                gen Q       = `q'
                gen JplusQ  = J + Q
                gen JJQQ    = 100*J + Q


                append using `stats_long_gamma'
                save `stats_long_gamma', replace
            }
        restore

	}
}




*****************************************************
**			 ALPHA			   **
*****************************************************

   *  alph_[VAR]_jjqq    = -1*(RGqq_[VAR])*(Ljj.RGjj_[VAR])



global DVLIST "fearn fhwage"



tempfile stats_long_alpha
preserve
    clear
    * create an empty shell dataset for gamma results
    set obs 0
    gen personid   = .
    gen year  = .
    gen J     = .
    gen Q     = .
    gen JplusQ = .
    gen JJQQ   = .
	gen alph_fearn0_A_ = .
	gen alph_fhwage0_A_ = .

	label variable JplusQ "=J+Q"
	label variable JJQQ "1st two dig=J, 2nd two dig=Q"

    save `stats_long_alpha', replace
restore


gen alph_fearn0_A_ = .
gen alph_fhwage0_A_ = .



forvalues j=2(1)32 {
	forvalues q=2(1)`=(35-`j')' {



**NOTE: HERE IS WHERE WE ARE COMPUTING THE ALPHA STATISTICS
**NOTE: BY STARTING J AND Q FROM 2, WE ARE IMPOSING THE BELIEF THAT TRANSITORY SHOCKS ARE MA(1)
**NOTE: WE WOULD START J AND Q FROM 3 IF WE WANT TO ALLOW FOR TRANSITORY SHOCKS TO BE MA(2)

		foreach x in $DVLIST {

			replace alph_`x'0_A_ = -1*(RG`q'_`x')*(L`j'.RG`j'_`x')

		}

		preserve
            keep personid year alph_*
            
			egen anyalpha = rownonmiss(alph_*)
			keep if anyalpha > 0
			drop anyalpha
			
            * If no obs have non-missing alpha, skip
            count
            if r(N) {
                gen J       = `j'
                gen Q       = `q'
                gen JplusQ  = J + Q
                gen JJQQ    = 100*J + Q


                append using `stats_long_alpha'
                save `stats_long_alpha', replace
            }
        restore

	}
}


preserve
use `stats_long_gamma', clear
save "/Users/ethanballou/Documents/Data/LER_Draft2/GammaRaw.dta", replace
restore

preserve
use `stats_long_alpha', clear
save "/Users/ethanballou/Documents/Data/LER_Draft2/AlphaRaw.dta", replace
restore




keep personid year



merge 1:m personid year using "/Users/ethanballou/Documents/Data/LER_Draft2/AlphaRaw.dta"

drop JplusQ JJQQ

keep if _merge==3
drop _merge




merge 1:1 personid year J Q using "/Users/ethanballou/Documents/Data/LER_Draft2/GammaRaw.dta"

drop JplusQ JJQQ

drop _merge



gen JplusQ = J + Q
gen JJQQ = 100*J + Q
label variable JplusQ "=J+Q"
label variable JJQQ "1st two dig=J, 2nd two dig=Q"


save "/Users/ethanballou/Documents/Data/LER_Draft2/AlphaGammaRaw.dta", replace




