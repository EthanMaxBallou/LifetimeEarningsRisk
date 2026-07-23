



/*

ssc install estout
ssc install listtex
ssc install coefplot


*/



clear all

* ===========================================================================
* Earnings-measure switch. The master loop sets global MEAS (fhwage|fearn);
* defaults to fhwage when this file is run on its own. SFX selects the
* consolidated DV (gammaP_WEIGHTED vs gammaP_WEIGHTED_fearn) and is appended to
* every output filename so the two measures don't overwrite each other.
* ===========================================================================
if "$MEAS"=="" global MEAS "fhwage"
global SFX ""
if "$MEAS"=="fearn" global SFX "_fearn"

use "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma_withDemographics.dta", replace


label var gammaP_WEIGHTED "Gamma (${MEAS})"
label var alphaP_WEIGHTED "Alpha (${MEAS})"

label var gammaP_WEIGHTED_fearn "Gamma (${MEAS})"
label var alphaP_WEIGHTED_fearn "Alpha (${MEAS})"






* Old method
* ADD RACE???


tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)
tabulate cohort, generate(cohort_dum)
tabulate twoind, generate(twoind_dum)



* Age and tenure bin dummies for the stepwise regressions. Age, education,
* and tenure bins are treated as FE control sets, so the dummies are named
* *_dum like the other FE dummies -- the stepwise esttab drop(*_dum*) then
* removes them from the coefficient body and they report as Yes/checkmark rows.
* (agebin_dum4 = age 46-53 and ten_dum1 = tenure 0-1 are the omitted references.)
tabulate agebin, generate(agebin_dum)
tabulate tenurebin, generate(ten_dum)





rename (gammaP_WEIGHTED${SFX} alphaP_WEIGHTED${SFX}) (Gamma Alpha)






* Descriptive plots

twoway (scatter Gamma currentage), title("Distribution of Age and Gamma") xlabel(, grid) ylabel(, grid) ytitle("Gamma") xtitle("Age")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_gammaP_WEIGHTED${SFX}.png", replace


histogram Gamma, title("Distribution of Gamma") xlabel(, grid) ylabel(, grid) xtitle("Gamma")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_gammaP_WEIGHTED${SFX}.png", replace





twoway (scatter Alpha currentage), title("Distribution of Age and Alpha") xlabel(, grid) ylabel(, grid) ytitle("Alpha") xtitle("Age")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/scatter_age_alphaP_WEIGHTED${SFX}.png", replace


histogram Alpha, title("Distribution of Alpha") xlabel(, grid) ylabel(, grid) xtitle("Alpha")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/histogram_alphaP_WEIGHTED${SFX}.png", replace







* Gamma Analysis





replace EDU1 = EDU1 / 100
replace EDU2 = EDU2 / 100
replace EDU3 = EDU3 / 100
replace EDU4 = EDU4 / 100
replace currentage = currentage / 100
replace currentagesq = currentagesq / 100
replace currentagecube = currentagecube / 100
replace OLF = OLF / 100
replace PrRecess = PrRecess / 100
replace rGDPgrow = rGDPgrow / 100
replace ma5aep = ma5aep / 100




* Education dummy copies with FE-dummy naming for the stepwise regressions
* (created after the EDU scaling above so both sets are on the same scale)
gen edu_dum1 = EDU1
gen edu_dum2 = EDU2
gen edu_dum3 = EDU3
gen edu_dum4 = EDU4


* Generate squared terms for edyrs
gen edyrs_squared = edyrs^2
gen edyrs_cubed = edyrs^3

gen PRsquare = PrRecess^2
gen rGDPsquare = rGDPgrow^2






* CLEAN UP LABELS HERE

label var currentage "Age"
label var currentagesq "Age Squared"
label var currentagecube "Age Cubed"
label var tenure "Tenure"
label var OLF "Out of Labor Force"
label var veteran "Veteran"










* Create occupation-year interaction dummies
gen occ_year = occ * 10000 + year
tabulate occ_year, generate(occ_year_dum)





* F TESTING - GAMMA
* Test significance of fixed effects across different model specifications
* (Excludes no-controls model since we're testing control significance)

* Initialize matrices to store F-statistics and p-values for Gamma
* Rows: censdiv, year, race, cohort, occ, twoind, edu, agebin, tenurebin (9 control sets)
* Columns: m2 (no occ/ind), m3 (no occ), m4 (no ind), m5 (all controls)
matrix gamma_fstat = J(9, 4, .)
matrix gamma_pval = J(9, 4, .)
matrix rownames gamma_fstat = "Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE"
matrix colnames gamma_fstat = "No Occ/Ind" "No Occ" "No Ind" "All Controls"
matrix rownames gamma_pval = "Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE"
matrix colnames gamma_pval = "No Occ/Ind" "No Occ" "No Ind" "All Controls"

* Model 2: controls - no occ or ind
quietly regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort)
testparm i.censdiv
matrix gamma_fstat[1,1] = r(F)
matrix gamma_pval[1,1] = r(p)
testparm i.year
matrix gamma_fstat[2,1] = r(F)
matrix gamma_pval[2,1] = r(p)
testparm i.race
matrix gamma_fstat[3,1] = r(F)
matrix gamma_pval[3,1] = r(p)
testparm i.cohort
matrix gamma_fstat[4,1] = r(F)
matrix gamma_pval[4,1] = r(p)
* occ and ind not in this model
matrix gamma_fstat[5,1] = .
matrix gamma_pval[5,1] = .
matrix gamma_fstat[6,1] = .
matrix gamma_pval[6,1] = .
testparm EDU1 EDU2 EDU3 EDU4
matrix gamma_fstat[7,1] = r(F)
matrix gamma_pval[7,1] = r(p)
testparm i.agebin
matrix gamma_fstat[8,1] = r(F)
matrix gamma_pval[8,1] = r(p)
testparm i.tenurebin
matrix gamma_fstat[9,1] = r(F)
matrix gamma_pval[9,1] = r(p)

* Model 3: controls - no occ
quietly regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort twoind)
testparm i.censdiv
matrix gamma_fstat[1,2] = r(F)
matrix gamma_pval[1,2] = r(p)
testparm i.year
matrix gamma_fstat[2,2] = r(F)
matrix gamma_pval[2,2] = r(p)
testparm i.race
matrix gamma_fstat[3,2] = r(F)
matrix gamma_pval[3,2] = r(p)
testparm i.cohort
matrix gamma_fstat[4,2] = r(F)
matrix gamma_pval[4,2] = r(p)
* occ not in this model
matrix gamma_fstat[5,2] = .
matrix gamma_pval[5,2] = .
testparm i.twoind
matrix gamma_fstat[6,2] = r(F)
matrix gamma_pval[6,2] = r(p)
testparm EDU1 EDU2 EDU3 EDU4
matrix gamma_fstat[7,2] = r(F)
matrix gamma_pval[7,2] = r(p)
testparm i.agebin
matrix gamma_fstat[8,2] = r(F)
matrix gamma_pval[8,2] = r(p)
testparm i.tenurebin
matrix gamma_fstat[9,2] = r(F)
matrix gamma_pval[9,2] = r(p)

* Model 4: controls - no ind
quietly regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort)
testparm i.censdiv
matrix gamma_fstat[1,3] = r(F)
matrix gamma_pval[1,3] = r(p)
testparm i.year
matrix gamma_fstat[2,3] = r(F)
matrix gamma_pval[2,3] = r(p)
testparm i.race
matrix gamma_fstat[3,3] = r(F)
matrix gamma_pval[3,3] = r(p)
testparm i.cohort
matrix gamma_fstat[4,3] = r(F)
matrix gamma_pval[4,3] = r(p)
testparm i.occ
matrix gamma_fstat[5,3] = r(F)
matrix gamma_pval[5,3] = r(p)
* ind not in this model
matrix gamma_fstat[6,3] = .
matrix gamma_pval[6,3] = .
testparm EDU1 EDU2 EDU3 EDU4
matrix gamma_fstat[7,3] = r(F)
matrix gamma_pval[7,3] = r(p)
testparm i.agebin
matrix gamma_fstat[8,3] = r(F)
matrix gamma_pval[8,3] = r(p)
testparm i.tenurebin
matrix gamma_fstat[9,3] = r(F)
matrix gamma_pval[9,3] = r(p)

* Model 5: All controls
quietly regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort twoind)
testparm i.censdiv
matrix gamma_fstat[1,4] = r(F)
matrix gamma_pval[1,4] = r(p)
testparm i.year
matrix gamma_fstat[2,4] = r(F)
matrix gamma_pval[2,4] = r(p)
testparm i.race
matrix gamma_fstat[3,4] = r(F)
matrix gamma_pval[3,4] = r(p)
testparm i.cohort
matrix gamma_fstat[4,4] = r(F)
matrix gamma_pval[4,4] = r(p)
testparm i.occ
matrix gamma_fstat[5,4] = r(F)
matrix gamma_pval[5,4] = r(p)
testparm i.twoind
matrix gamma_fstat[6,4] = r(F)
matrix gamma_pval[6,4] = r(p)
testparm EDU1 EDU2 EDU3 EDU4
matrix gamma_fstat[7,4] = r(F)
matrix gamma_pval[7,4] = r(p)
testparm i.agebin
matrix gamma_fstat[8,4] = r(F)
matrix gamma_pval[8,4] = r(p)
testparm i.tenurebin
matrix gamma_fstat[9,4] = r(F)
matrix gamma_pval[9,4] = r(p)

* Display Gamma F-test results
display "Gamma F-Statistics:"
matrix list gamma_fstat, format(%9.3f)
display "Gamma P-Values:"
matrix list gamma_pval, format(%9.4f)

* Export Gamma F-test table to LaTeX
preserve
clear
set obs 9
gen fe_name = ""
replace fe_name = "Census Division FE" in 1
replace fe_name = "Year FE" in 2
replace fe_name = "Race FE" in 3
replace fe_name = "Cohort FE" in 4
replace fe_name = "Occupation FE" in 5
replace fe_name = "Industry FE" in 6
replace fe_name = "Education FE" in 7
replace fe_name = "Age Bin FE" in 8
replace fe_name = "Tenure FE" in 9

* Generate F-stat and p-value columns for each model
forvalues j = 1/4 {
    gen f_m`j' = .
    gen p_m`j' = .
    forvalues i = 1/9 {
        replace f_m`j' = gamma_fstat[`i',`j'] in `i'
        replace p_m`j' = gamma_pval[`i',`j'] in `i'
    }
    * Create formatted string combining F-stat and p-value with stars
    gen str40 col`j' = ""
    forvalues i = 1/9 {
        local fval = f_m`j'[`i']
        local pval = p_m`j'[`i']
        if `fval' == . {
            replace col`j' = "--" in `i'
        }
        else {
            local stars = ""
            if `pval' < 0.01 {
                local stars = "***"
            }
            else if `pval' < 0.05 {
                local stars = "**"
            }
            else if `pval' < 0.10 {
                local stars = "*"
            }
            local fval_fmt : display %9.2f `fval'
            local pval_fmt : display %9.4f `pval'
            replace col`j' = strtrim("`fval_fmt'`stars'") + " (" + strtrim("`pval_fmt'") + ")" in `i'
        }
    }
}

listtex fe_name col1 col2 col3 col4 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_ftest.tex", ///
    replace ///
    head("\begin{tabular}{lcccc}" ///
         "\hline\hline" ///
         " & No Occ/Ind & No Occ & No Ind & All Controls \\" ///
         " & (1) & (2) & (3) & (4) \\" ///
         "\hline") ///
    foot("\hline" ///
         "\multicolumn{5}{l}{\footnotesize Note: F-statistics reported with p-values in parentheses.} \\" ///
         "\multicolumn{5}{l}{\footnotesize * p$<$0.10, ** p$<$0.05, *** p$<$0.01} \\" ///
         "\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)
restore


* F TESTING - ALPHA
* Test significance of fixed effects across different model specifications
* (Excludes no-controls model since we're testing control significance)

* Initialize matrices to store F-statistics and p-values for Alpha
matrix alpha_fstat = J(9, 4, .)
matrix alpha_pval = J(9, 4, .)
matrix rownames alpha_fstat = "Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE"
matrix colnames alpha_fstat = "No Occ/Ind" "No Occ" "No Ind" "All Controls"
matrix rownames alpha_pval = "Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE"
matrix colnames alpha_pval = "No Occ/Ind" "No Occ" "No Ind" "All Controls"

* Model 2: controls - no occ or ind
quietly regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort)
testparm i.censdiv
matrix alpha_fstat[1,1] = r(F)
matrix alpha_pval[1,1] = r(p)
testparm i.year
matrix alpha_fstat[2,1] = r(F)
matrix alpha_pval[2,1] = r(p)
testparm i.race
matrix alpha_fstat[3,1] = r(F)
matrix alpha_pval[3,1] = r(p)
testparm i.cohort
matrix alpha_fstat[4,1] = r(F)
matrix alpha_pval[4,1] = r(p)
* occ and ind not in this model
matrix alpha_fstat[5,1] = .
matrix alpha_pval[5,1] = .
matrix alpha_fstat[6,1] = .
matrix alpha_pval[6,1] = .
testparm EDU1 EDU2 EDU3 EDU4
matrix alpha_fstat[7,1] = r(F)
matrix alpha_pval[7,1] = r(p)
testparm i.agebin
matrix alpha_fstat[8,1] = r(F)
matrix alpha_pval[8,1] = r(p)
testparm i.tenurebin
matrix alpha_fstat[9,1] = r(F)
matrix alpha_pval[9,1] = r(p)

* Model 3: controls - no occ
quietly regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort twoind)
testparm i.censdiv
matrix alpha_fstat[1,2] = r(F)
matrix alpha_pval[1,2] = r(p)
testparm i.year
matrix alpha_fstat[2,2] = r(F)
matrix alpha_pval[2,2] = r(p)
testparm i.race
matrix alpha_fstat[3,2] = r(F)
matrix alpha_pval[3,2] = r(p)
testparm i.cohort
matrix alpha_fstat[4,2] = r(F)
matrix alpha_pval[4,2] = r(p)
* occ not in this model
matrix alpha_fstat[5,2] = .
matrix alpha_pval[5,2] = .
testparm i.twoind
matrix alpha_fstat[6,2] = r(F)
matrix alpha_pval[6,2] = r(p)
testparm EDU1 EDU2 EDU3 EDU4
matrix alpha_fstat[7,2] = r(F)
matrix alpha_pval[7,2] = r(p)
testparm i.agebin
matrix alpha_fstat[8,2] = r(F)
matrix alpha_pval[8,2] = r(p)
testparm i.tenurebin
matrix alpha_fstat[9,2] = r(F)
matrix alpha_pval[9,2] = r(p)

* Model 4: controls - no ind
quietly regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort)
testparm i.censdiv
matrix alpha_fstat[1,3] = r(F)
matrix alpha_pval[1,3] = r(p)
testparm i.year
matrix alpha_fstat[2,3] = r(F)
matrix alpha_pval[2,3] = r(p)
testparm i.race
matrix alpha_fstat[3,3] = r(F)
matrix alpha_pval[3,3] = r(p)
testparm i.cohort
matrix alpha_fstat[4,3] = r(F)
matrix alpha_pval[4,3] = r(p)
testparm i.occ
matrix alpha_fstat[5,3] = r(F)
matrix alpha_pval[5,3] = r(p)
* ind not in this model
matrix alpha_fstat[6,3] = .
matrix alpha_pval[6,3] = .
testparm EDU1 EDU2 EDU3 EDU4
matrix alpha_fstat[7,3] = r(F)
matrix alpha_pval[7,3] = r(p)
testparm i.agebin
matrix alpha_fstat[8,3] = r(F)
matrix alpha_pval[8,3] = r(p)
testparm i.tenurebin
matrix alpha_fstat[9,3] = r(F)
matrix alpha_pval[9,3] = r(p)

* Model 5: All controls
quietly regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort twoind)
testparm i.censdiv
matrix alpha_fstat[1,4] = r(F)
matrix alpha_pval[1,4] = r(p)
testparm i.year
matrix alpha_fstat[2,4] = r(F)
matrix alpha_pval[2,4] = r(p)
testparm i.race
matrix alpha_fstat[3,4] = r(F)
matrix alpha_pval[3,4] = r(p)
testparm i.cohort
matrix alpha_fstat[4,4] = r(F)
matrix alpha_pval[4,4] = r(p)
testparm i.occ
matrix alpha_fstat[5,4] = r(F)
matrix alpha_pval[5,4] = r(p)
testparm i.twoind
matrix alpha_fstat[6,4] = r(F)
matrix alpha_pval[6,4] = r(p)
testparm EDU1 EDU2 EDU3 EDU4
matrix alpha_fstat[7,4] = r(F)
matrix alpha_pval[7,4] = r(p)
testparm i.agebin
matrix alpha_fstat[8,4] = r(F)
matrix alpha_pval[8,4] = r(p)
testparm i.tenurebin
matrix alpha_fstat[9,4] = r(F)
matrix alpha_pval[9,4] = r(p)

* Display Alpha F-test results
display "Alpha F-Statistics:"
matrix list alpha_fstat, format(%9.3f)
display "Alpha P-Values:"
matrix list alpha_pval, format(%9.4f)

* Export Alpha F-test table to LaTeX
preserve
clear
set obs 9
gen fe_name = ""
replace fe_name = "Census Division FE" in 1
replace fe_name = "Year FE" in 2
replace fe_name = "Race FE" in 3
replace fe_name = "Cohort FE" in 4
replace fe_name = "Occupation FE" in 5
replace fe_name = "Industry FE" in 6
replace fe_name = "Education FE" in 7
replace fe_name = "Age Bin FE" in 8
replace fe_name = "Tenure FE" in 9

* Generate F-stat and p-value columns for each model
forvalues j = 1/4 {
    gen f_m`j' = .
    gen p_m`j' = .
    forvalues i = 1/9 {
        replace f_m`j' = alpha_fstat[`i',`j'] in `i'
        replace p_m`j' = alpha_pval[`i',`j'] in `i'
    }
    * Create formatted string combining F-stat and p-value with stars
    gen str40 col`j' = ""
    forvalues i = 1/9 {
        local fval = f_m`j'[`i']
        local pval = p_m`j'[`i']
        if `fval' == . {
            replace col`j' = "--" in `i'
        }
        else {
            local stars = ""
            if `pval' < 0.01 {
                local stars = "***"
            }
            else if `pval' < 0.05 {
                local stars = "**"
            }
            else if `pval' < 0.10 {
                local stars = "*"
            }
            local fval_fmt : display %9.2f `fval'
            local pval_fmt : display %9.4f `pval'
            replace col`j' = strtrim("`fval_fmt'`stars'") + " (" + strtrim("`pval_fmt'") + ")" in `i'
        }
    }
}

listtex fe_name col1 col2 col3 col4 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_ftest.tex", ///
    replace ///
    head("\begin{tabular}{lcccc}" ///
         "\hline\hline" ///
         " & No Occ/Ind & No Occ & No Ind & All Controls \\" ///
         " & (1) & (2) & (3) & (4) \\" ///
         "\hline") ///
    foot("\hline" ///
         "\multicolumn{5}{l}{\footnotesize Note: F-statistics reported with p-values in parentheses.} \\" ///
         "\multicolumn{5}{l}{\footnotesize * p$<$0.10, ** p$<$0.05, *** p$<$0.01} \\" ///
         "\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)
restore






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
eststo m1: regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress Gamma EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5


* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_regressions.tex", ///
    replace se r2 label ///
    keep(EDU1 EDU2 EDU3 EDU4 1.agebin 2.agebin 3.agebin 5.agebin 6.agebin PrRecess ma5aep OLF 2.tenurebin 3.tenurebin) ///
    order(EDU1 EDU2 EDU3 EDU4 1.agebin 2.agebin 3.agebin 5.agebin 6.agebin PrRecess ma5aep OLF 2.tenurebin 3.tenurebin) ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g)) ///
    star(* 0.10 ** 0.05 *** 0.01)


* Year fixed effects plot - m5 only
* Extract the year FE coefficients into a dataset and plot on a true numeric
* year axis (coefplot's label-parsing does not handle i.year coefficient names).
preserve
    estimates restore m5
    matrix b = e(b)
    matrix V = e(V)
    local names : colnames b
    local K = colsof(b)
    clear
    set obs `K'
    gen str40 cname = ""
    gen coef = .
    gen se   = .
    forvalues j = 1/`K' {
        local nm : word `j' of `names'
        replace cname = "`nm'" in `j'
        replace coef = b[1,`j'] in `j'
        replace se   = sqrt(V[`j',`j']) in `j'
    }
    keep if regexm(cname, "\.year$")
    gen yr = real(regexs(1)) if regexm(cname, "^([0-9]+)")
    drop if missing(yr)
    sort yr
    gen lo = coef - 1.96*se
    gen hi = coef + 1.96*se
    twoway (rarea lo hi yr, color(gs13)) ///
           (connected coef yr, msymbol(o) msize(small) lcolor(navy) mcolor(navy)), ///
        title("Year Fixed Effects - Gamma") xtitle("Year") ytitle("Coefficient") ///
        xlabel(1970(10)2020) legend(off)
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_year_fe.pdf", replace
restore




* Stepwise regression

eststo clear

* No controls - capture output
tempfile stepwise_log1
log using `stepwise_log1', text replace
eststo step1: stepwise, pr(.05): regress Gamma PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) 
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_stepwise_removal_noctrl.csv", replace
restore

estadd local state_fe "No": step1
estadd local year_fe  "No": step1
estadd local race_fe  "No": step1
estadd local cohort_fe "No": step1
estadd local occ_fe   "No": step1
estadd local ind_fe   "No": step1
estadd local edu_fe   "Yes": step1
estadd local age_fe   "Yes": step1
estadd local ten_fe   "Yes": step1
estadd local state_selected " ": step1
estadd local year_selected  " ": step1
estadd local race_selected  " ": step1
estadd local cohort_selected " ": step1
estadd local occ_selected   " ": step1
estadd local ind_selected   " ": step1

* Check which of the edu/age/tenure bin sets were selected
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
    }
}
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step1
}
else {
    estadd local edu_selected "": step1
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step1
}
else {
    estadd local age_selected "": step1
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step1
}
else {
    estadd local ten_selected "": step1
}

* controls - no occ or ind - capture output
tempfile stepwise_log2
log using `stepwise_log2', text replace
eststo step2: stepwise, pr(.05): regress Gamma PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log2', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_stepwise_removal_nooccind.csv", replace
restore

estadd local state_fe "Yes": step2
estadd local year_fe  "Yes": step2
estadd local race_fe  "Yes": step2
estadd local cohort_fe "Yes": step2
estadd local occ_fe   "No": step2
estadd local ind_fe   "No": step2
estadd local edu_fe   "Yes": step2
estadd local age_fe   "Yes": step2
estadd local ten_fe   "Yes": step2

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step2
}
else {
    estadd local edu_selected "": step2
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step2
}
else {
    estadd local age_selected "": step2
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step2
}
else {
    estadd local ten_selected "": step2
}

* controls - no occ - capture output
tempfile stepwise_log3
log using `stepwise_log3', text replace
eststo step3: stepwise, pr(.05): regress Gamma PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log3', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_stepwise_removal_noocc.csv", replace
restore

estadd local state_fe "Yes": step3
estadd local year_fe  "Yes": step3
estadd local race_fe  "Yes": step3
estadd local cohort_fe "Yes": step3
estadd local occ_fe   "No": step3
estadd local ind_fe   "Yes": step3
estadd local edu_fe   "Yes": step3
estadd local age_fe   "Yes": step3
estadd local ten_fe   "Yes": step3

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local ind_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step3
}
else {
    estadd local edu_selected "": step3
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step3
}
else {
    estadd local age_selected "": step3
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step3
}
else {
    estadd local ten_selected "": step3
}

* controls - no ind - capture output
tempfile stepwise_log4
log using `stepwise_log4', text replace
eststo step4: stepwise, pr(.05): regress Gamma PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log4', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_stepwise_removal_noind.csv", replace
restore

estadd local state_fe "Yes": step4
estadd local year_fe  "Yes": step4
estadd local race_fe  "Yes": step4
estadd local cohort_fe "Yes": step4
estadd local occ_fe   "Yes": step4
estadd local ind_fe   "No": step4
estadd local edu_fe   "Yes": step4
estadd local age_fe   "Yes": step4
estadd local ten_fe   "Yes": step4

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step4
}
else {
    estadd local edu_selected "": step4
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step4
}
else {
    estadd local age_selected "": step4
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step4
}
else {
    estadd local ten_selected "": step4
}

* All controls - capture output
tempfile stepwise_log5
log using `stepwise_log5', text replace
eststo step5: stepwise, pr(.05): regress Gamma PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log5', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_stepwise_removal_allctrl.csv", replace
restore

estadd local state_fe "Yes": step5
estadd local year_fe  "Yes": step5
estadd local race_fe  "Yes": step5
estadd local cohort_fe "Yes": step5
estadd local occ_fe   "Yes": step5
estadd local ind_fe   "Yes": step5
estadd local edu_fe   "Yes": step5
estadd local age_fe   "Yes": step5
estadd local ten_fe   "Yes": step5

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
local ind_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step5
}
else {
    estadd local edu_selected "": step5
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step5
}
else {
    estadd local age_selected "": step5
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step5
}
else {
    estadd local ten_selected "": step5
}

* Export stepwise results to LaTeX
* Edu/age/tenure bin dummies are FE sets: dropped from the body via *_dum*
* and reported as checkmark (selected) + Available rows like the other FE
esttab step1 step2 step3 step4 step5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_stepwise.tex", ///
    replace se r2 label ///
    drop(*_dum*) ///
    stats(state_selected year_selected race_selected cohort_selected occ_selected ind_selected edu_selected age_selected ten_selected state_fe year_fe race_fe cohort_fe occ_fe ind_fe edu_fe age_fe ten_fe r2 N, ///
          labels("Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE" "\midrule Census Division FE Available" "Year FE Available" "Race FE Available" "Cohort FE Available" "Occupation FE Available" "Industry FE Available" "Education FE Available" "Age Bin FE Available" "Tenure FE Available" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* LASSO


* (1) No controls
quietly lasso linear Gamma ///
        (EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots${SFX}_noctrl.csv", replace
restore





* (2) “controls – no occ or ind”
quietly lasso linear Gamma ///
        (i.(censdiv year race cohort) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots${SFX}_nooccind.csv", replace
restore





* (3) “controls – no occ”
quietly lasso linear Gamma ///
        (i.(censdiv year race cohort twoind) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots${SFX}_noocc.csv", replace
restore




* (4) “controls – no ind”
quietly lasso linear Gamma ///
        (i.(censdiv year occ race cohort) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots${SFX}_noind.csv", replace
restore




* (5) “All controls”
quietly lasso linear Gamma ///
        (i.(censdiv year occ race cohort twoind) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots${SFX}_all.csv", replace
restore






* LASSO occ/ind models run externally in Python; SHAP CSVs imported below




* Create LASSO selection order table
* Combine all LASSO knots files and create a table showing selection order

preserve
clear

* Define the main variables of interest (not FE dummies)
local main_vars "PrRecess ma5aep OLF"

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
    
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Gammalassoknots${SFX}_`spec'.csv", clear
    
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
listtex varname noctrl nooccind noocc noind allctrl using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/gamma${SFX}_lasso_selection.tex", ///
    replace ///
    head("\begin{tabular}{lccccc}" ///
         "\hline\hline" ///
         "  & No Controls & No Occ/Ind & No Occ & No Ind & All Controls \\" ///
         "\hline") ///
    foot("\hline" ///
         "\multicolumn{6}{l}{} \\" ///
         "Census Division FE & `state_fe_noctrl' & `state_fe_nooccind' & `state_fe_noocc' & `state_fe_noind' & `state_fe_allctrl' \\" ///
         "Year FE & `year_fe_noctrl' & `year_fe_nooccind' & `year_fe_noocc' & `year_fe_noind' & `year_fe_allctrl' \\" ///
         "Race FE & `race_fe_noctrl' & `race_fe_nooccind' & `race_fe_noocc' & `race_fe_noind' & `race_fe_allctrl' \\" ///
         "Cohort FE & `cohort_fe_noctrl' & `cohort_fe_nooccind' & `cohort_fe_noocc' & `cohort_fe_noind' & `cohort_fe_allctrl' \\" ///
         "Occupation FE & `occ_fe_noctrl' & `occ_fe_nooccind' & `occ_fe_noocc' & `occ_fe_noind' & `occ_fe_allctrl' \\" ///
         "Industry FE & `ind_fe_noctrl' & `ind_fe_nooccind' & `ind_fe_noocc' & `ind_fe_noind' & `ind_fe_allctrl' \\" ///
         "Education FE & Yes & Yes & Yes & Yes & Yes \\" ///
         "Age Bin FE & Yes & Yes & Yes & Yes & Yes \\" ///
         "Tenure FE & Yes & Yes & Yes & Yes & Yes \\" ///
         "\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)

restore












* Alpha Analysis






* Calculate and display the standard deviation of alphaP_WEIGHTED
summarize Alpha
display "The standard deviation of alphaP_WEIGHTED is: " r(sd)

* OLS

eststo clear

* No controls
eststo m1: regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin
estadd local state_fe "No": m1
estadd local year_fe  "No": m1
estadd local race_fe  "No": m1
estadd local cohort_fe "No": m1
estadd local occ_fe   "No": m1
estadd local ind_fe   "No": m1

* controls - no occ or ind
eststo m2: regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort)
estadd local state_fe "Yes": m2
estadd local year_fe  "Yes": m2
estadd local race_fe  "Yes": m2
estadd local cohort_fe "Yes": m2
estadd local occ_fe   "No": m2
estadd local ind_fe   "No": m2

* controls - no occ
eststo m3: regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort twoind)
estadd local state_fe "Yes": m3
estadd local year_fe  "Yes": m3
estadd local race_fe  "Yes": m3
estadd local cohort_fe "Yes": m3
estadd local occ_fe   "No": m3
estadd local ind_fe   "Yes": m3

* controls - no ind
eststo m4: regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort)
estadd local state_fe "Yes": m4
estadd local year_fe  "Yes": m4
estadd local race_fe  "Yes": m4
estadd local cohort_fe "Yes": m4
estadd local occ_fe   "Yes": m4
estadd local ind_fe   "No": m4

* All controls
eststo m5: regress Alpha EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort twoind)
estadd local state_fe "Yes": m5
estadd local year_fe  "Yes": m5
estadd local race_fe  "Yes": m5
estadd local cohort_fe "Yes": m5
estadd local occ_fe   "Yes": m5
estadd local ind_fe   "Yes": m5


* Export to LaTeX
esttab m1 m2 m3 m4 m5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_regressions.tex", ///
        replace se r2 label ///
        keep(EDU1 EDU2 EDU3 EDU4 1.agebin 2.agebin 3.agebin 5.agebin 6.agebin PrRecess ma5aep OLF 2.tenurebin 3.tenurebin) ///
        order(EDU1 EDU2 EDU3 EDU4 1.agebin 2.agebin 3.agebin 5.agebin 6.agebin PrRecess ma5aep OLF 2.tenurebin 3.tenurebin) ///
        stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
                  labels("Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
                  fmt(%9s %9s %9s %9s %9s %9.3f %9.0g)) ///
        star(* 0.10 ** 0.05 *** 0.01)


* Year fixed effects plot - m5 only
* Extract the year FE coefficients into a dataset and plot on a true numeric
* year axis (coefplot's label-parsing does not handle i.year coefficient names).
preserve
    estimates restore m5
    matrix b = e(b)
    matrix V = e(V)
    local names : colnames b
    local K = colsof(b)
    clear
    set obs `K'
    gen str40 cname = ""
    gen coef = .
    gen se   = .
    forvalues j = 1/`K' {
        local nm : word `j' of `names'
        replace cname = "`nm'" in `j'
        replace coef = b[1,`j'] in `j'
        replace se   = sqrt(V[`j',`j']) in `j'
    }
    keep if regexm(cname, "\.year$")
    gen yr = real(regexs(1)) if regexm(cname, "^([0-9]+)")
    drop if missing(yr)
    sort yr
    gen lo = coef - 1.96*se
    gen hi = coef + 1.96*se
    twoway (rarea lo hi yr, color(gs13)) ///
           (connected coef yr, msymbol(o) msize(small) lcolor(navy) mcolor(navy)), ///
        title("Year Fixed Effects - Alpha") xtitle("Year") ytitle("Coefficient") ///
        xlabel(1970(10)2020) legend(off)
    graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_year_fe.pdf", replace
restore



* Stepwise regression

eststo clear

* No controls - capture output
tempfile stepwise_log1_alpha
log using `stepwise_log1_alpha', text replace
eststo step1: stepwise, pr(.05): regress Alpha PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) 
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_stepwise_removal_noctrl.csv", replace
restore

estadd local state_fe "No": step1
estadd local year_fe  "No": step1
estadd local race_fe  "No": step1
estadd local cohort_fe "No": step1
estadd local occ_fe   "No": step1
estadd local ind_fe   "No": step1
estadd local edu_fe   "Yes": step1
estadd local age_fe   "Yes": step1
estadd local ten_fe   "Yes": step1
estadd local state_selected " ": step1
estadd local year_selected  " ": step1
estadd local race_selected  " ": step1
estadd local cohort_selected " ": step1
estadd local occ_selected   " ": step1
estadd local ind_selected   " ": step1

* Check which of the edu/age/tenure bin sets were selected
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
    }
}
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step1
}
else {
    estadd local edu_selected "": step1
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step1
}
else {
    estadd local age_selected "": step1
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step1
}
else {
    estadd local ten_selected "": step1
}

* controls - no occ or ind - capture output
tempfile stepwise_log2_alpha
log using `stepwise_log2_alpha', text replace
eststo step2: stepwise, pr(.05): regress Alpha PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log2_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_stepwise_removal_nooccind.csv", replace
restore

estadd local state_fe "Yes": step2
estadd local year_fe  "Yes": step2
estadd local race_fe  "Yes": step2
estadd local cohort_fe "Yes": step2
estadd local occ_fe   "No": step2
estadd local ind_fe   "No": step2
estadd local edu_fe   "Yes": step2
estadd local age_fe   "Yes": step2
estadd local ten_fe   "Yes": step2

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step2
}
else {
    estadd local edu_selected "": step2
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step2
}
else {
    estadd local age_selected "": step2
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step2
}
else {
    estadd local ten_selected "": step2
}

* controls - no occ - capture output
tempfile stepwise_log3_alpha
log using `stepwise_log3_alpha', text replace
eststo step3: stepwise, pr(.05): regress Alpha PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log3_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_stepwise_removal_noocc.csv", replace
restore

estadd local state_fe "Yes": step3
estadd local year_fe  "Yes": step3
estadd local race_fe  "Yes": step3
estadd local cohort_fe "Yes": step3
estadd local occ_fe   "No": step3
estadd local ind_fe   "Yes": step3
estadd local edu_fe   "Yes": step3
estadd local age_fe   "Yes": step3
estadd local ten_fe   "Yes": step3

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local ind_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step3
}
else {
    estadd local edu_selected "": step3
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step3
}
else {
    estadd local age_selected "": step3
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step3
}
else {
    estadd local ten_selected "": step3
}

* controls - no ind - capture output
tempfile stepwise_log4_alpha
log using `stepwise_log4_alpha', text replace
eststo step4: stepwise, pr(.05): regress Alpha PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)
log close

preserve
import delimited using `stepwise_log4_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_stepwise_removal_noind.csv", replace
restore

estadd local state_fe "Yes": step4
estadd local year_fe  "Yes": step4
estadd local race_fe  "Yes": step4
estadd local cohort_fe "Yes": step4
estadd local occ_fe   "Yes": step4
estadd local ind_fe   "No": step4
estadd local edu_fe   "Yes": step4
estadd local age_fe   "Yes": step4
estadd local ten_fe   "Yes": step4

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step4
}
else {
    estadd local edu_selected "": step4
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step4
}
else {
    estadd local age_selected "": step4
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step4
}
else {
    estadd local ten_selected "": step4
}

* All controls - capture output
tempfile stepwise_log5_alpha
log using `stepwise_log5_alpha', text replace
eststo step5: stepwise, pr(.05): regress Alpha PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5 agebin_dum6) (ten_dum2 ten_dum3) (censdiv_dum1-censdiv_dum10) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum30)
log close

preserve
import delimited using `stepwise_log5_alpha', delim(":") varnames(nonames) clear stringcols(_all)
keep if strpos(v1, "removing") > 0
gen variable = regexs(1) if regexm(v1, "removing ([a-zA-Z0-9_]+)")
gen pvalue = real(regexs(1)) if regexm(v1, "p = ([0-9.]+)")
keep if variable != ""
gen order = _n
keep order variable pvalue
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_stepwise_removal_allctrl.csv", replace
restore

estadd local state_fe "Yes": step5
estadd local year_fe  "Yes": step5
estadd local race_fe  "Yes": step5
estadd local cohort_fe "Yes": step5
estadd local occ_fe   "Yes": step5
estadd local ind_fe   "Yes": step5
estadd local edu_fe   "Yes": step5
estadd local age_fe   "Yes": step5
estadd local ten_fe   "Yes": step5

* Check which FE sets were actually selected by examining the coefficient matrix
local state_selected "No"
local year_selected "No"
local race_selected "No"
local cohort_selected "No"
local occ_selected "No"
local ind_selected "No"
local edu_selected "No"
local age_selected "No"
local ten_selected "No"
matrix b = e(b)
local varnames : colnames b
foreach var of local varnames {
    if regexm("`var'", "^censdiv_dum") {
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
    if regexm("`var'", "^edu_dum") {
        local edu_selected "Yes"
    }
    if regexm("`var'", "^agebin_dum") {
        local age_selected "Yes"
    }
    if regexm("`var'", "^ten_dum") {
        local ten_selected "Yes"
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
if "`edu_selected'" == "Yes" {
    estadd local edu_selected "\checkmark": step5
}
else {
    estadd local edu_selected "": step5
}
if "`age_selected'" == "Yes" {
    estadd local age_selected "\checkmark": step5
}
else {
    estadd local age_selected "": step5
}
if "`ten_selected'" == "Yes" {
    estadd local ten_selected "\checkmark": step5
}
else {
    estadd local ten_selected "": step5
}

* Export stepwise results to LaTeX
esttab step1 step2 step3 step4 step5 using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_stepwise.tex", ///
    replace se r2 label ///
    drop(*_dum*) ///
    stats(state_selected year_selected race_selected cohort_selected occ_selected ind_selected edu_selected age_selected ten_selected state_fe year_fe race_fe cohort_fe occ_fe ind_fe edu_fe age_fe ten_fe r2 N, ///
          labels("Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE" "\midrule Census Division FE Available" "Year FE Available" "Race FE Available" "Cohort FE Available" "Occupation FE Available" "Industry FE Available" "Education FE Available" "Age Bin FE Available" "Tenure FE Available" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9.3f %9.0g))






* LASSO


* (1) No controls
quietly lasso linear Alpha ///
        (EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots${SFX}_noctrl.csv", replace
restore





* (2) “controls – no occ or ind”
quietly lasso linear Alpha ///
        (i.(censdiv year race cohort) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots${SFX}_nooccind.csv", replace
restore





* (3) “controls – no occ”
quietly lasso linear Alpha ///
        (i.(censdiv year race cohort twoind) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots${SFX}_noocc.csv", replace
restore




* (4) “controls – no ind”
quietly lasso linear Alpha ///
        (i.(censdiv year occ race cohort) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots${SFX}_noind.csv", replace
restore




* (5) “All controls”
quietly lasso linear Alpha ///
        (i.(censdiv year occ race cohort twoind) EDU1 EDU2 EDU3 EDU4 ib4.agebin ib1.tenurebin) ///
        PrRecess ma5aep OLF, ///
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
export delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots${SFX}_all.csv", replace
restore






* LASSO occ/ind models run externally in Python; SHAP CSVs imported below








preserve
clear

* Define the main variables of interest (not FE dummies)
local main_vars "PrRecess ma5aep OLF"

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
    
    import delimited using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/Alphalassoknots${SFX}_`spec'.csv", clear
    
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
listtex varname noctrl nooccind noocc noind allctrl using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/alpha${SFX}_lasso_selection.tex", ///
    replace ///
    head("\begin{tabular}{lccccc}" ///
         "\hline\hline" ///
         "  & No Controls & No Occ/Ind & No Occ & No Ind & All Controls \\" ///
         "\hline") ///
    foot("\hline" ///
         "\multicolumn{6}{l}{} \\" ///
         "Census Division FE & `state_fe_noctrl' & `state_fe_nooccind' & `state_fe_noocc' & `state_fe_noind' & `state_fe_allctrl' \\" ///
         "Year FE & `year_fe_noctrl' & `year_fe_nooccind' & `year_fe_noocc' & `year_fe_noind' & `year_fe_allctrl' \\" ///
         "Race FE & `race_fe_noctrl' & `race_fe_nooccind' & `race_fe_noocc' & `race_fe_noind' & `race_fe_allctrl' \\" ///
         "Cohort FE & `cohort_fe_noctrl' & `cohort_fe_nooccind' & `cohort_fe_noocc' & `cohort_fe_noind' & `cohort_fe_allctrl' \\" ///
         "Occupation FE & `occ_fe_noctrl' & `occ_fe_nooccind' & `occ_fe_noocc' & `occ_fe_noind' & `occ_fe_allctrl' \\" ///
         "Industry FE & `ind_fe_noctrl' & `ind_fe_nooccind' & `ind_fe_noocc' & `ind_fe_noind' & `ind_fe_allctrl' \\" ///
         "Education FE & Yes & Yes & Yes & Yes & Yes \\" ///
         "Age Bin FE & Yes & Yes & Yes & Yes & Yes \\" ///
         "Tenure FE & Yes & Yes & Yes & Yes & Yes \\" ///
         "\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)

restore



