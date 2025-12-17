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
ssc install listtex

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
* ADD RACE???






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
label var veteran "Veteran"



rename (gammaP_WEIGHTED alphaP_WEIGHTED) (Gamma Alpha)





* Descriptive plots

twoway (scatter Gamma currentage), title("Distribution of Age and Gamma") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_gammaP_WEIGHTED.png", replace


histogram Gamma, title("Distribution of Gamma") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_gammaP_WEIGHTED.png", replace



/*

log using "MainAnalysis.smcl", name(log1) replace

log using "MainAnalysis.txt", text name(log2) replace

*/


* Calculate and display the standard deviation of gammaP_WEIGHTED
summarize Gamma
display "The standard deviation of gammaP_WEIGHTED is: " r(sd)


* OLS


eststo clear

* No controls
eststo m1: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5

* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_regressions.tex", ///
    replace se r2 label ///
    keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube) ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* Stepwise regression

eststo clear

* No controls - capture output
tempfile stepwise_log1
log using `stepwise_log1', text replace
eststo step1: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube 
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
estadd local state_selected " ": step1
estadd local year_selected  " ": step1
estadd local race_selected  " ": step1
estadd local cohort_selected " ": step1
estadd local occ_selected   " ": step1
estadd local ind_selected   " ": step1

* controls - no occ or ind - capture output
tempfile stepwise_log2
log using `stepwise_log2', text replace
eststo step2: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step2
}
else {
    estadd local state_selected "": step2
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step2
}
else {
    estadd local year_selected "": step2
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step2
}
else {
    estadd local race_selected "": step2
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step2
}
else {
    estadd local cohort_selected "": step2
}
estadd local occ_selected "": step2
estadd local ind_selected "": step2

* controls - no occ - capture output
tempfile stepwise_log3
log using `stepwise_log3', text replace
eststo step3: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local ind_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
    if regexm("`var'", "^twoind_dum") {
        local ind_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step3
}
else {
    estadd local state_selected "": step3
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step3
}
else {
    estadd local year_selected "": step3
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step3
}
else {
    estadd local race_selected "": step3
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step3
}
else {
    estadd local cohort_selected "": step3
}
estadd local occ_selected "": step3
if "`ind_selected'" == "Yes" {
    estadd local ind_selected "\checkmark": step3
}
else {
    estadd local ind_selected "": step3
}

* controls - no ind - capture output
tempfile stepwise_log4
log using `stepwise_log4', text replace
eststo step4: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
    if regexm("`var'", "^occ_dum") {
        local occ_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step4
}
else {
    estadd local state_selected "": step4
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step4
}
else {
    estadd local year_selected "": step4
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step4
}
else {
    estadd local race_selected "": step4
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step4
}
else {
    estadd local cohort_selected "": step4
}
if "`occ_selected'" == "Yes" {
    estadd local occ_selected "\checkmark": step4
}
else {
    estadd local occ_selected "": step4
}
estadd local ind_selected "": step4

* All controls - capture output
tempfile stepwise_log5
log using `stepwise_log5', text replace
eststo step5: stepwise, pr(.05): regress Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
local ind_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
    if regexm("`var'", "^occ_dum") {
        local occ_selected "Yes"
    }
    if regexm("`var'", "^twoind_dum") {
        local ind_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step5
}
else {
    estadd local state_selected "": step5
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step5
}
else {
    estadd local year_selected "": step5
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step5
}
else {
    estadd local race_selected "": step5
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step5
}
else {
    estadd local cohort_selected "": step5
}
if "`occ_selected'" == "Yes" {
    estadd local occ_selected "\checkmark": step5
}
else {
    estadd local occ_selected "": step5
}
if "`ind_selected'" == "Yes" {
    estadd local ind_selected "\checkmark": step5
}
else {
    estadd local ind_selected "": step5
}

* Export stepwise results to LaTeX
* Note: Only include variables that are retained in at least some models
* EDU3 may be dropped during stepwise regression in some/all models
esttab step1 step2 step3 step4 step5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_stepwise.tex", ///
    replace se r2 label ///
    drop(*_dum*) ///
    stats(state_selected year_selected race_selected cohort_selected occ_selected ind_selected state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "\midrule State FE Available" "Year FE Available" "Race FE Available" "Cohort FE Available" "Occupation FE Available" "Industry FE Available" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* LASSO


* (1) No controls
quietly lasso linear Gamma EDU1 EDU2 EDU3 PrRecess rGDPgrow ///
        ma5aep OLF tenure currentage currentagesq currentagecube, ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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









* Create LASSO selection order table
* Combine all LASSO knots files and create a table showing selection order

preserve
clear

* Define the main variables of interest (not FE dummies)
local main_vars "EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube"

* Create empty dataset with variables
local nvars : word count `main_vars'
set obs `nvars'
gen varname = ""
local i = 1
foreach var of local main_vars {
    replace varname = "`var'" in `i'
    local ++i
}

* Initialize columns for each specification
gen noctrl = .
gen nooccind = .
gen noocc = .
gen noind = .
gen allctrl = .

* Load each LASSO knots file and extract selection order for main variables
foreach spec in noctrl nooccind noocc noind all {
    tempvar order_`spec'
    gen `order_`spec'' = .
    
    tempfile current_data
    save `current_data', replace
    
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots_`spec'.csv", clear
    
    * Keep only additions (A) as these show when variables entered
    keep if action == "A"
    
    * Create a counter for order
    gen order = _n
    
    * Split vars field when multiple variables are added in same step
    * Expand the dataset to have one row per variable
    split vars, gen(var_)
    
    * Count how many variables in each row
    gen nvars = 0
    foreach v of varlist var_* {
        replace nvars = nvars + 1 if `v' != ""
    }
    
    * Expand so each variable gets its own row with same order
    expand nvars
    bysort order: gen seq = _n
    
    * Create single variable name column
    gen varname = ""
    foreach i of numlist 1/20 {
        capture confirm variable var_`i'
        if _rc == 0 {
            replace varname = var_`i' if seq == `i' & var_`i' != ""
        }
    }
    
    * Keep only main variables (exclude FE dummies)
    gen is_main = 0
    foreach var of local main_vars {
        replace is_main = 1 if varname == "`var'"
    }
    keep if is_main == 1
    
    * Keep only the first occurrence of each variable (first time it was added)
    bysort varname (order): keep if _n == 1
    
    keep varname order
    
    tempfile lasso_`spec'
    save `lasso_`spec'', replace
    
    use `current_data', clear
    merge 1:1 varname using `lasso_`spec'', nogenerate
    replace `spec' = order if order != .
    drop order
}

* Add variable labels
label var varname "Variable"
label var noctrl "No Controls"
label var nooccind "No Occ/Ind"
label var noocc "No Occ"
label var noind "No Ind"
label var allctrl "All Controls"

* Add FE availability indicators as locals for the table footer
local state_fe_noctrl "No"
local year_fe_noctrl "No"
local race_fe_noctrl "No"
local cohort_fe_noctrl "No"
local occ_fe_noctrl "No"
local ind_fe_noctrl "No"

local state_fe_nooccind "Yes"
local year_fe_nooccind "Yes"
local race_fe_nooccind "Yes"
local cohort_fe_nooccind "Yes"
local occ_fe_nooccind "No"
local ind_fe_nooccind "No"

local state_fe_noocc "Yes"
local year_fe_noocc "Yes"
local race_fe_noocc "Yes"
local cohort_fe_noocc "Yes"
local occ_fe_noocc "No"
local ind_fe_noocc "Yes"

local state_fe_noind "Yes"
local year_fe_noind "Yes"
local race_fe_noind "Yes"
local cohort_fe_noind "Yes"
local occ_fe_noind "Yes"
local ind_fe_noind "No"

local state_fe_allctrl "Yes"
local year_fe_allctrl "Yes"
local race_fe_allctrl "Yes"
local cohort_fe_allctrl "Yes"
local occ_fe_allctrl "Yes"
local ind_fe_allctrl "Yes"

* Export to LaTeX
listtex varname noctrl nooccind noocc noind allctrl using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_lasso_selection.tex", ///
    replace ///
    head("\begin{tabular}{lccccc}" ///
         "\hline\hline" ///
         "  & No Controls & No Occ/Ind & No Occ & No Ind & All Controls \\" ///
         "\hline") ///
    foot("\hline" ///
         "\multicolumn{6}{l}{} \\" ///
         "State FE & `state_fe_noctrl' & `state_fe_nooccind' & `state_fe_noocc' & `state_fe_noind' & `state_fe_allctrl' \\" ///
         "Year FE & `year_fe_noctrl' & `year_fe_nooccind' & `year_fe_noocc' & `year_fe_noind' & `year_fe_allctrl' \\" ///
         "Race FE & `race_fe_noctrl' & `race_fe_nooccind' & `race_fe_noocc' & `race_fe_noind' & `race_fe_allctrl' \\" ///
         "Cohort FE & `cohort_fe_noctrl' & `cohort_fe_nooccind' & `cohort_fe_noocc' & `cohort_fe_noind' & `cohort_fe_allctrl' \\" ///
         "Occupation FE & `occ_fe_noctrl' & `occ_fe_nooccind' & `occ_fe_noocc' & `occ_fe_noind' & `occ_fe_allctrl' \\" ///
         "Industry FE & `ind_fe_noctrl' & `ind_fe_nooccind' & `ind_fe_noocc' & `ind_fe_noind' & `ind_fe_allctrl' \\" ///
         "\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)

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
eststo m1: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5

* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_regressions.tex", ///
        replace se r2 label ///
        keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube) ///
        stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
                  labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
                  fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))



* Stepwise regression

eststo clear

* No controls - capture output
tempfile stepwise_log1_alpha
log using `stepwise_log1_alpha', text replace
eststo step1: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube 
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
estadd local state_selected " ": step1
estadd local year_selected  " ": step1
estadd local race_selected  " ": step1
estadd local cohort_selected " ": step1
estadd local occ_selected   " ": step1
estadd local ind_selected   " ": step1

* controls - no occ or ind - capture output
tempfile stepwise_log2_alpha
log using `stepwise_log2_alpha', text replace
eststo step2: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step2
}
else {
    estadd local state_selected "": step2
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step2
}
else {
    estadd local year_selected "": step2
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step2
}
else {
    estadd local race_selected "": step2
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step2
}
else {
    estadd local cohort_selected "": step2
}
estadd local occ_selected "": step2
estadd local ind_selected "": step2

* controls - no occ - capture output
tempfile stepwise_log3_alpha
log using `stepwise_log3_alpha', text replace
eststo step3: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local ind_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
    if regexm("`var'", "^twoind_dum") {
        local ind_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step3
}
else {
    estadd local state_selected "": step3
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step3
}
else {
    estadd local year_selected "": step3
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step3
}
else {
    estadd local race_selected "": step3
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step3
}
else {
    estadd local cohort_selected "": step3
}
estadd local occ_selected "": step3
if "`ind_selected'" == "Yes" {
    estadd local ind_selected "\checkmark": step3
}
else {
    estadd local ind_selected "": step3
}

* controls - no ind - capture output
tempfile stepwise_log4_alpha
log using `stepwise_log4_alpha', text replace
eststo step4: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
    if regexm("`var'", "^occ_dum") {
        local occ_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step4
}
else {
    estadd local state_selected "": step4
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step4
}
else {
    estadd local year_selected "": step4
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step4
}
else {
    estadd local race_selected "": step4
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step4
}
else {
    estadd local cohort_selected "": step4
}
if "`occ_selected'" == "Yes" {
    estadd local occ_selected "\checkmark": step4
}
else {
    estadd local occ_selected "": step4
}
estadd local ind_selected "": step4

* All controls - capture output
tempfile stepwise_log5_alpha
log using `stepwise_log5_alpha', text replace
eststo step5: stepwise, pr(.05): regress Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
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

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
local ind_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^state_dum") {
        local state_selected "Yes"
    }
    if regexm("`var'", "^year_dum") {
        local year_selected "Yes"
    }
    if regexm("`var'", "^race_dum") {
        local race_selected "Yes"
    }
    if regexm("`var'", "^cohort_dum") {
        local cohort_selected "Yes"
    }
    if regexm("`var'", "^occ_dum") {
        local occ_selected "Yes"
    }
    if regexm("`var'", "^twoind_dum") {
        local ind_selected "Yes"
    }
}
if "`state_selected'" == "Yes" {
    estadd local state_selected "\checkmark": step5
}
else {
    estadd local state_selected "": step5
}
if "`year_selected'" == "Yes" {
    estadd local year_selected "\checkmark": step5
}
else {
    estadd local year_selected "": step5
}
if "`race_selected'" == "Yes" {
    estadd local race_selected "\checkmark": step5
}
else {
    estadd local race_selected "": step5
}
if "`cohort_selected'" == "Yes" {
    estadd local cohort_selected "\checkmark": step5
}
else {
    estadd local cohort_selected "": step5
}
if "`occ_selected'" == "Yes" {
    estadd local occ_selected "\checkmark": step5
}
else {
    estadd local occ_selected "": step5
}
if "`ind_selected'" == "Yes" {
    estadd local ind_selected "\checkmark": step5
}
else {
    estadd local ind_selected "": step5
}

* Export stepwise results to LaTeX
esttab step1 step2 step3 step4 step5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_stepwise.tex", ///
    replace se r2 label ///
    drop(*_dum*) ///
    stats(state_selected year_selected race_selected cohort_selected occ_selected ind_selected state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "\midrule State FE Available" "Year FE Available" "Race FE Available" "Cohort FE Available" "Occupation FE Available" "Industry FE Available" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9.3f %9.0g))






* LASSO


* (1) No controls
quietly lasso linear Alpha EDU1 EDU2 EDU3 PrRecess rGDPgrow ///
        ma5aep OLF tenure currentage currentagesq currentagecube, ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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
        EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure ///
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








preserve
clear

* Define the main variables of interest (not FE dummies)
local main_vars "EDU1 EDU2 EDU3 PrRecess rGDPgrow ma5aep OLF tenure currentage currentagesq currentagecube"

* Create empty dataset with variables
local nvars : word count `main_vars'
set obs `nvars'
gen varname = ""
local i = 1
foreach var of local main_vars {
    replace varname = "`var'" in `i'
    local ++i
}

* Initialize columns for each specification
gen noctrl = .
gen nooccind = .
gen noocc = .
gen noind = .
gen allctrl = .

* Load each LASSO knots file and extract selection order for main variables
foreach spec in noctrl nooccind noocc noind all {
    tempvar order_`spec'
    gen `order_`spec'' = .
    
    tempfile current_data
    save `current_data', replace
    
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots_`spec'.csv", clear
    
    * Keep only additions (A) as these show when variables entered
    keep if action == "A"
    
    * Create a counter for order
    gen order = _n
    
    * Split vars field when multiple variables are added in same step
    * Expand the dataset to have one row per variable
    split vars, gen(var_)
    
    * Count how many variables in each row
    gen nvars = 0
    foreach v of varlist var_* {
        replace nvars = nvars + 1 if `v' != ""
    }
    
    * Expand so each variable gets its own row with same order
    expand nvars
    bysort order: gen seq = _n
    
    * Create single variable name column
    gen varname = ""
    foreach i of numlist 1/20 {
        capture confirm variable var_`i'
        if _rc == 0 {
            replace varname = var_`i' if seq == `i' & var_`i' != ""
        }
    }
    
    * Keep only main variables (exclude FE dummies)
    gen is_main = 0
    foreach var of local main_vars {
        replace is_main = 1 if varname == "`var'"
    }
    keep if is_main == 1
    
    * Keep only the first occurrence of each variable (first time it was added)
    bysort varname (order): keep if _n == 1
    
    keep varname order
    
    tempfile lasso_`spec'
    save `lasso_`spec'', replace
    
    use `current_data', clear
    merge 1:1 varname using `lasso_`spec'', nogenerate
    replace `spec' = order if order != .
    drop order
}

* Add variable labels
label var varname "Variable"
label var noctrl "No Controls"
label var nooccind "No Occ/Ind"
label var noocc "No Occ"
label var noind "No Ind"
label var allctrl "All Controls"

* Add FE availability indicators as locals for the table footer
local state_fe_noctrl "No"
local year_fe_noctrl "No"
local race_fe_noctrl "No"
local cohort_fe_noctrl "No"
local occ_fe_noctrl "No"
local ind_fe_noctrl "No"

local state_fe_nooccind "Yes"
local year_fe_nooccind "Yes"
local race_fe_nooccind "Yes"
local cohort_fe_nooccind "Yes"
local occ_fe_nooccind "No"
local ind_fe_nooccind "No"

local state_fe_noocc "Yes"
local year_fe_noocc "Yes"
local race_fe_noocc "Yes"
local cohort_fe_noocc "Yes"
local occ_fe_noocc "No"
local ind_fe_noocc "Yes"

local state_fe_noind "Yes"
local year_fe_noind "Yes"
local race_fe_noind "Yes"
local cohort_fe_noind "Yes"
local occ_fe_noind "Yes"
local ind_fe_noind "No"

local state_fe_allctrl "Yes"
local year_fe_allctrl "Yes"
local race_fe_allctrl "Yes"
local cohort_fe_allctrl "Yes"
local occ_fe_allctrl "Yes"
local ind_fe_allctrl "Yes"

* Export to LaTeX
listtex varname noctrl nooccind noocc noind allctrl using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_lasso_selection.tex", ///
    replace ///
    head("\begin{tabular}{lccccc}" ///
         "\hline\hline" ///
         "  & No Controls & No Occ/Ind & No Occ & No Ind & All Controls \\" ///
         "\hline") ///
    foot("\hline" ///
         "\multicolumn{6}{l}{} \\" ///
         "State FE & `state_fe_noctrl' & `state_fe_nooccind' & `state_fe_noocc' & `state_fe_noind' & `state_fe_allctrl' \\" ///
         "Year FE & `year_fe_noctrl' & `year_fe_nooccind' & `year_fe_noocc' & `year_fe_noind' & `year_fe_allctrl' \\" ///
         "Race FE & `race_fe_noctrl' & `race_fe_nooccind' & `race_fe_noocc' & `race_fe_noind' & `race_fe_allctrl' \\" ///
         "Cohort FE & `cohort_fe_noctrl' & `cohort_fe_nooccind' & `cohort_fe_noocc' & `cohort_fe_noind' & `cohort_fe_allctrl' \\" ///
         "Occupation FE & `occ_fe_noctrl' & `occ_fe_nooccind' & `occ_fe_noocc' & `occ_fe_noind' & `occ_fe_allctrl' \\" ///
         "Industry FE & `ind_fe_noctrl' & `ind_fe_nooccind' & `ind_fe_noocc' & `ind_fe_noind' & `ind_fe_allctrl' \\" ///
         "\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)

restore






