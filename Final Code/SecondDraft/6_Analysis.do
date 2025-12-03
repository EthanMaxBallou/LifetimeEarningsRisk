/*


Old method for generating dummies - new method adds label to the name of the dummy

tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)
tabulate cohort, generate(cohort_dum)
tabulate twoind, generate(twoind_dum)

use "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", clear


*/


* new method adds the labels to the dummies? Can't straight up rename the variable since they have to be specified in the regression i.( ex )



clear all

use "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma_withDemographics.dta", replace


ssc install estout


/*

tabulate twoind, generate(twoind_)

* get the value label name
local vl : value label twoind

* get the actual codes in order
levelsof twoind, local(levels)

* start a counter
local i = 1
foreach l of local levels {
    local lbl : label `vl' `l'
    label var twoind_`i' "`lbl'"
    local ++i
}



*/



* some clean up set numeric values of state to missing

replace state = . if state < 0





* Old method


tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)
tabulate cohort, generate(cohort_dum)
tabulate twoind, generate(twoind_dum)







* Gamma Analysis


gen EDU1 = (edmaxyrs < 12)
gen EDU2 = (edmaxyrs >= 12) & (edmaxyrs < 14)
gen EDU3 = (edmaxyrs >= 14) & (edmaxyrs < 16)


* Generate squared terms for age, tenure, and edmaxyrs
gen tenure_squared = tenure^2
gen edmaxyrs_squared = edmaxyrs^2
gen edmaxyrs_cubed = edmaxyrs^3

gen PRsquare = PrRecess^2
gen rGDPsquare = rGDPgrow^2





* CLEAN UP LABELS HERE

label var EDU1 "Less than High School"
label var EDU2 "High School Graduate"
label var EDU3 "Some College"

label var currentage "Age"
label var currentagesq "Age Squared"
label var currentagecube "Age Cubed"

label var tenure "Tenure"

label var OLF "Out of Labor Force"



rename (gammaP_WEIGHTED alphaP_WEIGHTED) (Gamma Alpha)





* Descriptive plots

twoway (scatter Gamma currentage), title("Distribution of Age and Gamma") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_gammaP_WEIGHTED.png", replace


histogram Gamma, title("Distribution of Gamma") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_gammaP_WEIGHTED.png", replace


log using "MainAnalysis.smcl", name(log1) replace

log using "MainAnalysis.txt", text name(log2) replace


* Calculate and display the standard deviation of gammaP_WEIGHTED
summarize Gamma
display "The standard deviation of gammaP_WEIGHTED is: " r(sd)


* OLS


eststo clear

* No controls
eststo m1: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5

* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_regressions.tex", ///
    replace se r2 label ///
    keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube) ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* Stepwise regression

eststo clear

* No controls - capture output
tempfile stepwise_log1
log using `stepwise_log1', text replace
eststo step1: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube 
log close

* Extract removal order from log
preserve
import delimited using `stepwise_log1', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise_removal_noctrl.csv", replace
restore

estadd local state_fe "No": step1
estadd local year_fe  "No": step1
estadd local race_fe  "No": step1
estadd local cohort_fe "No": step1
estadd local occ_fe   "No": step1
estadd local ind_fe   "No": step1

* controls - no occ or ind - capture output
tempfile stepwise_log2
log using `stepwise_log2', text replace
eststo step2: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log2', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise_removal_nooccind.csv", replace
restore

estadd local state_fe "Yes": step2
estadd local year_fe  "Yes": step2
estadd local race_fe  "Yes": step2
estadd local cohort_fe "Yes": step2
estadd local occ_fe   "No": step2
estadd local ind_fe   "No": step2

* controls - no occ - capture output
tempfile stepwise_log3
log using `stepwise_log3', text replace
eststo step3: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log3', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise_removal_noocc.csv", replace
restore

estadd local state_fe "Yes": step3
estadd local year_fe  "Yes": step3
estadd local race_fe  "Yes": step3
estadd local cohort_fe "Yes": step3
estadd local occ_fe   "No": step3
estadd local ind_fe   "Yes": step3

* controls - no ind - capture output
tempfile stepwise_log4
log using `stepwise_log4', text replace
eststo step4: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log4', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise_removal_noind.csv", replace
restore

estadd local state_fe "Yes": step4
estadd local year_fe  "Yes": step4
estadd local race_fe  "Yes": step4
estadd local cohort_fe "Yes": step4
estadd local occ_fe   "Yes": step4
estadd local ind_fe   "No": step4

* All controls - capture output
tempfile stepwise_log5
log using `stepwise_log5', text replace
eststo step5: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log5', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise_removal_allctrl.csv", replace
restore

estadd local state_fe "Yes": step5
estadd local year_fe  "Yes": step5
estadd local race_fe  "Yes": step5
estadd local cohort_fe "Yes": step5
estadd local occ_fe   "Yes": step5
estadd local ind_fe   "Yes": step5

* Export stepwise results to LaTeX
esttab step1 step2 step3 step4 step5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise.tex", ///
    replace se r2 label ///
    keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube) ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* LASSO


* (1) No controls
quietly lasso linear Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ///
        ma5aep veteran OLF tenure currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoControls
lassoknots


tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_noctrl.csv", replace
restore





* (2) “controls – no occ or ind”
quietly lasso linear Gamma ///
        (i.(state year race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOccNoInd
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_nooccind.csv", replace
restore





* (3) “controls – no occ”
quietly lasso linear Gamma ///
        (i.(state year race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOcc
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_noocc.csv", replace
restore




* (4) “controls – no ind”
quietly lasso linear Gamma ///
        (i.(state year occ race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoInd
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_noind.csv", replace
restore




* (5) “All controls”
quietly lasso linear Gamma ///
        (i.(state year occ race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_AllControls
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_all.csv", replace
restore






* LASSO across occ and ind

* occ
quietly lasso linear Gamma i.(occ), selection(bic) rseed(12345)
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_occ.csv", replace
restore




* ind
quietly lasso linear Gamma i.(twoind), selection(bic) rseed(12345)
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_ind.csv", replace
restore









* Alpha Analysis





* Descriptive plots

twoway (scatter Alpha currentage), title("Distribution of Age and Alpha") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_alphaP_WEIGHTED.png", replace


histogram Alpha, title("Distribution of Alpha") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_alphaP_WEIGHTED.png", replace



* Calculate and display the standard deviation of alphaP_WEIGHTED
summarize Alpha
display "The standard deviation of alphaP_WEIGHTED is: " r(sd)

* OLS

eststo clear

* No controls
eststo m1: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5

* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_regressions.tex", ///
        replace se r2 label ///
        keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube) ///
        stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
                  labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
                  fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))



* Stepwise regression

eststo clear

* No controls - capture output
tempfile stepwise_log1_alpha
log using `stepwise_log1_alpha', text replace
eststo step1: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube 
log close

* Extract removal order from log
preserve
import delimited using `stepwise_log1_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise_removal_noctrl.csv", replace
restore

estadd local state_fe "No": step1
estadd local year_fe  "No": step1
estadd local race_fe  "No": step1
estadd local cohort_fe "No": step1
estadd local occ_fe   "No": step1
estadd local ind_fe   "No": step1

* controls - no occ or ind - capture output
tempfile stepwise_log2_alpha
log using `stepwise_log2_alpha', text replace
eststo step2: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log2_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise_removal_nooccind.csv", replace
restore

estadd local state_fe "Yes": step2
estadd local year_fe  "Yes": step2
estadd local race_fe  "Yes": step2
estadd local cohort_fe "Yes": step2
estadd local occ_fe   "No": step2
estadd local ind_fe   "No": step2

* controls - no occ - capture output
tempfile stepwise_log3_alpha
log using `stepwise_log3_alpha', text replace
eststo step3: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log3_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise_removal_noocc.csv", replace
restore

estadd local state_fe "Yes": step3
estadd local year_fe  "Yes": step3
estadd local race_fe  "Yes": step3
estadd local cohort_fe "Yes": step3
estadd local occ_fe   "No": step3
estadd local ind_fe   "Yes": step3

* controls - no ind - capture output
tempfile stepwise_log4_alpha
log using `stepwise_log4_alpha', text replace
eststo step4: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log4_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise_removal_noind.csv", replace
restore

estadd local state_fe "Yes": step4
estadd local year_fe  "Yes": step4
estadd local race_fe  "Yes": step4
estadd local cohort_fe "Yes": step4
estadd local occ_fe   "Yes": step4
estadd local ind_fe   "No": step4

* All controls - capture output
tempfile stepwise_log5_alpha
log using `stepwise_log5_alpha', text replace
eststo step5: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log5_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise_removal_allctrl.csv", replace
restore

estadd local state_fe "Yes": step5
estadd local year_fe  "Yes": step5
estadd local race_fe  "Yes": step5
estadd local cohort_fe "Yes": step5
estadd local occ_fe   "Yes": step5
estadd local ind_fe   "Yes": step5

* Export stepwise results to LaTeX
esttab step1 step2 step3 step4 step5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise.tex", ///
    replace se r2 label ///
    keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure currentage currentagesq currentagecube) ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))






* LASSO


* (1) No controls
quietly lasso linear Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ///
        ma5aep veteran OLF tenure currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoControls
lassoknots


tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_noctrl.csv", replace
restore





* (2) “controls – no occ or ind”
quietly lasso linear Alpha ///
        (i.(state year race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOccNoInd
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_nooccind.csv", replace
restore





* (3) “controls – no occ”
quietly lasso linear Alpha ///
        (i.(state year race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOcc
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_noocc.csv", replace
restore




* (4) “controls – no ind”
quietly lasso linear Alpha ///
        (i.(state year occ race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoInd
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_noind.csv", replace
restore




* (5) “All controls”
quietly lasso linear Alpha ///
        (i.(state year occ race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_AllControls
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_all.csv", replace
restore






* LASSO across occ and ind

* occ
quietly lasso linear Alpha i.(occ), selection(bic) rseed(12345)
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_occ.csv", replace
restore




* ind
quietly lasso linear Alpha i.(twoind), selection(bic) rseed(12345)
lassoknots

tempfile lk
capture log close _all
log using `lk', text replace
lassoknots
log close

preserve
import delimited using `lk', delim("|") varnames(1) encoding("utf-8") clear
keep if inlist(strtrim(v3),"U") | strpos(v3,"A ") | strpos(v3,"R ")
gen action = substr(strtrim(v3),1,1)          // A/R/U
gen vars = strtrim(substr(strtrim(v3),2,.))   // names after A/R/U
drop if vars==""                              // keep rows with names
gen step = _n
order step action vars
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_ind.csv", replace
restore





