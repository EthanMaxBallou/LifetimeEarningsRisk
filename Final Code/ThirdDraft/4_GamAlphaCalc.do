

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


* Interactions: cohort x education and cohort x race.
* cohort is coded 10/20/30/40 and educwrths 1-4, race 1-7, so the sum yields a
* unique categorical code for each cell (e.g. 23 = born 1944-1952, some college).
capture drop cohort_educ cohort_race
gen cohort_educ = cohort + educwrths if cohort!=. & educwrths!=.
gen cohort_race = cohort + race     if cohort!=. & race!=.

label variable cohort_educ "Cohort x education (cohort + educwrths)"
label variable cohort_race "Cohort x race (cohort + race)"


save "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", replace



* Average earnings age profile for each group (group = white + cohort + educwrths)

preserve
collapse (mean) fearn, by(currentage group)
twoway line fearn currentage, by(group, cols(6) title("Average Log Earnings by Age, by Group")) ///
    xtitle("Age") ytitle("Mean fearn")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/avg_fearn_by_age_group.png", replace width(2000)
restore





drop if currentage > 61




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
set matsize 1200

local DVLIST "fearn fhwage"

foreach x of local DVLIST {
	sort personid year

	* Even horizons only, z <= 34
	forvalues z=2(2)34 {

		gen G`z'_`x' = F`z'.`x' - `x' if F`z'.`x' !=. & `x' !=.

		quietly reg G`z'_`x' i.(cohort cohort_educ cohort_race educwrths race OLF occ twoind)##i.agebin4 OLF ib1.tenurebin i.(tenurebin)#i.agebin4 i.(tenurebin)#i.occ i.(censdiv year occ twoind currentage)

		predict RG`z'_`x' if e(sample), r
		label variable RG`z'_`x' "residual growth of `x' between years t+1 and t+`=`z'+1' (1st stage)"

		drop G`z'_`x'
	}
	display "First-stage growth regressions done: `x'"
}

compress
save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_simpleSPEC_difference.dta", replace






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



* Even j and q only, and j+2+q <= 34 so the referenced RG horizon exists
forvalues j=2(2)30 {
	forvalues q=2(2)`=(32-`j')' {



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



* Even j and q only, with j+q <= 34 (both RG horizons exist since max(j,q) <= 32)
forvalues j=2(2)32 {
	forvalues q=2(2)`=(34-`j')' {



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




