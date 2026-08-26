



clear all

* ===========================================================================
* PATH AND SPEC CONSTANTS
* Globals (not locals) so any section can be run on its own once the data
* prep below has been executed. RHS_NO / RHS_ALL are the two carried
* regression specifications (7_Analysis.do models m2 / m5); term order is
* preserved so results reproduce exactly.
* ===========================================================================

global DATADIR "/Users/ethanballou/Documents/Data/LER_Draft2"
global REPODIR "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk"
global OUTDIR  "$REPODIR/OtherOutput/ThirdDraft"
global SHAPDIR "$OUTDIR/shap"

* Nothing is written to the repo root. Tables and figures go to OUTDIR, the
* SHAP CSVs written by 6.2-6.5 are read from SHAPDIR. Neither directory is
* created anywhere else in the pipeline, so make them here.
capture mkdir "$OUTDIR"
capture mkdir "$SHAPDIR"

global RHS_NO  "EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year race cohort)"
global RHS_ALL "EDU1 EDU2 EDU3 EDU4 PrRecess ma5aep OLF ib1.tenurebin ib4.agebin i.(censdiv year occ race cohort twoind)"


use "$DATADIR/Consolidated_AlphaGamma_withDemographics.dta", replace



/*


- What is gamma/alpha

1. Stratified means of PSID data and gamma/alpha (Large table)
2. Earnings profiles across groups
3. Distribution
4. Distribution across age with density
5. OLS Table


- What variables should be used to predict risk (selection), later do the methods agree?

5. F Test
6. Stepwise
7. LASSO
8. Some sort of RF selection table
9. Some sort of NN selection table
10. Occ and Ind ranking plots
11. Correlation matrix of predictions


- Who has the most risk who has the least

12. Stratified means of predicted risk
13. Stratified means of predicted risk by age
14. Extra table breaking down who has more or less risk
15. Extra table breaking down who has more or less risk


- Appendix

16. OCC tables
17. IND tables



*/




* ===========================================================================
* EARLY DATA PREP
* Run this section only immediately after the -use- above: rerunning it
* mid-session would rescale twice and collide with the *_dum variables.
* Reload the data first if in doubt. Everything after this section assumes
* it has run (renamed risk measures, merged predictions, dummy sets).
* ===========================================================================


* --- (1) Short names for the four consolidated risk measures ---

rename gammaP_WEIGHTED       gam_wage
rename alphaP_WEIGHTED       alph_wage
rename gammaP_WEIGHTED_fearn gam_earn
rename alphaP_WEIGHTED_fearn alph_earn

label var gam_wage  "Gamma (Hourly Wage)"
label var alph_wage "Alpha (Hourly Wage)"
label var gam_earn  "Gamma (Annual Earnings)"
label var alph_earn "Alpha (Annual Earnings)"

* The saved data marks the regression reference categories in the age and
* tenure bin labels; drop the "(ref)" markers for table display
label define agebin_lbl 1 "22-29" 2 "30-37" 3 "38-45" 4 "46-53" ///
    5 "54-61" 6 "62-69", replace
label define tenurebin_lbl 1 "0-1" 2 "2-5" 3 "6+", replace


* --- (2) Merge the person-year fitted values from the Python ML scripts ---
* 16 CSVs: {NN,RF,Lasso,OLS}_predictions_{gamma,alpha}{,_fearn}.csv. Every CSV
* stores its prediction under a generic column name (pred_nn / pred_rf /
* pred_lasso / pred_ols), so each is renamed to a distinct
* pred_<model>_<risk>_<meas> before merging: pred_nn_gam_wage ... pred_ols_alph_earn.

foreach meth in NN RF Lasso OLS {
    local m = lower("`meth'")
    foreach outn in gamma alpha {
        local o = cond("`outn'"=="gamma","gam","alph")
        foreach meas in wage earn {
            local sfx = cond("`meas'"=="earn","_fearn","")

            preserve
                import delimited using "$DATADIR/`meth'_predictions_`outn'`sfx'.csv", clear
                rename pred_`m' pred_`m'_`o'_`meas'
                tempfile prd
                save `prd', replace
            restore

            merge 1:1 personid year using `prd', keep(1 3) nogenerate
        }
    }
}


* --- (3) Education categories (0 = less than HS, matches EDU1-4 dummies) ---

gen educat = .
replace educat = 0 if edyrs < 12
replace educat = 1 if edyrs >= 12 & edyrs < 14
replace educat = 2 if edyrs >= 14 & edyrs < 16
replace educat = 3 if edyrs == 16
replace educat = 4 if edyrs > 16 & edyrs != .
label define educat_lbl 0 "Less than HS" 1 "High School Graduate" ///
    2 "Some College" 3 "Bachelor's Degree" 4 "Bachelors+", replace
label values educat educat_lbl


* --- (4) Rescaling for the regression sections (same /100 as 7_Analysis) ---
* Only the variables those models use; currentage etc. stay in natural units
* because the age-profile plots below plot them directly.

replace EDU1 = EDU1 / 100
replace EDU2 = EDU2 / 100
replace EDU3 = EDU3 / 100
replace EDU4 = EDU4 / 100
replace OLF = OLF / 100
replace PrRecess = PrRecess / 100
replace ma5aep = ma5aep / 100

label var OLF "Out of Labor Force"


* --- (5) Dummy sets for the stepwise regressions ---
* Bins are FE control sets, so their dummies get *_dum names; the stepwise
* esttab drop(*_dum*) removes them from the table body and they report as
* checkmark/Yes rows. (agebin_dum4 = age 46-53 and ten_dum1 = tenure 0-1
* are the omitted references.)

tabulate race,      generate(race_dum)
tabulate censdiv,   generate(censdiv_dum)
tabulate occ,       generate(occ_dum)
tabulate year,      generate(year_dum)
tabulate cohort,    generate(cohort_dum)
tabulate twoind,    generate(twoind_dum)
tabulate agebin,    generate(agebin_dum)
tabulate tenurebin, generate(ten_dum)

* Education dummy copies with FE-dummy naming (post-rescale, same scale)
gen edu_dum1 = EDU1
gen edu_dum2 = EDU2
gen edu_dum3 = EDU3
gen edu_dum4 = EDU4




* ===========================================================================
* SUMMARY STATISTICS OF THE RISK MEASURES
*
* First table of the paper: moments of the four actual risk measures at the
* person-year level, on each measure's full non-missing sample, with the
* mean of the bottom and top deciles to show the spread. No predictions.
* ===========================================================================

preserve
    matrix S = J(4, 6, .)
    local r = 0
    foreach v in gam_wage alph_wage gam_earn alph_earn {
        local ++r

        quietly summarize `v', detail
        matrix S[`r', 1] = r(mean)
        matrix S[`r', 2] = r(sd)
        matrix S[`r', 5] = r(N)
        local p10 = r(p10)
        local p90 = r(p90)

        * mean of the measure within its bottom and top deciles
        quietly summarize `v' if `v' <= `p10'
        matrix S[`r', 3] = r(mean)
        quietly summarize `v' if `v' >= `p90'
        matrix S[`r', 4] = r(mean)

        * distinct persons with the measure observed
        egen tag_`v' = tag(personid) if !missing(`v')
        quietly count if tag_`v' == 1
        matrix S[`r', 6] = r(N)
    }

    clear
    svmat S, names(c)
    gen str30 measure = ""
    replace measure = "Gamma (Hourly)"     in 1
    replace measure = "Alpha (Hourly)"     in 2
    replace measure = "Gamma (Annual)" in 3
    replace measure = "Alpha (Annual)" in 4
    order measure
    format c1 c2 c3 c4 %9.4f
    format c5 c6 %12.0fc

    listtex measure c1 c2 c3 c4 c5 c6 using "$OUTDIR/risk_summary_stats.tex", ///
        replace ///
        head("\begin{tabular}{lcccccc}" ///
             "\hline\hline" ///
             " & Mean & SD & Bot 10\% Mean & Top 10\% Mean & Person-Years & Persons \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
restore




* ===========================================================================
* TABLE 1: STRATIFIED MEANS (Gamma/Alpha x fhwage/fearn) BY DEMOGRAPHIC GROUP
*
* Simple summary stats, then means of all four risk measures broken out by
* education, race, cohort, age bin, tenure bin, and income quintile (annual
* earnings and hourly wage).
* ===========================================================================

preserve

* --- Basic summary stats for the four risk measures ---
summarize gam_wage alph_wage gam_earn alph_earn

* Income bins (quintiles), separately for annual earnings and hourly wage
xtile earnbin = realearn, nquantiles(5)
xtile wagebin = hwage, nquantiles(5)
label define earnbin_lbl 1 "1st Quintile" 2 "2nd Quintile" ///
    3 "3rd Quintile" 4 "4th Quintile" 5 "5th Quintile", replace
label values earnbin earnbin_lbl
label define wagebin_lbl 1 "1st Quintile" 2 "2nd Quintile" ///
    3 "3rd Quintile" 4 "4th Quintile" 5 "5th Quintile", replace
label values wagebin wagebin_lbl

tempfile base
save `base', replace

tempfile stacked
local first = 1

foreach bvar in educat race cohort agebin tenurebin earnbin wagebin {

    if "`bvar'" == "educat"    local btitle "Education"
    if "`bvar'" == "race"      local btitle "Race"
    if "`bvar'" == "cohort"    local btitle "Cohort"
    if "`bvar'" == "agebin"    local btitle "Age Bin"
    if "`bvar'" == "tenurebin" local btitle "Tenure Bin"
    if "`bvar'" == "earnbin"   local btitle "Annual Earnings Quintile"
    if "`bvar'" == "wagebin"   local btitle "Hourly Wage Quintile"

    use `base', clear
    collapse (mean) gam_wage alph_wage gam_earn alph_earn ///
             (count) n=gam_wage, by(`bvar')
    drop if missing(`bvar')

    gen str30 block = "`btitle'"
    decode `bvar', gen(category)
    drop `bvar'

    if `first' == 1 {
        save `stacked', replace
        local first = 0
    }
    else {
        append using `stacked'
        save `stacked', replace
    }
}

use `stacked', clear
order block category gam_wage alph_wage gam_earn alph_earn n

* risk measures reported x 100 (the paper caption notes the scaling)
foreach v in gam_wage alph_wage gam_earn alph_earn {
    replace `v' = 100 * `v'
}

* group title printed once, on the first row of each block (compare against
* an untouched copy: replace runs top-down, so block[_n-1] would already be
* blanked and every other row would keep its title)
gen str30 blockfull = block
replace block = "" if _n > 1 & blockfull == blockfull[_n-1]
drop blockfull

format gam_wage alph_wage gam_earn alph_earn %9.2f
format n %12.0fc

label var block     "Group"
label var category  "Category"
label var gam_wage  "Gamma (hourly)"
label var alph_wage "Alpha (hourly)"
label var gam_earn  "Gamma (annual)"
label var alph_earn "Alpha (annual)"
label var n          "N"



listtex block category gam_wage alph_wage gam_earn alph_earn n ///
    using "$OUTDIR/stratified_means_gamma_alpha.tex", ///
    replace ///
    head("\begin{tabular}{llccccc}" ///
         "\hline\hline" ///
         "Group & Category & Gamma (hourly) & Alpha (hourly) & Gamma (annual) & Alpha (annual) & N \\" ///
         "\hline") ///
    foot("\hline\hline" ///
         "\end{tabular}") ///
    rstyle(tabular)

restore




* ===========================================================================
* AGE-EARNINGS PROFILE PANELS BY COHORT x RACE (lines = Education)
*
* For each earnings measure (annual earnings, hourly wage), plot mean
* earnings by age, one panel per cohort x white/non-white combination, with
* one line per education category (educwrths) within each panel. The 8
* cohort x race panels are split into two separate 2x2 grids by cohort pair
* (pre-1944 & 1944-1952; 1953-1960 & post-1960). No legend graph is combined
* in (graph combine gives a legend row the same height as a panel row, which
* wastes a lot of space) -- instead a note() caption below each grid states
* the fixed line-color-to-education mapping, and panels are sized taller.
* ===========================================================================

preserve

tempfile plotbase
save `plotbase', replace

local cohortvals "10 20 30 40"
local whitevals  "100 200"

foreach meas in realearn hwage {

    * --- one panel per cohort x white/non-white combination ---
    foreach c of local cohortvals {
        foreach w of local whitevals {

            use `plotbase', clear
            keep if cohort == `c' & white == `w'
            collapse (mean) `meas', by(currentage educwrths)
            drop if missing(educwrths)
            separate `meas', by(educwrths) veryshortlabel

            if `c' == 10 local cohorttitle "Born Pre-1944"
            if `c' == 20 local cohorttitle "Born 1944-1952"
            if `c' == 30 local cohorttitle "Born 1953-1960"
            if `c' == 40 local cohorttitle "Born Post-1960"
            if `w' == 100 local racetitle "White"
            if `w' == 200 local racetitle "Non-white"

            * black lines distinguished by pattern, in educwrths order:
            * solid = HS Dropout, dash = HS Grad, dot = Some College,
            * dash-dot = College Grad
            twoway line `meas'1-`meas'4 currentage, sort legend(off) ///
                lcolor(black black black black) ///
                lpattern(solid dash dot dash_dot) ///
                title("`cohorttitle', `racetitle'", size(small)) ///
                xtitle("Age") ytitle("") ///
                ylabel(#4, labsize(vsmall) angle(0)) ///
                name(g_`meas'_`c'_`w', replace)
        }
    }

    * note text states the measure and that values are in 2024 dollars
    if "`meas'" == "realearn" local measnote "Annual earnings in 2024 dollars."
    else                      local measnote "Hourly wage in 2024 dollars."

    * --- Grid 1: cohorts pre-1944 and 1944-1952 ---
    graph combine g_`meas'_10_100 g_`meas'_10_200 ///
                  g_`meas'_20_100 g_`meas'_20_200, ///
        cols(2) name(g_`meas'_group1, replace) ///
        note("Solid = HS Dropout; Dashed = HS Graduate; Dotted = Some College; Dash-dot = College Graduate." ///
             "`measnote'", size(small)) ///
        ysize(6) xsize(8)

    graph export "$OUTDIR/avg_`meas'_by_age_cohort1_race.png", ///
        replace width(2000)

    * --- Grid 2: cohorts 1953-1960 and post-1960 ---
    graph combine g_`meas'_30_100 g_`meas'_30_200 ///
                  g_`meas'_40_100 g_`meas'_40_200, ///
        cols(2) name(g_`meas'_group2, replace) ///
        note("Solid = HS Dropout; Dashed = HS Graduate; Dotted = Some College; Dash-dot = College Graduate." ///
             "`measnote'", size(small)) ///
        ysize(6) xsize(8)

    graph export "$OUTDIR/avg_`meas'_by_age_cohort2_race.png", ///
        replace width(2000)
}

restore




* ===========================================================================
* MEAN GAMMA/ALPHA BY AGE ACROSS COHORTS (4 separate plots)
*
* For each risk measure (gamma/alpha x hourly/annual), plot the mean of the
* raw measure by 4-year age bin (agebin4, bins 1-10 = ages 22-61; the first
* stage drops currentage > 61), one line per birth cohort. Same B&W styling
* as the age-earnings profiles above (black lines distinguished by pattern,
* no legend); the pattern-to-cohort mapping lives in the paper's figure
* caption. Fixed y-ranges so panels compare within measure: 0-0.04 for
* gamma, 0-0.2 for alpha. Exported as four separate PNGs; the paper
* combines them into one 2x2 float (fig:mean_risk_by_age_cohort). Rare thin
* cohort x bin edge cells are dropped.
* ===========================================================================

foreach v in gam_wage alph_wage gam_earn alph_earn {

    * fixed, comparable y-ranges: gamma 0-0.04, alpha 0-0.2
    if strpos("`v'", "gam") local yl "ylabel(0(.01).04, labsize(medsmall) angle(0))"
    else                    local yl "ylabel(0(.05).2, labsize(medsmall) angle(0))"

    preserve
        collapse (mean) m=`v' (count) n=`v', by(agebin4 cohort)
        drop if missing(cohort) | missing(agebin4)
        keep if agebin4 <= 10
        drop if n < 25

        * cohort is coded 10/20/30/40, so separate yields m10/m20/m30/m40
        separate m, by(cohort) veryshortlabel

        twoway line m10 m20 m30 m40 agebin4, sort legend(off) ///
            lcolor(black black black black) ///
            lpattern(solid dash dot dash_dot) ///
            xtitle("Age Bin") ytitle("") ///
            xlabel(1(1)10, valuelabel angle(45) labsize(medsmall)) ///
            `yl'

        graph export "$OUTDIR/mean_`v'_by_age_cohort.png", replace width(2000)
    restore
}




* ===========================================================================
* DISTRIBUTION OF GAMMA/ALPHA (histograms, 2x2 panel)
*
* One histogram per risk measure (gamma/alpha x hourly/annual), each with its
* own title. Combined into a single 2x2 image with no overall title.
* ===========================================================================

preserve

* Plot-only copies with extreme values set to missing so the tails don't
* stretch the axes: gamma outside [-0.3, 0.3], alpha outside [-0.3, 0.75].
* Used for these histograms only, then dropped.
gen gammaDIST = gam_wage  if inrange(gam_wage,  -0.3, 0.3)
gen alphaDIST = alph_wage if inrange(alph_wage, -0.3, 0.75)

histogram gammaDIST, title("Gamma (Hourly)", size(medium))  xtitle("Gamma") name(g_hist_gam_wage, replace)
histogram alphaDIST, title("Alpha (Hourly)", size(medium))  xtitle("Alpha") name(g_hist_alph_wage, replace)

replace gammaDIST = cond(inrange(gam_earn,  -0.3, 0.3),  gam_earn,  .)
replace alphaDIST = cond(inrange(alph_earn, -0.3, 0.75), alph_earn, .)

histogram gammaDIST, title("Gamma (Annual)", size(medium))  xtitle("Gamma") name(g_hist_gam_earn, replace)
histogram alphaDIST, title("Alpha (Annual)", size(medium))  xtitle("Alpha") name(g_hist_alph_earn, replace)

drop gammaDIST alphaDIST

graph combine g_hist_gam_wage g_hist_alph_wage g_hist_gam_earn g_hist_alph_earn, ///
    cols(2) name(g_hist_panel, replace) ysize(6) xsize(8)

graph export "$OUTDIR/distribution_gamma_alpha_panel.png", replace width(2000)

restore




* ===========================================================================
* DISTRIBUTION OF GAMMA/ALPHA ACROSS AGE (binned box plots, 2x2 panel)
*
* One box plot per risk measure (gamma/alpha x hourly/annual), age grouped
* into the existing 4-year agebin4 categories. Each panel has its own title;
* the combined 2x2 image has no overall title. Box and whiskers only:
* outside values are not plotted (nooutsides; note("") suppresses the
* automatic "excludes outside values" caption). The last two age bins
* (62-65, 66-69) are not shown: plot-only copies blank them out, and over()
* drops categories with no nonmissing values. Y-axes are set manually:
* gamma -0.15 to 0.2, alpha -0.3 to 0.4.
* ===========================================================================

preserve

local lbl_gam_wage  "Gamma (Hourly)"
local lbl_alph_wage "Alpha (Hourly)"
local lbl_gam_earn  "Gamma (Annual)"
local lbl_alph_earn "Alpha (Annual)"

local yopt_gam  yscale(range(-0.15 0.2)) ylabel(-0.15(0.05)0.2)
local yopt_alph yscale(range(-0.3 0.4)) ylabel(-0.3(0.1)0.4)

foreach meas in wage earn {

    gen gammaAGEDIST = gam_`meas'  if !inlist(agebin4, 11, 12)
    gen alphaAGEDIST = alph_`meas' if !inlist(agebin4, 11, 12)

    * the if restriction removes the empty 62-65 / 66-69 slots from the
    * category axis (over() keeps a labeled slot for any group that has
    * observations, even when the plotted variable is all missing there)
    graph box gammaAGEDIST if !inlist(agebin4, 11, 12), ///
        over(agebin4, label(angle(45) labsize(vsmall))) ///
        nooutsides note("") `yopt_gam' ///
        title("`lbl_gam_`meas''", size(medium)) ytitle("`lbl_gam_`meas''") ///
        name(g_box_gam_`meas', replace)

    graph box alphaAGEDIST if !inlist(agebin4, 11, 12), ///
        over(agebin4, label(angle(45) labsize(vsmall))) ///
        nooutsides note("") `yopt_alph' ///
        title("`lbl_alph_`meas''", size(medium)) ytitle("`lbl_alph_`meas''") ///
        name(g_box_alph_`meas', replace)

    drop gammaAGEDIST alphaAGEDIST
}

graph combine g_box_gam_wage g_box_alph_wage g_box_gam_earn g_box_alph_earn, ///
    cols(2) name(g_box_panel, replace) ysize(6) xsize(8)

graph export "$OUTDIR/age_density_gamma_alpha_panel.png", replace width(2000)

restore




* ===========================================================================
* OLS TABLES (Gamma, Alpha)
*
* Carried from 7_Analysis.do models m2 (no occ/ind) and m5 (all controls).
* One combined table: Gamma (cols 1-4) and Alpha (cols 5-8) side by side
* with a vertical divider, columns grouped by earnings measure within each:
*   Hourly {No Occ/Ind, All Controls}, Annual {No Occ/Ind, All Controls}
* ===========================================================================

eststo clear

foreach o in gam alph {
    foreach meas in wage earn {
        foreach spec in no all {

            if "`spec'" == "no" local rhs "$RHS_NO"
            else                local rhs "$RHS_ALL"

            eststo ols_`o'_`meas'_`spec': regress `o'_`meas' `rhs'

            estadd local state_fe  "Yes": ols_`o'_`meas'_`spec'
            estadd local year_fe   "Yes": ols_`o'_`meas'_`spec'
            estadd local race_fe   "Yes": ols_`o'_`meas'_`spec'
            estadd local cohort_fe "Yes": ols_`o'_`meas'_`spec'

            local yn = cond("`spec'"=="all","Yes","No")
            estadd local occ_fe "`yn'": ols_`o'_`meas'_`spec'
            estadd local ind_fe "`yn'": ols_`o'_`meas'_`spec'
        }
    }
}

* One table: Gamma columns (1)-(4) on the left, Alpha columns (5)-(8) on the
* right, with a vertical rule dividing the two (custom prehead supplies the
* piped column spec that esttab's default header would not produce).
esttab ols_gam_wage_no ols_gam_wage_all ols_gam_earn_no ols_gam_earn_all ///
       ols_alph_wage_no ols_alph_wage_all ols_alph_earn_no ols_alph_earn_all ///
    using "$OUTDIR/gamma_alpha_ols.tex", ///
    replace se r2 label ///
    prehead("{" "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" "\begin{tabular}{l*{4}{c}|*{4}{c}}" "\hline\hline") ///
    keep(EDU1 EDU2 EDU3 EDU4 1.agebin 2.agebin 3.agebin 5.agebin PrRecess ma5aep OLF 2.tenurebin 3.tenurebin) ///
    order(EDU1 EDU2 EDU3 EDU4 1.agebin 2.agebin 3.agebin 5.agebin PrRecess ma5aep OLF 2.tenurebin 3.tenurebin) ///
    mgroups("Gamma, Hourly Wage" "Gamma, Annual Earnings" "Alpha, Hourly Wage" "Alpha, Annual Earnings", ///
            pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
    mtitles("No Occ/Ind" "All Controls" "No Occ/Ind" "All Controls" "No Occ/Ind" "All Controls" "No Occ/Ind" "All Controls") ///
    nodepvars ///
    stats(state_fe year_fe race_fe cohort_fe occ_fe ind_fe r2 N, ///
          labels("Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9.3f %9.0g)) ///
    star(* 0.10 ** 0.05 *** 0.01)




* ===========================================================================
* DESCRIPTIVE STATS OF THE OLS PREDICTIONS
*
* Distribution of the full-sample OLS fitted values (pred_ols_*, merged in
* the early data prep), x 100 like the other risk tables; \% Negative is a
* percent of that column's estimation sample (rendered with a \% sign and
* set off by a rule after the SD row). Columns: Annual (Gamma, Alpha) |
* Hourly (Gamma, Alpha). Sits after the OLS regression table in the paper
* (tab:ols_pred_summary_stats).
* ===========================================================================

preserve
    matrix OS = J(5, 4, .)
    local c = 0
    foreach v in pred_ols_gam_earn pred_ols_alph_earn pred_ols_gam_wage pred_ols_alph_wage {
        local ++c
        quietly summarize `v', detail
        matrix OS[1,`c'] = 100*r(mean)
        matrix OS[2,`c'] = 100*r(p50)
        matrix OS[3,`c'] = 100*r(sd)
        matrix OS[5,`c'] = r(N)
        local nn = r(N)
        quietly count if `v' < 0
        matrix OS[4,`c'] = 100*r(N)/`nn'
    }

    clear
    set obs 5
    gen str30 stat = ""
    replace stat = "Mean"   in 1
    replace stat = "Median" in 2
    replace stat = "SD"     in 3
    * the \hline prefix draws a divider between the SD and % Negative rows
    replace stat = "\hline \% Negative" in 4
    replace stat = "N"      in 5

    forvalues c = 1/4 {
        gen str20 c`c' = ""
        forvalues r = 1/3 {
            local x : display %9.2f OS[`r',`c']
            quietly replace c`c' = strtrim("`x'") in `r'
        }
        local x : display %9.2f OS[4,`c']
        quietly replace c`c' = strtrim("`x'") + "\%" in 4
        local n : display %12.0fc OS[5,`c']
        quietly replace c`c' = strtrim("`n'") in 5
    }

    listtex stat c1 c2 c3 c4 using "$OUTDIR/ols_pred_summary_stats.tex", ///
        replace ///
        head("\begin{tabular}{lcc|cc}" ///
             "\hline\hline" ///
             " & \multicolumn{2}{c|}{Annual Earnings} & \multicolumn{2}{c}{Hourly Wage} \\" ///
             "Statistic & Gamma & Alpha & Gamma & Alpha \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
restore




* ===========================================================================
* F-TEST TABLES (Gamma, Alpha)
*
* Joint significance of each FE/control set in the no-occ/ind and
* all-controls models (7_Analysis.do models 2 and 5), for both earnings
* measures. Same four-column layout as the OLS tables. Cells show
* "F-stat*** (p-value)"; "--" marks sets absent from a model.
* ===========================================================================

* testparm argument for each of the 9 table rows
local tp1 "i.censdiv"
local tp2 "i.year"
local tp3 "i.race"
local tp4 "i.cohort"
local tp5 "i.occ"
local tp6 "i.twoind"
local tp7 "EDU1 EDU2 EDU3 EDU4"
local tp8 "i.agebin"
local tp9 "i.tenurebin"

foreach o in gam alph {
    local outname = cond("`o'"=="gam","gamma","alpha")

    matrix f_`o' = J(9,4,.)
    matrix p_`o' = J(9,4,.)

    local col = 0
    foreach meas in wage earn {
        foreach spec in no all {
            local ++col

            if "`spec'" == "no" local rhs "$RHS_NO"
            else                local rhs "$RHS_ALL"

            quietly regress `o'_`meas' `rhs'

            forvalues r = 1/9 {
                * occ (row 5) and ind (row 6) are absent from the no-occ/ind
                * model; their cells stay missing and print as "--"
                if "`spec'" == "no" & inlist(`r',5,6) continue

                quietly testparm `tp`r''
                matrix f_`o'[`r',`col'] = r(F)
                matrix p_`o'[`r',`col'] = r(p)
            }
        }
    }

    * Build the formatted "F*** (p)" columns and export
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

    forvalues j = 1/4 {
        gen f_m`j' = .
        gen p_m`j' = .
        forvalues i = 1/9 {
            replace f_m`j' = f_`o'[`i',`j'] in `i'
            replace p_m`j' = p_`o'[`i',`j'] in `i'
        }
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

    listtex fe_name col1 col2 col3 col4 using "$OUTDIR/`outname'_ftest.tex", ///
        replace ///
        head("\begin{tabular}{lcccc}" ///
             "\hline\hline" ///
             " & \multicolumn{2}{c}{Hourly Wage} & \multicolumn{2}{c}{Annual Earnings} \\" ///
             " & No Occ/Ind & All Controls & No Occ/Ind & All Controls \\" ///
             " & (1) & (2) & (3) & (4) \\" ///
             "\hline") ///
        foot("\hline" ///
             "\multicolumn{5}{l}{\footnotesize Note: F-statistics reported with p-values in parentheses.} \\" ///
             "\multicolumn{5}{l}{\footnotesize * p$<$0.10, ** p$<$0.05, *** p$<$0.01} \\" ///
             "\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
    restore
}




* ===========================================================================
* STEPWISE TABLES (Gamma, Alpha)
*
* Backward elimination at p = .05, carried from 7_Analysis.do models step2
* (no occ/ind) and step5 (all controls). Same combined Gamma|Alpha layout as
* the OLS table. Checkmark rows mark FE sets the elimination kept; Yes/No rows mark
* the sets available to each model. The removal-order CSV logging from
* 7_Analysis is not carried.
*
* FE sets whose dummies have no omitted reference use wildcards (robust to
* category-count changes); edu/agebin/ten keep explicit lists so the
* reference category stays out. agebin_dum6 (62-69) no longer exists: the
* pipeline drops currentage > 61, so tabulate creates only 5 agebin dummies.
* If a Stata version rejects wildcards inside stepwise terms, pre-expand
* with -unab- (e.g. unab occlist : occ_dum*).
* ===========================================================================

local sw_no  "PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5) (ten_dum2 ten_dum3) (censdiv_dum*) (year_dum*) (race_dum*) (cohort_dum*)"
local sw_all "PrRecess ma5aep OLF (edu_dum1 edu_dum2 edu_dum3 edu_dum4) (agebin_dum1 agebin_dum2 agebin_dum3 agebin_dum5) (ten_dum2 ten_dum3) (censdiv_dum*) (year_dum*) (occ_dum*) (race_dum*) (cohort_dum*) (twoind_dum*)"

eststo clear

foreach o in gam alph {
    foreach meas in wage earn {
        foreach spec in no all {

            eststo sw_`o'_`meas'_`spec': stepwise, pr(.05): regress `o'_`meas' `sw_`spec''

            * FE sets the elimination kept (checkmark rows): a set counts as
            * selected if any of its dummies survives in e(b)
            local names : colnames e(b)
            foreach pair in "censdiv_dum state" "year_dum year" "race_dum race" ///
                            "cohort_dum cohort" "occ_dum occ" "twoind_dum ind" ///
                            "edu_dum edu" "agebin_dum age" "ten_dum ten" {
                local pre  : word 1 of `pair'
                local stub : word 2 of `pair'
                local sel ""
                foreach v of local names {
                    if strmatch("`v'", "`pre'*") local sel "\checkmark"
                }
                estadd local `stub'_selected "`sel'": sw_`o'_`meas'_`spec'
            }

            * FE sets available to the model (Yes/No rows)
            estadd local state_fe  "Yes": sw_`o'_`meas'_`spec'
            estadd local year_fe   "Yes": sw_`o'_`meas'_`spec'
            estadd local race_fe   "Yes": sw_`o'_`meas'_`spec'
            estadd local cohort_fe "Yes": sw_`o'_`meas'_`spec'
            estadd local edu_fe    "Yes": sw_`o'_`meas'_`spec'
            estadd local age_fe    "Yes": sw_`o'_`meas'_`spec'
            estadd local ten_fe    "Yes": sw_`o'_`meas'_`spec'

            local yn = cond("`spec'"=="all","Yes","No")
            estadd local occ_fe "`yn'": sw_`o'_`meas'_`spec'
            estadd local ind_fe "`yn'": sw_`o'_`meas'_`spec'
        }
    }
}

* One table: Gamma columns (1)-(4), vertical divider, Alpha columns (5)-(8)
esttab sw_gam_wage_no sw_gam_wage_all sw_gam_earn_no sw_gam_earn_all ///
       sw_alph_wage_no sw_alph_wage_all sw_alph_earn_no sw_alph_earn_all ///
    using "$OUTDIR/gamma_alpha_stepwise.tex", ///
    replace se r2 label ///
    drop(*_dum*) ///
    prehead("{" "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" "\begin{tabular}{l*{4}{c}|*{4}{c}}" "\hline\hline") ///
    mgroups("Gamma, Hourly Wage" "Gamma, Annual Earnings" "Alpha, Hourly Wage" "Alpha, Annual Earnings", ///
            pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
    mtitles("No Occ/Ind" "All Controls" "No Occ/Ind" "All Controls" "No Occ/Ind" "All Controls" "No Occ/Ind" "All Controls") ///
    nodepvars ///
    stats(state_selected year_selected race_selected cohort_selected occ_selected ind_selected edu_selected age_selected ten_selected state_fe year_fe race_fe cohort_fe occ_fe ind_fe edu_fe age_fe ten_fe r2 N, ///
          labels("Census Division FE" "Year FE" "Race FE" "Cohort FE" "Occupation FE" "Industry FE" "Education FE" "Age Bin FE" "Tenure FE" "\midrule Census Division FE Available" "Year FE Available" "Race FE Available" "Cohort FE Available" "Occupation FE Available" "Industry FE Available" "Education FE Available" "Age Bin FE Available" "Tenure FE Available" "R-squared" "N") ///
          fmt(%9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9.3f %9.0g))




* ===========================================================================
* CORRELATION OF ML PREDICTIONS (NN / RF / LASSO)
*
* How much do the three methods agree? Pairwise correlations of the
* person-year predictions, computed on each outcome's estimation sample.
* One table per earnings measure: Gamma 3x3 lower triangle on the left,
* Alpha on the right, with a vertical divider.
* ===========================================================================

foreach meas in wage earn {
    local sfx = cond("`meas'"=="earn","_fearn","")

    foreach o in gam alph {
        preserve
            keep if !missing(pred_nn_`o'_`meas')
            correlate pred_nn_`o'_`meas' pred_rf_`o'_`meas' pred_lasso_`o'_`meas'
            matrix C_`o' = r(C)
        restore
    }

    preserve
        clear
        set obs 3
        gen rowname = ""
        replace rowname = "NN" in 1
        replace rowname = "RF" in 2
        replace rowname = "LASSO" in 3

        forvalues j = 1/3 {
            gen str12 g`j' = ""
            gen str12 a`j' = ""
            forvalues i = `j'/3 {
                local vg : display %6.3f C_gam[`i',`j']
                local va : display %6.3f C_alph[`i',`j']
                replace g`j' = strtrim("`vg'") in `i'
                replace a`j' = strtrim("`va'") in `i'
            }
        }

        listtex rowname g1 g2 g3 a1 a2 a3 ///
            using "$OUTDIR/gamma_alpha_pred_corr`sfx'.tex", ///
            replace ///
            head("\begin{tabular}{lccc|ccc}" ///
                 "\hline\hline" ///
                 " & \multicolumn{3}{c|}{Gamma} & \multicolumn{3}{c}{Alpha} \\" ///
                 " & NN & RF & LASSO & NN & RF & LASSO \\" ///
                 "\hline") ///
            foot("\hline\hline" ///
                 "\end{tabular}") ///
            rstyle(tabular)
    restore
}




* ===========================================================================
* GROUP SHAP SHARES OF CONTROLS
*
* Average |SHAP| per variable within each control set (sum of the set's
* mean-|SHAP| values / number of variables in the set), from the Python
* SHAP summary CSVs. One table per risk measure: rows = the F-test control
* sets; columns = NN / RF / LASSO for hourly and annual earnings, x100.
* SHAP values are in each model's scaled-target units: comparable across
* methods within a measure, less so across measures.
* ===========================================================================

foreach outn in gamma alpha {

    foreach meas in fhwage fearn {
        local sfx  = cond("`meas'"=="fearn","_fearn","")
        local stub = cond("`meas'"=="fearn","e_","w_")

        foreach meth in nn rf lasso {
            if "`meth'" == "rf"         local pre "RF_"
            else if "`meth'" == "lasso" local pre "Lasso_"
            else                        local pre ""

            preserve
                import delimited using "$SHAPDIR/`pre'shap_summary_`outn'`sfx'.csv", clear

                * assign each feature to its control set
                gen grp = ""
                replace grp = "censdiv" if strmatch(feature, "censdiv_*")
                replace grp = "year"    if strmatch(feature, "year_*")
                replace grp = "race"    if strmatch(feature, "race_*")
                replace grp = "cohort"  if strmatch(feature, "cohort_*")
                replace grp = "occ"     if strmatch(feature, "occ_*")
                replace grp = "ind"     if strmatch(feature, "twoind_*")
                replace grp = "edu"     if strmatch(feature, "EDU*")
                * age: agebin dummies once the ML scripts are rerun with the
                * binned spec; the continuous-age names cover older CSVs
                replace grp = "age"     if strmatch(feature, "agebin_*") | ///
                    inlist(feature, "currentage", "currentagesq", "currentagecube")
                replace grp = "tenure"  if feature == "tenure"

                drop if grp == ""       // PrRecess and OLF are not control sets

                collapse (mean) averageshapvalue, by(grp)
                replace averageshapvalue = 100 * averageshapvalue
                rename averageshapvalue `stub'`meth'

                tempfile s_`stub'`meth'
                save `s_`stub'`meth''
            restore
        }
    }

    * merge the six method x measure columns and export
    preserve
        use `s_w_nn', clear
        foreach col in w_rf w_lasso e_nn e_rf e_lasso {
            merge 1:1 grp using `s_`col'', nogenerate
        }

        * row labels and F-test row order
        gen rowname = ""
        gen roworder = .
        replace rowname = "Census Division" if grp=="censdiv"
        replace roworder = 1                if grp=="censdiv"
        replace rowname = "Year"            if grp=="year"
        replace roworder = 2                if grp=="year"
        replace rowname = "Race"            if grp=="race"
        replace roworder = 3                if grp=="race"
        replace rowname = "Cohort"          if grp=="cohort"
        replace roworder = 4                if grp=="cohort"
        replace rowname = "Occupation"      if grp=="occ"
        replace roworder = 5                if grp=="occ"
        replace rowname = "Industry"        if grp=="ind"
        replace roworder = 6                if grp=="ind"
        replace rowname = "Education"       if grp=="edu"
        replace roworder = 7                if grp=="edu"
        replace rowname = "Age"             if grp=="age"
        replace roworder = 8                if grp=="age"
        replace rowname = "Tenure"          if grp=="tenure"
        replace roworder = 9                if grp=="tenure"
        sort roworder

        format w_nn w_rf w_lasso e_nn e_rf e_lasso %9.4f

        listtex rowname w_nn w_rf w_lasso e_nn e_rf e_lasso ///
            using "$OUTDIR/`outn'_shap_shares.tex", ///
            replace ///
            head("\begin{tabular}{lccc|ccc}" ///
                 "\hline\hline" ///
                 " & \multicolumn{3}{c|}{Hourly Wage} & \multicolumn{3}{c}{Annual Earnings} \\" ///
                 " & NN & RF & LASSO & NN & RF & LASSO \\" ///
                 "\hline") ///
            foot("\hline\hline" ///
                 "\end{tabular}") ///
            rstyle(tabular)
    restore
}




* ===========================================================================
* MEAN PREDICTED GAMMA/ALPHA BY DEMOGRAPHIC GROUP (combined tables)
*
* Carried from 7.1_OtherTables.do. The person-year fitted values were merged
* in the early data prep, so each combo just renames its own prediction
* columns to the generic names the table code uses.
*
* One table per earnings measure: rows = demographic categories in blocks
* (education, race, cohort, age bin, tenure bin); columns = Raw | OLS |
* LASSO | NN | RF | N for Gamma (left) and Alpha (right) with a vertical
* divider. Each side keeps its own N: the two outcomes have different
* estimation samples.
* ===========================================================================

foreach meas in wage earn {
    local sfx = cond("`meas'"=="earn","_fearn","")

    tempfile stk_gam stk_alph

    foreach o in gam alph {

        preserve
            keep personid year `o'_`meas' pred_nn_`o'_`meas' pred_rf_`o'_`meas' ///
                 pred_lasso_`o'_`meas' pred_ols_`o'_`meas' educat race cohort agebin tenurebin

            * The four models share one estimation sample per outcome
            keep if !missing(pred_nn_`o'_`meas')

            rename `o'_`meas'            pred_actual
            rename pred_ols_`o'_`meas'   pred_ols
            rename pred_nn_`o'_`meas'    pred_nn
            rename pred_rf_`o'_`meas'    pred_rf
            rename pred_lasso_`o'_`meas' pred_lasso

            tempfile mrg
            save `mrg', replace

            * ------- Group means for each demographic block, then stack -------

            foreach bvar in educat race cohort agebin tenurebin {

                if "`bvar'" == "educat"    local btitle "Education"
                if "`bvar'" == "race"      local btitle "Race"
                if "`bvar'" == "cohort"    local btitle "Cohort"
                if "`bvar'" == "agebin"    local btitle "Age Bin"
                if "`bvar'" == "tenurebin" local btitle "Tenure Bin"

                use `mrg', clear
                collapse (mean) pred_actual pred_ols pred_lasso pred_nn pred_rf (count) n=pred_actual, by(`bvar')
                drop if missing(`bvar')

                gen str30 block = "`btitle'"
                decode `bvar', gen(category)
                drop `bvar'

                tempfile blk_`bvar'
                save `blk_`bvar''
            }

            clear
            append using `blk_educat' `blk_race' `blk_cohort' `blk_agebin' `blk_tenurebin'
            save `stk_`o'', replace

        restore
    }

    * ------- Combined table: Gamma block columns | Alpha block columns -------

    preserve
        use `stk_alph', clear
        rename (pred_actual pred_ols pred_lasso pred_nn pred_rf n) ///
               (pred_actual_a pred_ols_a pred_lasso_a pred_nn_a pred_rf_a n_a)
        tempfile alph_wide
        save `alph_wide', replace

        use `stk_gam', clear
        rename (pred_actual pred_ols pred_lasso pred_nn pred_rf n) ///
               (pred_actual_g pred_ols_g pred_lasso_g pred_nn_g pred_rf_g n_g)

        * preserve the stacked block/category row order through the merge
        gen roworder = _n
        merge 1:1 block category using `alph_wide', nogenerate
        sort roworder
        drop roworder

        order block category pred_actual_g pred_ols_g pred_lasso_g pred_nn_g pred_rf_g n_g ///
              pred_actual_a pred_ols_a pred_lasso_a pred_nn_a pred_rf_a n_a

        * risk measures reported x 100 (the paper caption notes the scaling)
        foreach v in pred_actual_g pred_ols_g pred_lasso_g pred_nn_g pred_rf_g ///
                     pred_actual_a pred_ols_a pred_lasso_a pred_nn_a pred_rf_a {
            replace `v' = 100 * `v'
        }

        * group title printed once, on the first row of each block (compare
        * against an untouched copy: replace runs top-down, so block[_n-1]
        * would already be blanked and every other row would keep its title)
        gen str30 blockfull = block
        replace block = "" if _n > 1 & blockfull == blockfull[_n-1]
        drop blockfull

        format pred_actual_g pred_ols_g pred_lasso_g pred_nn_g pred_rf_g ///
               pred_actual_a pred_ols_a pred_lasso_a pred_nn_a pred_rf_a %9.2f
        format n_g n_a %12.0fc

        listtex block category pred_actual_g pred_ols_g pred_lasso_g pred_nn_g pred_rf_g n_g ///
                pred_actual_a pred_ols_a pred_lasso_a pred_nn_a pred_rf_a n_a ///
            using "$OUTDIR/gamma_alpha_pred_means`sfx'.tex", ///
            replace ///
            head("\begin{tabular}{llcccccc|cccccc}" ///
                 "\hline\hline" ///
                 " &  & \multicolumn{6}{c|}{Gamma} & \multicolumn{6}{c}{Alpha} \\" ///
                 "Group & Category & Raw & OLS & LASSO & NN & RF & N & Raw & OLS & LASSO & NN & RF & N \\" ///
                 "\hline") ///
            foot("\hline\hline" ///
                 "\end{tabular}") ///
            rstyle(tabular)
    restore
}




* ===========================================================================
* PREDICTED-RISK MATRICES: EDUCATION x AGE BIN
*
* Mean predicted value by education category (rows) and age bin (columns),
* one table per outcome x earnings measure x method (Actual, NN, RF, LASSO).
* Five age bins (22-61; the pipeline drops currentage > 61, so 62-69 is
* empty) are populated in both estimation samples; if one ever empties,
* the listtex below fails loudly on the missing column.
* ===========================================================================

foreach meas in wage earn {
    local sfx = cond("`meas'"=="earn","_fearn","")

    foreach o in gam alph {
        local outname = cond("`o'"=="gam","gamma","alpha")

        preserve
            keep `o'_`meas' pred_nn_`o'_`meas' pred_rf_`o'_`meas' ///
                 pred_lasso_`o'_`meas' educat agebin

            * The three models share one estimation sample per outcome
            keep if !missing(pred_nn_`o'_`meas')

            rename `o'_`meas'            pred_actual
            rename pred_nn_`o'_`meas'    pred_nn
            rename pred_rf_`o'_`meas'    pred_rf
            rename pred_lasso_`o'_`meas' pred_lasso

            tempfile mrg
            save `mrg', replace

            foreach m in actual nn rf lasso {

                use `mrg', clear
                collapse (mean) v = pred_`m', by(educat agebin)
                drop if missing(educat) | missing(agebin)
                reshape wide v, i(educat) j(agebin)

                sort educat
                decode educat, gen(category)
                order category v1 v2 v3 v4 v5
                drop educat

                * risk measures reported x 100 (the paper captions note the scaling)
                foreach v of varlist v1-v5 {
                    replace `v' = 100 * `v'
                }
                format v1 v2 v3 v4 v5 %9.2f

                listtex category v1 v2 v3 v4 v5 using "$OUTDIR/`outname'`sfx'_pred_matrix_`m'.tex", ///
                    replace ///
                    head("\begin{tabular}{lccccc}" ///
                         "\hline\hline" ///
                         " & \multicolumn{5}{c}{Age Bin} \\" ///
                         "Education & 22-29 & 30-37 & 38-45 & 46-53 & 54-61 \\" ///
                         "\hline") ///
                    foot("\hline\hline" ///
                         "\end{tabular}") ///
                    rstyle(tabular)
            }
        restore
    }
}




* ===========================================================================
* CHARACTERISTICS OF TOP AND BOTTOM RISK DECILES BY AGE
*
* Who has really high and really low risk? Within three broad age bins
* (22-33, 34-57, 58-61 with the current age-61 cap), the share of each demographic category among the
* top 10% and bottom 10% of risk, next to the within-bin average share.
*
* Individuals are first collapsed to one observation per person per age
* bin (category dummies become the person's share of years in the
* category). Hourly and annual are collapsed separately because their
* estimation samples differ. Deciles are computed WITHIN age bin.
*
* Gamma is sorted by ACTUAL risk only: out of sample every method's MSE
* ties the predict-the-mean baseline (see 6.6_MLperformance.py), so a
* predicted gamma ranking is not defensible. Alpha is sorted BOTH by the
* ensemble prediction (mean of the three methods' within-bin percentile
* ranks) and by actual risk, on the same estimation sample.
*
* Four panels: {gamma, alpha} x {hourly, annual}. Cells are percent shares.
* ===========================================================================


* --- Broad age bins (currentage is in natural units) ---

capture drop agebin3
gen agebin3 = .
replace agebin3 = 1 if currentage >= 22 & currentage <= 33
replace agebin3 = 2 if currentage >= 34 & currentage <= 57
replace agebin3 = 3 if currentage >= 58 & currentage <= 69


* --- Education category dummies (the other blocks' dummies exist already) ---

capture drop educat_dum*
tabulate educat, generate(educat_dum)


* --- Earnings quintile dummies (mirroring the stratified-means table) ---
* Hourly panels report the hourly wage quintile, annual panels the annual
* earnings quintile.

capture drop earnbin wagebin
xtile earnbin = realearn, nquantiles(5)
xtile wagebin = hwage, nquantiles(5)
label define earnbin_lbl 1 "1st Quintile" 2 "2nd Quintile" ///
    3 "3rd Quintile" 4 "4th Quintile" 5 "5th Quintile", replace
label values earnbin earnbin_lbl
label define wagebin_lbl 1 "1st Quintile" 2 "2nd Quintile" ///
    3 "3rd Quintile" 4 "4th Quintile" 5 "5th Quintile", replace
label values wagebin wagebin_lbl

capture drop earnbin_dum*
capture drop wagebin_dum*
tabulate earnbin, generate(earnbin_dum)
tabulate wagebin, generate(wagebin_dum)


* --- Row scaffold: table rows in order, with block titles and labels ---
* Dummy k of each set corresponds to the k-th lowest value of the source
* variable, so walking levelsof in order lines the labels up with the dummies.
* Two variants, differing only in the final quintile block: hourly panels
* (hr) end with the hourly wage quintile, annual panels (an) with the annual
* earnings quintile.

local rowvars_common educat_dum1 educat_dum2 educat_dum3 educat_dum4 educat_dum5 ///
    race_dum1 race_dum2 race_dum3 race_dum4 race_dum5 race_dum6 ///
    cohort_dum1 cohort_dum2 cohort_dum3 cohort_dum4 ///
    ten_dum1 ten_dum2 ten_dum3 ///
    censdiv_dum1 censdiv_dum2 censdiv_dum3 censdiv_dum4 censdiv_dum5 ///
    censdiv_dum6 censdiv_dum7 censdiv_dum8 censdiv_dum9 censdiv_dum10

local rowvars_hr `rowvars_common' wagebin_dum1 wagebin_dum2 wagebin_dum3 ///
    wagebin_dum4 wagebin_dum5
local rowvars_an `rowvars_common' earnbin_dum1 earnbin_dum2 earnbin_dum3 ///
    earnbin_dum4 earnbin_dum5

foreach mm in hr an {

    local qvar = cond("`mm'" == "hr", "wagebin", "earnbin")

    local nrow_`mm' = 0
    foreach bvar in educat race cohort tenurebin censdiv `qvar' {

        if "`bvar'" == "educat"    local btitle "Education"
        if "`bvar'" == "race"      local btitle "Race"
        if "`bvar'" == "cohort"    local btitle "Cohort"
        if "`bvar'" == "tenurebin" local btitle "Tenure Bin"
        if "`bvar'" == "censdiv"   local btitle "Census Division"
        if "`bvar'" == "wagebin"   local btitle "Hourly Wage Quintile"
        if "`bvar'" == "earnbin"   local btitle "Annual Earnings Quintile"

        levelsof `bvar', local(levels)
        foreach v of local levels {
            local ++nrow_`mm'
            local block_`mm'`nrow_`mm'' "`btitle'"
            local cat_`mm'`nrow_`mm'' : label (`bvar') `v'
        }
    }
}


* --------------------------------------------------------------------------
* GAMMA, HOURLY (sorted by actual risk)
* --------------------------------------------------------------------------

preserve
    keep if !missing(gam_wage)
    keep personid agebin3 gam_wage educat_dum* race_dum* cohort_dum* ///
         ten_dum* censdiv_dum* wagebin_dum*
    drop if missing(agebin3)

    * one observation per person per age bin
    collapse (mean) gam_wage educat_dum* race_dum* cohort_dum* ten_dum* ///
             censdiv_dum* wagebin_dum*, by(personid agebin3)

    * within-bin decile flags on actual risk
    egen p10_act = pctile(gam_wage), p(10) by(agebin3)
    egen p90_act = pctile(gam_wage), p(90) by(agebin3)
    gen bot_act = gam_wage <= p10_act
    gen top_act = gam_wage >= p90_act

    * fill the cell matrix: rows = categories, columns = bin x (All/Bot/Top)
    matrix R = J(`nrow_hr', 9, .)
    local col = 0
    forvalues b = 1/3 {
        foreach part in all bot top {

            if "`part'" == "all" local cond "agebin3 == `b'"
            if "`part'" == "bot" local cond "agebin3 == `b' & bot_act == 1"
            if "`part'" == "top" local cond "agebin3 == `b' & top_act == 1"

            local ++col
            local row = 0
            foreach v of local rowvars_hr {
                local ++row
                quietly summarize `v' if `cond'
                matrix R[`row', `col'] = 100 * r(mean)
            }
        }
    }

    * build the table dataset and export
    clear
    svmat R, names(c)
    gen str30 block = ""
    gen str45 category = ""
    forvalues i = 1/`nrow_hr' {
        replace block = "`block_hr`i''" in `i'
        replace category = "`cat_hr`i''" in `i'
    }
    order block category

    * group title printed once, on the first row of each block (compare
    * against an untouched copy: replace runs top-down, so block[_n-1]
    * would already be blanked and every other row would keep its title)
    gen str30 blockfull = block
    replace block = "" if _n > 1 & blockfull == blockfull[_n-1]
    drop blockfull

    format c1-c9 %9.1f

    listtex block category c1 c2 c3 c4 c5 c6 c7 c8 c9 ///
        using "$OUTDIR/gamma_deciles.tex", ///
        replace ///
        head("\begin{tabular}{llccc|ccc|ccc}" ///
             "\hline\hline" ///
             " & & \multicolumn{3}{c|}{Ages 22-33} & \multicolumn{3}{c|}{Ages 34-57} & \multicolumn{3}{c}{Ages 58-61} \\" ///
             " & & All & Bottom 10\% & Top 10\% & All & Bottom 10\% & Top 10\% & All & Bottom 10\% & Top 10\% \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
restore


* --------------------------------------------------------------------------
* GAMMA, ANNUAL (sorted by actual risk)
* --------------------------------------------------------------------------

preserve
    keep if !missing(gam_earn)
    keep personid agebin3 gam_earn educat_dum* race_dum* cohort_dum* ///
         ten_dum* censdiv_dum* earnbin_dum*
    drop if missing(agebin3)

    collapse (mean) gam_earn educat_dum* race_dum* cohort_dum* ten_dum* ///
             censdiv_dum* earnbin_dum*, by(personid agebin3)

    egen p10_act = pctile(gam_earn), p(10) by(agebin3)
    egen p90_act = pctile(gam_earn), p(90) by(agebin3)
    gen bot_act = gam_earn <= p10_act
    gen top_act = gam_earn >= p90_act

    matrix R = J(`nrow_an', 9, .)
    local col = 0
    forvalues b = 1/3 {
        foreach part in all bot top {

            if "`part'" == "all" local cond "agebin3 == `b'"
            if "`part'" == "bot" local cond "agebin3 == `b' & bot_act == 1"
            if "`part'" == "top" local cond "agebin3 == `b' & top_act == 1"

            local ++col
            local row = 0
            foreach v of local rowvars_an {
                local ++row
                quietly summarize `v' if `cond'
                matrix R[`row', `col'] = 100 * r(mean)
            }
        }
    }

    clear
    svmat R, names(c)
    gen str30 block = ""
    gen str45 category = ""
    forvalues i = 1/`nrow_an' {
        replace block = "`block_an`i''" in `i'
        replace category = "`cat_an`i''" in `i'
    }
    order block category

    * group title printed once, on the first row of each block (compare
    * against an untouched copy: replace runs top-down, so block[_n-1]
    * would already be blanked and every other row would keep its title)
    gen str30 blockfull = block
    replace block = "" if _n > 1 & blockfull == blockfull[_n-1]
    drop blockfull

    format c1-c9 %9.1f

    listtex block category c1 c2 c3 c4 c5 c6 c7 c8 c9 ///
        using "$OUTDIR/gamma_fearn_deciles.tex", ///
        replace ///
        head("\begin{tabular}{llccc|ccc|ccc}" ///
             "\hline\hline" ///
             " & & \multicolumn{3}{c|}{Ages 22-33} & \multicolumn{3}{c|}{Ages 34-57} & \multicolumn{3}{c}{Ages 58-61} \\" ///
             " & & All & Bottom 10\% & Top 10\% & All & Bottom 10\% & Top 10\% & All & Bottom 10\% & Top 10\% \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
restore


* --------------------------------------------------------------------------
* ALPHA, HOURLY (sorted by the ensemble prediction AND by actual risk)
* --------------------------------------------------------------------------

preserve
    * estimation sample, so both sorts run on the same people
    keep if !missing(pred_nn_alph_wage)
    keep personid agebin3 alph_wage pred_nn_alph_wage pred_rf_alph_wage ///
         pred_lasso_alph_wage educat_dum* race_dum* cohort_dum* ten_dum* ///
         censdiv_dum* wagebin_dum*
    drop if missing(agebin3)

    collapse (mean) alph_wage pred_nn_alph_wage pred_rf_alph_wage ///
             pred_lasso_alph_wage educat_dum* race_dum* cohort_dum* ///
             ten_dum* censdiv_dum* wagebin_dum*, by(personid agebin3)

    * ensemble prediction: mean of the three within-bin percentile ranks
    egen rank_nn    = rank(pred_nn_alph_wage),    by(agebin3)
    egen rank_rf    = rank(pred_rf_alph_wage),    by(agebin3)
    egen rank_lasso = rank(pred_lasso_alph_wage), by(agebin3)
    gen pred_score = (rank_nn + rank_rf + rank_lasso) / 3

    * within-bin decile flags for both sorts
    egen p10_pred = pctile(pred_score), p(10) by(agebin3)
    egen p90_pred = pctile(pred_score), p(90) by(agebin3)
    gen bot_pred = pred_score <= p10_pred
    gen top_pred = pred_score >= p90_pred

    egen p10_act = pctile(alph_wage), p(10) by(agebin3)
    egen p90_act = pctile(alph_wage), p(90) by(agebin3)
    gen bot_act = alph_wage <= p10_act
    gen top_act = alph_wage >= p90_act

    * columns per bin: All, Bottom (Pred, Act), Top (Pred, Act)
    matrix R = J(`nrow_hr', 15, .)
    local col = 0
    forvalues b = 1/3 {
        foreach part in all botp bota topp topa {

            if "`part'" == "all"  local cond "agebin3 == `b'"
            if "`part'" == "botp" local cond "agebin3 == `b' & bot_pred == 1"
            if "`part'" == "bota" local cond "agebin3 == `b' & bot_act == 1"
            if "`part'" == "topp" local cond "agebin3 == `b' & top_pred == 1"
            if "`part'" == "topa" local cond "agebin3 == `b' & top_act == 1"

            local ++col
            local row = 0
            foreach v of local rowvars_hr {
                local ++row
                quietly summarize `v' if `cond'
                matrix R[`row', `col'] = 100 * r(mean)
            }
        }
    }

    clear
    svmat R, names(c)
    gen str30 block = ""
    gen str45 category = ""
    forvalues i = 1/`nrow_hr' {
        replace block = "`block_hr`i''" in `i'
        replace category = "`cat_hr`i''" in `i'
    }
    order block category

    * group title printed once, on the first row of each block (compare
    * against an untouched copy: replace runs top-down, so block[_n-1]
    * would already be blanked and every other row would keep its title)
    gen str30 blockfull = block
    replace block = "" if _n > 1 & blockfull == blockfull[_n-1]
    drop blockfull

    format c1-c15 %9.1f

    listtex block category c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 ///
        using "$OUTDIR/alpha_deciles.tex", ///
        replace ///
        head("\begin{tabular}{llccccc|ccccc|ccccc}" ///
             "\hline\hline" ///
             " & & \multicolumn{5}{c|}{Ages 22-33} & \multicolumn{5}{c|}{Ages 34-57} & \multicolumn{5}{c}{Ages 58-61} \\" ///
             " & & All & \multicolumn{2}{c}{Bottom 10\%} & \multicolumn{2}{c|}{Top 10\%} & All & \multicolumn{2}{c}{Bottom 10\%} & \multicolumn{2}{c|}{Top 10\%} & All & \multicolumn{2}{c}{Bottom 10\%} & \multicolumn{2}{c}{Top 10\%} \\" ///
             " & & & Pred & Raw & Pred & Raw & & Pred & Raw & Pred & Raw & & Pred & Raw & Pred & Raw \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
restore


* --------------------------------------------------------------------------
* ALPHA, ANNUAL (sorted by the ensemble prediction AND by actual risk)
* --------------------------------------------------------------------------

preserve
    keep if !missing(pred_nn_alph_earn)
    keep personid agebin3 alph_earn pred_nn_alph_earn pred_rf_alph_earn ///
         pred_lasso_alph_earn educat_dum* race_dum* cohort_dum* ten_dum* ///
         censdiv_dum* earnbin_dum*
    drop if missing(agebin3)

    collapse (mean) alph_earn pred_nn_alph_earn pred_rf_alph_earn ///
             pred_lasso_alph_earn educat_dum* race_dum* cohort_dum* ///
             ten_dum* censdiv_dum* earnbin_dum*, by(personid agebin3)

    egen rank_nn    = rank(pred_nn_alph_earn),    by(agebin3)
    egen rank_rf    = rank(pred_rf_alph_earn),    by(agebin3)
    egen rank_lasso = rank(pred_lasso_alph_earn), by(agebin3)
    gen pred_score = (rank_nn + rank_rf + rank_lasso) / 3

    egen p10_pred = pctile(pred_score), p(10) by(agebin3)
    egen p90_pred = pctile(pred_score), p(90) by(agebin3)
    gen bot_pred = pred_score <= p10_pred
    gen top_pred = pred_score >= p90_pred

    egen p10_act = pctile(alph_earn), p(10) by(agebin3)
    egen p90_act = pctile(alph_earn), p(90) by(agebin3)
    gen bot_act = alph_earn <= p10_act
    gen top_act = alph_earn >= p90_act

    matrix R = J(`nrow_an', 15, .)
    local col = 0
    forvalues b = 1/3 {
        foreach part in all botp bota topp topa {

            if "`part'" == "all"  local cond "agebin3 == `b'"
            if "`part'" == "botp" local cond "agebin3 == `b' & bot_pred == 1"
            if "`part'" == "bota" local cond "agebin3 == `b' & bot_act == 1"
            if "`part'" == "topp" local cond "agebin3 == `b' & top_pred == 1"
            if "`part'" == "topa" local cond "agebin3 == `b' & top_act == 1"

            local ++col
            local row = 0
            foreach v of local rowvars_an {
                local ++row
                quietly summarize `v' if `cond'
                matrix R[`row', `col'] = 100 * r(mean)
            }
        }
    }

    clear
    svmat R, names(c)
    gen str30 block = ""
    gen str45 category = ""
    forvalues i = 1/`nrow_an' {
        replace block = "`block_an`i''" in `i'
        replace category = "`cat_an`i''" in `i'
    }
    order block category

    * group title printed once, on the first row of each block (compare
    * against an untouched copy: replace runs top-down, so block[_n-1]
    * would already be blanked and every other row would keep its title)
    gen str30 blockfull = block
    replace block = "" if _n > 1 & blockfull == blockfull[_n-1]
    drop blockfull

    format c1-c15 %9.1f

    listtex block category c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 ///
        using "$OUTDIR/alpha_fearn_deciles.tex", ///
        replace ///
        head("\begin{tabular}{llccccc|ccccc|ccccc}" ///
             "\hline\hline" ///
             " & & \multicolumn{5}{c|}{Ages 22-33} & \multicolumn{5}{c|}{Ages 34-57} & \multicolumn{5}{c}{Ages 58-61} \\" ///
             " & & All & \multicolumn{2}{c}{Bottom 10\%} & \multicolumn{2}{c|}{Top 10\%} & All & \multicolumn{2}{c}{Bottom 10\%} & \multicolumn{2}{c|}{Top 10\%} & All & \multicolumn{2}{c}{Bottom 10\%} & \multicolumn{2}{c}{Top 10\%} \\" ///
             " & & & Pred & Raw & Pred & Raw & & Pred & Raw & Pred & Raw & & Pred & Raw & Pred & Raw \\" ///
             "\hline") ///
        foot("\hline\hline" ///
             "\end{tabular}") ///
        rstyle(tabular)
restore




* ===========================================================================
* APPENDIX: OCC/IND SHAP RANK TABLES AND CROSS-METHOD RANK PLOTS
*
* Carried from 7.1_OtherTables.do: LASSO / NN / RF SHAP importance rank per
* occupation or industry, per risk measure x earnings measure (8 tables),
* each followed by the three pairwise cross-method rank scatters
* (LASSO vs NN, NN vs RF, LASSO vs RF -- 24 PDFs).
* ===========================================================================

foreach dim in occ ind {

    if "`dim'" == "occ" {
        local csvstem  "occupation"
        local codevar  "occupationcode"
        local idvar    "occ"
        local collabel "Occupation"
    }
    else {
        local csvstem  "industry"
        local codevar  "industrycode"
        local idvar    "twoind"
        local collabel "Industry"
    }

    foreach outn in gamma alpha {
        foreach meas in fhwage fearn {
            local sfx = cond("`meas'"=="fearn","_fearn","")

            * one SHAP rank tempfile per model (destring is a no-op note for
            * the NN files, whose codes are already numeric)
            foreach mod in lasso nn rf {
                if "`mod'" == "lasso"   local pre "Lasso_"
                else if "`mod'" == "rf" local pre "RF_"
                else                    local pre ""

                preserve
                    import delimited using "$SHAPDIR/`pre'`csvstem'_shap_`outn'`sfx'.csv", clear
                    rename `codevar' code
                    rename averageshapvalue avg_shap
                    destring code, replace force
                    * QUIRK -- LASSO zero-SHAP ties: LASSO drops (zeroes out)
                    * a large share of categories, so their SHAP values tie
                    * at exactly 0 (e.g. 28 of 78 occupations). Ranks within
                    * that zero group carry no importance information -- any
                    * ordering is arbitrary. Stata's sort breaks ties randomly,
                    * which made those ranks (and the LASSO columns of the
                    * rank tables/plots) shuffle on every run, so the category
                    * code is used as an explicit tie-break: reproducible, but
                    * the tail of the LASSO ranking is still just code order,
                    * not a real ranking. NN/RF SHAP values are continuous and
                    * effectively never tie, so their ranks are unaffected.
                    gsort -avg_shap code
                    gen `mod'_shap_order = _n
                    keep code `mod'_shap_order
                    tempfile rk_`mod'
                    save `rk_`mod'', replace
                restore
            }

            * codes + labels from the analysis data, merge the ranks, export
            preserve
                local vl : value label `idvar'
                keep `idvar'
                duplicates drop `idvar', force
                rename `idvar' code
                if "`vl'" != "" {
                    label values code `vl'
                    decode code, gen(code_label)
                }
                else {
                    tostring code, gen(code_label) format(%9.0g)
                }

                merge 1:1 code using `rk_lasso', nogenerate
                merge 1:1 code using `rk_nn',    nogenerate
                merge 1:1 code using `rk_rf',    nogenerate

                label var code_label       "`collabel'"
                label var lasso_shap_order "LASSO SHAP Order"
                label var nn_shap_order    "NN SHAP Order"
                label var rf_shap_order    "Random Forest SHAP Order"

                gsort nn_shap_order lasso_shap_order code_label

                listtex code_label lasso_shap_order nn_shap_order rf_shap_order ///
                    using "$OUTDIR/`outn'`sfx'_lasso_`dim'_selection.tex", ///
                    replace ///
                    head("\begin{tabular}{lccc}" ///
                         "\hline\hline" ///
                         "`collabel' & LASSO SHAP Order & NN SHAP Order & RF SHAP Order \\" ///
                         "\hline") ///
                    foot("\hline\hline" ///
                         "\end{tabular}") ///
                    rstyle(tabular)

                * Scatter plots comparing SHAP rankings across methods
                local outtitle = cond("`outn'"=="gamma","Gamma","Alpha")

                quietly count if !missing(lasso_shap_order) & !missing(nn_shap_order)
                local maxr = r(N)
                twoway (scatter nn_shap_order lasso_shap_order, mcolor(navy)) ///
                       (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
                    title("`outtitle' v `collabel': LASSO vs NN") ///
                    xtitle("LASSO SHAP Rank") ytitle("NN SHAP Rank") ///
                    legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) ///
                    xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
                graph export "$OUTDIR/`outn'`sfx'_`dim'_rank_lasso_vs_nn.pdf", replace

                quietly count if !missing(nn_shap_order) & !missing(rf_shap_order)
                local maxr = r(N)
                twoway (scatter rf_shap_order nn_shap_order, mcolor(navy)) ///
                       (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
                    title("`outtitle' v `collabel': NN vs RF") ///
                    xtitle("NN SHAP Rank") ytitle("Random Forest SHAP Rank") ///
                    legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) ///
                    xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
                graph export "$OUTDIR/`outn'`sfx'_`dim'_rank_nn_vs_rf.pdf", replace

                quietly count if !missing(lasso_shap_order) & !missing(rf_shap_order)
                local maxr = r(N)
                twoway (scatter rf_shap_order lasso_shap_order, mcolor(navy)) ///
                       (function y=x, range(1 `maxr') lcolor(gs8) lpattern(dash)), ///
                    title("`outtitle' v `collabel': LASSO vs RF") ///
                    xtitle("LASSO SHAP Rank") ytitle("Random Forest SHAP Rank") ///
                    legend(off) xscale(range(0 `maxr')) yscale(range(0 `maxr')) ///
                    xlabel(0(10)`maxr') ylabel(0(10)`maxr') xsize(5) ysize(5) plotregion(margin(zero))
                graph export "$OUTDIR/`outn'`sfx'_`dim'_rank_lasso_vs_rf.pdf", replace
            restore
        }
    }
}




