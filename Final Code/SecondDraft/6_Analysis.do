
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
gen fhwageSQ = fhwage0_P0^2




* Descriptive plots

twoway (scatter gammaP_WEIGHTED currentage), title("Distribution of Age and Gamma") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_gammaP_WEIGHTED.png", replace


histogram gammaP_WEIGHTED, title("Distribution of Gamma") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_gammaP_WEIGHTED.png", replace


log using "MainAnalysis.smcl", name(log1) replace

log using "MainAnalysis.txt", text name(log2) replace


* Calculate and display the standard deviation of gammaP_WEIGHTED
summarize gammaP_WEIGHTED
display "The standard deviation of gammaP_WEIGHTED is: " r(sd)


* OLS


eststo clear

* No controls
eststo m1: regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5

* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma_regressions.tex", ///
    replace se r2 label ///
    keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube) ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* Stepwise regression

* No controls
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube 

* controls - no occ or ind
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)

* controls - no occ
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)

* controls - no ind
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)

* All controls
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)




* LASSO


* (1) No controls
quietly lasso linear gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow ///
        fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/lassoknots_noctrl.csv", replace
restore




/* 

* Alternative method to get lassoknots without logging and importing

matrix knots = r(table)          // 15 x 4
matrix colnames knots = id lambda n_nonzero r2

preserve
clear
svmat double knots, names(col)   // creates id lambda n_nonzero r2
rename id step
order step lambda n_nonzero r2
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/lassoknots_noctrl.csv", replace
restore


*/



* (2) “controls – no occ or ind”
quietly lasso linear gammaP_WEIGHTED ///
        (i.(state year race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOccNoInd
lassoknots

* (3) “controls – no occ”
quietly lasso linear gammaP_WEIGHTED ///
        (i.(state year race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOcc
lassoknots

* (4) “controls – no ind”
quietly lasso linear gammaP_WEIGHTED ///
        (i.(state year occ race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoInd
lassoknots

* (5) “All controls”
quietly lasso linear gammaP_WEIGHTED ///
        (i.(state year occ race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_AllControls
lassoknots



* LASSO across occ and ind

* occ
quietly lasso linear gammaP_WEIGHTED i.(occ), selection(bic) rseed(12345)
lassoknots


* ind
quietly lasso linear gammaP_WEIGHTED i.(twoind), selection(bic) rseed(12345)
lassoknots











* Alpha Analysis





* Descriptive plots

twoway (scatter alphaP_WEIGHTED currentage), title("Distribution of Age and Alpha") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_alphaP_WEIGHTED.png", replace


histogram alphaP_WEIGHTED, title("Distribution of Alpha") xlabel(, grid) ylabel(, grid)
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_alphaP_WEIGHTED.png", replace



* Calculate and display the standard deviation of alphaP_WEIGHTED
summarize alphaP_WEIGHTED
display "The standard deviation of alphaP_WEIGHTED is: " r(sd)

* OLS

eststo clear

* No controls
eststo m1: regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5

* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha_regressions.tex", ///
        replace se r2 label ///
        keep(EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube) ///
        stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
                  labels("State FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
                  fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g))



* Stepwise regression

* No controls
stepwise, pr(.05): regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube 

* controls - no occ or ind
stepwise, pr(.05): regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)

* controls - no occ
stepwise, pr(.05): regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)

* controls - no ind
stepwise, pr(.05): regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)

* All controls
stepwise, pr(.05): regress alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)



* LASSO


* (1) No controls
quietly lasso linear alphaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow ///
        fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoControls
lassoknots

* (2) “controls – no occ or ind”
quietly lasso linear alphaP_WEIGHTED ///
        (i.(state year race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOccNoInd
lassoknots

* (3) “controls – no occ”
quietly lasso linear alphaP_WEIGHTED ///
        (i.(state year race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoOcc
lassoknots

* (4) “controls – no ind”
quietly lasso linear alphaP_WEIGHTED ///
        (i.(state year occ race cohort)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_NoInd
lassoknots

* (5) “All controls”
quietly lasso linear alphaP_WEIGHTED ///
        (i.(state year occ race cohort twoind)) ///
        EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure ///
        currentage currentagesq currentagecube, ///
        selection(bic) rseed(12345)
estimates store Lasso_AllControls
lassoknots



* LASSO across occ and ind

* occ
quietly lasso linear alphaP_WEIGHTED i.(occ), selection(bic) rseed(12345)
lassoknots


* ind
quietly lasso linear alphaP_WEIGHTED i.(twoind), selection(bic) rseed(12345)
lassoknots



log close log1
log close log2
