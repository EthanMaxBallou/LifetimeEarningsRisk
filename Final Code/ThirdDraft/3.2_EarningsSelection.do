
*** 3.2_EarningsSelection.do
***
*** In-between exercise, run before 4_GamAlphaCalc.do: which variables belong
*** in the first-stage age-earnings-profile (growth) regressions?
***
*** Builds the raw z-year differences in log earnings, Gz = Fz.y - y, for even
*** horizons z = 2, 4, ..., 34 (odd z dropped for the biennial-era parity
*** confound; z > 35 dropped), bins them into three horizon groups, and runs
*** two selection methods separately in each bin, for both earnings measures:
*** set-grouped backward stepwise (pr = .1, the 7_Tables.do machinery) and
*** lasso with the plugin lambda. The z dummies are locked into every model
*** (stepwise lockterm1 / lasso always-include); everything else competes.
***
*** Design notes:
***   - Candidate sets = the variables in the current first stage of
***     4_GamAlphaCalc.do, de-duplicated, with education (educwrths)
***     replacing the composite group variable: educwrths, postgrad, race,
***     OLF, unemp, student, occ, twoind, tenurebin, censdiv, year, agebin4.
***   - Age enters as agebin4 only. The first stage also has i.currentage,
***     but a full currentage dummy set nests agebin4 exactly (each agebin4
***     dummy is a sum of currentage dummies), so offering both would make
***     the grouped stepwise tie-break arbitrarily.
***   - With 40k-360k observations per bin, stepwise at pr(.1) is permissive;
***     the plugin-lambda lasso is the strict end (selection-consistent,
***     heteroskedasticity-robust, deterministic). CV lasso is deliberately
***     avoided: it tunes for prediction and over-selects. Lasso selects
***     individual dummies, not sets: read set relevance from how many of
***     a set's dummies survive (lassocoef after each fit).
***
*** A final stage computes gamma and alpha from the RAW differences (no
*** first-stage residualization), consolidates them per person-year with the
*** 5_MixedRegConsolidate.do mixed models, and runs the same lasso and
*** F-test machinery on them (one regression per outcome x measure).
***
*** Output: OtherOutput/ThirdDraft/3.2_EarningsSelection.log, plus two
*** summary tables (3.2_stepwise_selection.tex, 3.2_lasso_selection.tex),
*** an F-test table (3.2_ftest.tex), and the raw gamma/alpha analogues
*** (3.2_gamalpha_lasso_selection.tex, 3.2_gamalpha_ftest.tex).
*** Nothing is saved to disk; FullData_CombinedwithTEN.dta is not re-saved.


clear all


***********************************************************************
**                                                                   **
** LOAD AND PANEL SETUP                                              **
**                                                                   **
***********************************************************************

use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", clear

xtset personid year


***********************************************************************
**                                                                   **
** AGE AND TENURE BINS                                               **
** Same definitions as the top of 4_GamAlphaCalc.do. Regenerated     **
** here (not read from the dta) so this file runs before file 4 on   **
** a clean pipeline pass. Not saved back.                            **
**                                                                   **
***********************************************************************

* Tenure bins (tenure is in whole years): 0-1 (reference), 2-5, 6+
* Unemployed are assigned to the 0-1 reference bin regardless of tenure.
capture drop tenurebin
gen tenurebin = .
replace tenurebin = 1 if tenure>=0 & tenure<=1
replace tenurebin = 2 if tenure>=2 & tenure<=5
replace tenurebin = 3 if tenure>=6 & tenure!=.
replace tenurebin = 1 if unemp==1

* Fine age bins: twelve 4-year bins spanning 22-69 (46-49 = reference later)
capture drop agebin4
gen agebin4 = floor((currentage-22)/4) + 1 if currentage>=22 & currentage<=69


***********************************************************************
**                                                                   **
** SLIM THE DATASET AND BUILD THE DIFFERENCES                        **
** Only the variables used below are kept, so the reshape stays      **
** small. Sample mirrors 4_GamAlphaCalc.do.                          **
**                                                                   **
***********************************************************************

keep personid year fearn fhwage educwrths postgrad race OLF unemp student ///
     occ twoind tenurebin censdiv agebin4

drop if fearn==. & fhwage==.

* Even horizons only, 2-34: generating them directly implements the
* drop-odd-z and drop-z>35 rules.
forvalues z=2(2)34 {
	gen G`z'_fearn  = F`z'.fearn  - fearn  if F`z'.fearn !=. & fearn !=.
	gen G`z'_fhwage = F`z'.fhwage - fhwage if F`z'.fhwage!=. & fhwage!=.
}

* One row per person-year-horizon
reshape long G@_fearn G@_fhwage, i(personid year) j(z)

label variable z        "horizon (years ahead)"
label variable G_fearn  "z-year change in fearn (t to t+z)"
label variable G_fhwage "z-year change in fhwage (t to t+z)"

drop if G_fearn==. & G_fhwage==.

compress


***********************************************************************
**                                                                   **
** HORIZON BINS                                                      **
** Three bins: short 2-8, medium 10-22, long 24-34.                  **
**                                                                   **
***********************************************************************

gen zbin = .
replace zbin = 1 if z>=2  & z<=8
replace zbin = 2 if z>=10 & z<=22
replace zbin = 3 if z>=24 & z<=34

label define zbin_lbl 1 "z 2-8" 2 "z 10-22" 3 "z 24-34", replace
label values zbin zbin_lbl
label variable zbin "Horizon bin for the selection regressions"


***********************************************************************
**                                                                   **
** DUMMY SETS FOR STEPWISE                                           **
** stepwise cannot take i. factor notation, so dummy sets are        **
** pre-built (7_Tables.do convention). Sets are grouped with         **
** parentheses in the stepwise varlist so a whole set is added or    **
** dropped as a unit. agebin4 gets an explicit list below so the     **
** 46-49 reference bin (dum7) stays out; tenure omits ten_dum1       **
** (0-1); the other sets keep all levels and regress drops one.      **
**                                                                   **
***********************************************************************

tabulate educwrths, generate(educ_dum)
tabulate race,      generate(race_dum)
tabulate occ,       generate(occ_dum)
tabulate twoind,    generate(twoind_dum)
tabulate tenurebin, generate(ten_dum)
tabulate censdiv,   generate(censdiv_dum)
tabulate year,      generate(year_dum)
tabulate agebin4,   generate(agebin4_dum)

* Interaction dummies for the lasso/F-tests (NOT stepwise): occ x tenure
* and agebin4 x tenure, matching the interactions the file-4 first stage
* imposes. Pure products of the main-effect dummies; tenure 0-1 stays the
* reference (only ten_dum2/ten_dum3 enter, as with the main effects).
* Prefixes are chosen so the occ_dum*/twoind_dum*/censdiv_dum*/year_dum*
* wildcards in the fraction-counting loops cannot swallow them. All-zero
* (empty cell) columns are dropped, so the fraction denominators below are
* counted from what survives rather than hard-coded.
unab OCCDUMS : occ_dum*
foreach od of local OCCDUMS {
	local i = substr("`od'", 8, .)
	forvalues k = 2/3 {
		gen byte occten_d`i'_`k' = `od' * ten_dum`k'
	}
}
forvalues i = 1/12 {
	capture confirm variable agebin4_dum`i'
	if !_rc {
		forvalues k = 2/3 {
			gen byte ageten_d`i'_`k' = agebin4_dum`i' * ten_dum`k'
		}
	}
}
foreach v of varlist occten_d* ageten_d* {
	quietly summarize `v', meanonly
	if r(max) == 0 drop `v'
}
unab OCCTENLIST : occten_d*
unab AGETENLIST : ageten_d*
local NOCCTEN_A : word count `OCCTENLIST'
local NAGETEN_A : word count `AGETENLIST'

* Candidate terms shared by every regression. z dummies are prepended
* inside the loop (they differ by bin) and locked in via lockterm1.
* No interaction dummies here: stepwise keeps its original candidate sets.
local CANDIDATES "(educ_dum*) postgrad (race_dum*) OLF unemp student (occ_dum*) (twoind_dum*) (ten_dum2 ten_dum3) (censdiv_dum*) (year_dum*) (agebin4_dum1 agebin4_dum2 agebin4_dum3 agebin4_dum4 agebin4_dum5 agebin4_dum6 agebin4_dum8 agebin4_dum9 agebin4_dum10 agebin4_dum11 agebin4_dum12)"

* Same list, unparenthesized, for lasso: in lasso syntax parentheses mean
* ALWAYS INCLUDE (only the z dummies get that), and lasso selects
* individual dummies rather than whole sets. The interaction dummies are
* lasso candidates too.
local LASSOCANDS "educ_dum* postgrad race_dum* OLF unemp student occ_dum* twoind_dum* ten_dum2 ten_dum3 censdiv_dum* year_dum* agebin4_dum1 agebin4_dum2 agebin4_dum3 agebin4_dum4 agebin4_dum5 agebin4_dum6 agebin4_dum8 agebin4_dum9 agebin4_dum10 agebin4_dum11 agebin4_dum12 occten_d* ageten_d*"

* testparm argument for each of the 14 F-test table rows. The F-test
* model uses the same sets of controls but in i.() factor notation, so
* each set carries a proper reference category and the joint F per set
* is well-defined (the joint F is invariant to which level is the base).
local TP1  "i.educwrths"
local TP2  "postgrad"
local TP3  "i.race"
local TP4  "OLF"
local TP5  "unemp"
local TP6  "student"
local TP7  "i.occ"
local TP8  "i.twoind"
local TP9  "i.tenurebin"
local TP10 "i.censdiv"
local TP11 "i.year"
local TP12 "i.agebin4"
local TP13 "i.occ#i.tenurebin"
local TP14 "i.agebin4#i.tenurebin"

* F-statistics and p-values per set x run; columns 1-3 = fearn bins 1-3,
* columns 4-6 = fhwage bins 1-3 (same mapping as the summary tables)
matrix FT  = J(14, 6, .)
matrix FTP = J(14, 6, .)


***********************************************************************
**                                                                   **
** SELECTION REGRESSIONS                                             **
** For each horizon bin x earnings measure:                          **
**   1. backward stepwise at pr(.1), z dummies locked in             **
**   2. lasso with the plugin lambda (the selection-consistent,      **
**      heteroskedasticity-robust choice; stricter than CV, which    **
**      tunes for prediction and over-selects), z dummies always     **
**      included; lassocoef lists what survived                      **
**                                                                   **
***********************************************************************

capture mkdir "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/ThirdDraft"
capture log close earnsel
log using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/ThirdDraft/3.2_EarningsSelection.log", ///
	replace text name(earnsel)

* Record the exact bin sizes
tabulate z zbin

forvalues b = 1/3 {

	preserve
	keep if zbin == `b'

	* z dummies for this bin's horizons; first level is the reference
	tabulate z, generate(z_dum)
	drop z_dum1

	foreach x in fearn fhwage {

		stepwise, pr(.1) lockterm1: regress G_`x' (z_dum*) `CANDIDATES'
		local swsel_`b'_`x' : colnames e(b)

		lasso linear G_`x' (z_dum*) `LASSOCANDS', selection(plugin)
		lassocoef
		local lasel_`b'_`x' "`e(allvars_sel)'"

		* F-tests per control set: same sets of controls, but in i.()
		* factor notation (references handled cleanly), one regression
		* per run and a testparm per set
		local col = cond("`x'"=="fearn", `b', 3+`b')

		quietly regress G_`x' z_dum* i.educwrths postgrad i.race OLF ///
			unemp student i.occ i.twoind i.tenurebin i.censdiv ///
			i.year i.agebin4 i.occ#i.tenurebin i.agebin4#i.tenurebin

		forvalues s = 1/14 {
			quietly testparm `TP`s''
			matrix FT[`s', `col']  = r(F)
			matrix FTP[`s', `col'] = r(p)
		}

	}

	restore
}

log close earnsel














***********************************************************************
**                                                                   **
** SELECTION SUMMARY TABLES                                          **
** Two .tex tables built from the runs above (after the log closes,  **
** so the log stays clean). Columns c1-c3 = annual earnings bins     **
** z 5-8 / 10-22 / 24-34; c4-c6 = the same bins for hourly wage.     **
** Row lists are fixed, not dynamic.                                 **
**                                                                   **
***********************************************************************

local OUT "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/ThirdDraft"


* ---------- Stepwise table: control sets in or out ----------

local SETSTUBS  "educ_dum postgrad race_dum OLF unemp student occ_dum twoind_dum ten_dum censdiv_dum year_dum agebin4_dum"
local SETLABELS `""Education" "Postgrad" "Race" "OLF" "Unemployed" "Student" "Occupation" "Industry" "Tenure" "Census Division" "Year" "Age Bin""'

clear
set obs 12
gen str40 varlabel = ""
forvalues c = 1/6 {
	gen str12 c`c' = ""
}

forvalues s = 1/12 {
	local stub : word `s' of `SETSTUBS'
	local lab  : word `s' of `SETLABELS'
	quietly replace varlabel = `"`lab'"' in `s'

	* a set is selected if any of its dummies survives in e(b)
	local c = 0
	foreach x in fearn fhwage {
		forvalues b = 1/3 {
			local ++c
			foreach v of local swsel_`b'_`x' {
				if strmatch("`v'", "`stub'*") {
					quietly replace c`c' = "\checkmark" in `s'
					continue, break
				}
			}
		}
	}
}

listtex varlabel c1 c2 c3 c4 c5 c6 using "`OUT'/3.2_stepwise_selection.tex", ///
	replace ///
	head("\begin{tabular}{lccc|ccc}" ///
	     "\hline\hline" ///
	     " & \multicolumn{3}{c|}{Annual Earnings} & \multicolumn{3}{c}{Hourly Wage} \\" ///
	     "Control set & z 2-8 & z 10-22 & z 24-34 & z 2-8 & z 10-22 & z 24-34 \\" ///
	     "\hline") ///
	foot("\hline\hline" ///
	     "\multicolumn{7}{l}{\footnotesize Backward stepwise, sets grouped, pr(.1); z dummies locked in.} \\" ///
	     "\end{tabular}") ///
	rstyle(tabular)


* ---------- Lasso table: individual variables (occ/ind/year as counts) ----------

* Fixed row list: lvar#/llab# pairs. Regular blocks are spelled out with
* forvalues, but the row count is fixed (65 individual rows + 3 count rows).
local r = 0

local EDUCLABELS `""HS Dropout" "HS Graduate" "Some College" "College Graduate""'
forvalues k = 1/4 {
	local ++r
	local lvar`r' "educ_dum`k'"
	local llab`r' : word `k' of `EDUCLABELS'
}

local ++r
local lvar`r' "postgrad"
local llab`r' "Postgrad"
local ++r
local lvar`r' "OLF"
local llab`r' "OLF"
local ++r
local lvar`r' "unemp"
local llab`r' "Unemployed"
local ++r
local lvar`r' "student"
local llab`r' "Student"

local RACELABELS `""White" "Black" "Native American" "Asian or Pacific Islander" "Latino" "Other or Unknown""'
forvalues k = 1/6 {
	local ++r
	local lvar`r' "race_dum`k'"
	local llab`r' : word `k' of `RACELABELS'
}

local ++r
local lvar`r' "ten_dum2"
local llab`r' "Tenure 2-5"
local ++r
local lvar`r' "ten_dum3"
local llab`r' "Tenure 6+"

* agebin4: bin k covers ages 22+4(k-1) to 25+4(k-1); bin 7 (46-49) is the
* omitted reference and gets no row
foreach k in 1 2 3 4 5 6 8 9 10 11 12 {
	local lo = 22 + 4*(`k'-1)
	local ++r
	local lvar`r' "agebin4_dum`k'"
	local llab`r' "Age `lo'-`=`lo'+3'"
}

local NIND = `r'

clear
set obs `=`NIND'+6'
gen str40 varlabel = ""
forvalues c = 1/6 {
	gen str12 c`c' = ""
}

forvalues i = 1/`NIND' {
	quietly replace varlabel = `"`llab`i''"' in `i'
}
quietly replace varlabel = "Census Division (of 10)" in `=`NIND'+1'
quietly replace varlabel = "Occupation (of 79)"      in `=`NIND'+2'
quietly replace varlabel = "Industry (of 34)"        in `=`NIND'+3'
quietly replace varlabel = "Year (of 37)"            in `=`NIND'+4'
quietly replace varlabel = "Occupation x Tenure (of `NOCCTEN_A')" in `=`NIND'+5'
quietly replace varlabel = "Age Bin x Tenure (of `NAGETEN_A')"    in `=`NIND'+6'

local c = 0
foreach x in fearn fhwage {
	forvalues b = 1/3 {
		local ++c
		local sel "`lasel_`b'_`x''"

		forvalues i = 1/`NIND' {
			local pos : list posof "`lvar`i''" in sel
			if `pos' > 0 quietly replace c`c' = "\checkmark" in `i'
		}

		local ncd  = 0
		local nocc = 0
		local nind = 0
		local nyr  = 0
		local noct = 0
		local nagt = 0
		foreach v of local sel {
			if strmatch("`v'", "censdiv_dum*") local ++ncd
			if strmatch("`v'", "occ_dum*")     local ++nocc
			if strmatch("`v'", "twoind_dum*")  local ++nind
			if strmatch("`v'", "year_dum*")    local ++nyr
			if strmatch("`v'", "occten_d*")    local ++noct
			if strmatch("`v'", "ageten_d*")    local ++nagt
		}
		quietly replace c`c' = "`ncd'/10"  in `=`NIND'+1'
		quietly replace c`c' = "`nocc'/79" in `=`NIND'+2'
		quietly replace c`c' = "`nind'/34" in `=`NIND'+3'
		quietly replace c`c' = "`nyr'/37"  in `=`NIND'+4'
		quietly replace c`c' = "`noct'/`NOCCTEN_A'" in `=`NIND'+5'
		quietly replace c`c' = "`nagt'/`NAGETEN_A'" in `=`NIND'+6'
	}
}

listtex varlabel c1 c2 c3 c4 c5 c6 using "`OUT'/3.2_lasso_selection.tex", ///
	replace ///
	head("\begin{tabular}{lccc|ccc}" ///
	     "\hline\hline" ///
	     " & \multicolumn{3}{c|}{Annual Earnings} & \multicolumn{3}{c}{Hourly Wage} \\" ///
	     "Variable & z 2-8 & z 10-22 & z 24-34 & z 2-8 & z 10-22 & z 24-34 \\" ///
	     "\hline") ///
	foot("\hline\hline" ///
	     "\multicolumn{7}{l}{\footnotesize Lasso, plugin lambda; z dummies always included.} \\" ///
	     "\multicolumn{7}{l}{\footnotesize Age 46-49 and tenure 0-1 are omitted reference categories.} \\" ///
	     "\end{tabular}") ///
	rstyle(tabular)


* ---------- F-test table: joint F per control set ----------
* Same cell format as the 7_Tables.do F-test tables: "F*** (p)".

clear
set obs 14
gen str40 varlabel = ""
forvalues c = 1/6 {
	gen str40 c`c' = ""
}

local SETLABELS `""Education" "Postgrad" "Race" "OLF" "Unemployed" "Student" "Occupation" "Industry" "Tenure" "Census Division" "Year" "Age Bin" "Occ x Tenure" "Age Bin x Tenure""'

forvalues i = 1/14 {
	local lab : word `i' of `SETLABELS'
	quietly replace varlabel = `"`lab'"' in `i'

	forvalues c = 1/6 {
		local fval = FT[`i', `c']
		local pval = FTP[`i', `c']
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
		quietly replace c`c' = strtrim("`fval_fmt'`stars'") + " (" + strtrim("`pval_fmt'") + ")" in `i'
	}
}

listtex varlabel c1 c2 c3 c4 c5 c6 using "`OUT'/3.2_ftest.tex", ///
	replace ///
	head("\begin{tabular}{lccc|ccc}" ///
	     "\hline\hline" ///
	     " & \multicolumn{3}{c|}{Annual Earnings} & \multicolumn{3}{c}{Hourly Wage} \\" ///
	     "Control set & z 2-8 & z 10-22 & z 24-34 & z 2-8 & z 10-22 & z 24-34 \\" ///
	     "\hline") ///
	foot("\hline" ///
	     "\multicolumn{7}{l}{\footnotesize Note: joint F-statistics on each control set, p-values in parentheses.} \\" ///
	     "\multicolumn{7}{l}{\footnotesize z dummies always included. * p$<$0.10, ** p$<$0.05, *** p$<$0.01} \\" ///
	     "\hline\hline" ///
	     "\end{tabular}") ///
	rstyle(tabular)

clear


***********************************************************************
**                                                                   **
** RAW-DIFFERENCE GAMMA AND ALPHA                                    **
** Gamma and alpha computed from the RAW z-year differences (no      **
** first-stage residualization), consolidated to one value per       **
** person-year with the same mixed models as 5_MixedRegConsolidate,  **
** then run through the same selection machinery as above: plugin    **
** lasso and factor-notation F-tests, one regression per outcome x   **
** measure (no z bins). Intermediates are tempfiles only; outputs    **
** are 3.2_gamalpha_lasso_selection.tex / 3.2_gamalpha_ftest.tex.    **
**                                                                   **
***********************************************************************

use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", clear

xtset personid year

keep personid year fearn fhwage

drop if fearn==. & fhwage==.

* Wide raw differences for the full horizon range, as in 4_GamAlphaCalc.do:
* the J-Q grid below needs odd indices too (post-1997 odd-z differences are
* missing naturally, same as production).
forvalues z=1(1)41 {
	gen G`z'_fearn  = F`z'.fearn  - fearn  if F`z'.fearn !=. & fearn !=.
	gen G`z'_fhwage = F`z'.fhwage - fhwage if F`z'.fhwage!=. & fhwage!=.
}


* ---------- Gamma products: gam = (1/2)*G2*(L^j.G(j+2+q)) ----------
* Same J-Q loops as 4_GamAlphaCalc.do, with raw G in place of RG residuals.
* Output names keep the production "0_A_" convention so the consolidation
* code below copies from 5_MixedRegConsolidate.do unchanged.

tempfile stats_long_gamma
preserve
    clear
    set obs 0
    gen personid = .
    gen year  = .
    gen J     = .
    gen Q     = .
    gen JplusQ = .
    gen JJQQ   = .
	gen gam_fearn0_A_ = .
	gen gam_fhwage0_A_ = .
    save `stats_long_gamma', replace
restore

gen gam_fearn0_A_ = .
gen gam_fhwage0_A_ = .

forvalues j=2(1)32 {
	forvalues q=2(1)`=(35-`j')' {

		foreach x in fearn fhwage {
			quietly replace gam_`x'0_A_ = (1/2)*(G2_`x')*(L`j'.G`=`j'+2+`q''_`x')
		}

		preserve
            keep personid year gam_*

			egen anygamma = rownonmiss(gam_*)
			quietly keep if anygamma > 0
			drop anygamma

            quietly count
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


* ---------- Alpha products: alph = -1*(Gq)*(L^j.Gj) ----------

tempfile stats_long_alpha
preserve
    clear
    set obs 0
    gen personid = .
    gen year  = .
    gen J     = .
    gen Q     = .
    gen JplusQ = .
    gen JJQQ   = .
	gen alph_fearn0_A_ = .
	gen alph_fhwage0_A_ = .
    save `stats_long_alpha', replace
restore

gen alph_fearn0_A_ = .
gen alph_fhwage0_A_ = .

forvalues j=2(1)32 {
	forvalues q=2(1)`=(35-`j')' {

		foreach x in fearn fhwage {
			quietly replace alph_`x'0_A_ = -1*(G`q'_`x')*(L`j'.G`j'_`x')
		}

		preserve
            keep personid year alph_*

			egen anyalpha = rownonmiss(alph_*)
			quietly keep if anyalpha > 0
			drop anyalpha

            quietly count
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


* ---------- Combine to one J-Q-level dataset (as at the end of file 4) ----------

keep personid year

merge 1:m personid year using `stats_long_alpha'
drop JplusQ JJQQ
keep if _merge==3
drop _merge

merge 1:1 personid year J Q using `stats_long_gamma'
drop JplusQ JJQQ
drop _merge

gen JplusQ = J + Q
gen JJQQ = 100*J + Q

tempfile rawstats
save `rawstats', replace


* ---------- Mixed-model consolidation (5_MixedRegConsolidate.do machinery) ----------

drop if missing(J) | missing(Q)

* Winsorize at 1st/99th percentiles, once, globally (file 5 convention)
foreach var in gam_fhwage0_A_ alph_fhwage0_A_ gam_fearn0_A_ alph_fearn0_A_ {
    _pctile `var', percentiles(1 99)
    local p1 = r(r1)
    local p99 = r(r2)
    quietly replace `var' = `p1' if `var' < `p1' & `var' != .
    quietly replace `var' = `p99' if `var' > `p99' & `var' != .
}

tempfile winsorized
save `winsorized', replace

* Gamma: GAMMA ~ sumjkq + J fixed, random intercept + slope on sumjkq by
* person-year; consolidated value = fixed intercept + random intercept.
tempfile gamma_fhwage gamma_fearn

foreach earn in fhwage fearn {

    if "`earn'" == "fhwage" {
        local sfx ""
    }
    else {
        local sfx "_`earn'"
    }

    use `winsorized', clear

    drop if missing(gam_`earn'0_A_)
    keep gam_`earn'0_A_ personid year J Q JplusQ JJQQ

    gen sumjkq = J + Q + 2

    gen idyear = .
    recast long idyear
    replace idyear = 100*personid + (year - 1969)

    rename gam_`earn'0_A_ GAMMA

    mixed GAMMA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

    * b1 = random slope on sumjkq; b2 = random intercept (named slope first)
    predict b*, reffects

    gen gammaP_WEIGHTED`sfx' = _b[_cons] + b2
    label variable gammaP_WEIGHTED`sfx' "Consolidated raw-difference gamma (`earn')"

    drop J Q sumjkq JJQQ JplusQ GAMMA b1 b2
    duplicates drop
    drop idyear

    save `gamma_`earn''
}

* Alpha: ALPHA ~ JQ fixed, random intercept + slope on JQ by person-year.
tempfile alpha_fhwage alpha_fearn

foreach earn in fhwage fearn {

    if "`earn'" == "fhwage" {
        local sfx ""
    }
    else {
        local sfx "_`earn'"
    }

    use `winsorized', clear

    drop if missing(alph_`earn'0_A_)
    keep alph_`earn'0_A_ personid year J Q JplusQ JJQQ

    gen JQ = J*Q

    gen idyear = .
    recast long idyear
    replace idyear = 100*personid + (year - 1969)

    rename alph_`earn'0_A_ ALPHA

    mixed ALPHA JQ ||  idyear: JQ, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

    predict b*, reffects

    gen alphaP_WEIGHTED`sfx' = _b[_cons] + b2
    label variable alphaP_WEIGHTED`sfx' "Consolidated raw-difference alpha (`earn')"

    drop J Q JJQQ JplusQ ALPHA b1 b2 JQ
    duplicates drop
    drop idyear

    save `alpha_`earn''
}

* Assemble one row per person-year
use `rawstats', clear
keep personid year
duplicates drop

merge 1:1 personid year using `gamma_fhwage', nogen
merge 1:1 personid year using `gamma_fearn',  nogen
merge 1:1 personid year using `alpha_fhwage', nogen
merge 1:1 personid year using `alpha_fearn',  nogen

drop if missing(gammaP_WEIGHTED) & missing(gammaP_WEIGHTED_fearn) ///
      & missing(alphaP_WEIGHTED) & missing(alphaP_WEIGHTED_fearn)

tempfile consolidated
save `consolidated', replace


* ---------- Demographics merge ----------
* Candidate variables from the cleaning-stage data; bins regenerated as at
* the top of this file. NOTE: no 999 recodes for occ/twoind here, consistent
* with the selection regressions above (file 5's withDemographics step does
* recode them for the production pipeline).

use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", clear

capture drop tenurebin
gen tenurebin = .
replace tenurebin = 1 if tenure>=0 & tenure<=1
replace tenurebin = 2 if tenure>=2 & tenure<=5
replace tenurebin = 3 if tenure>=6 & tenure!=.
replace tenurebin = 1 if unemp==1

capture drop agebin4
gen agebin4 = floor((currentage-22)/4) + 1 if currentage>=22 & currentage<=69

keep personid year educwrths postgrad race OLF unemp student ///
     occ twoind tenurebin censdiv agebin4

merge 1:1 personid year using `consolidated'
keep if _merge == 3
drop _merge

* Dummy sets for the lasso (same construction as above)
tabulate educwrths, generate(educ_dum)
tabulate race,      generate(race_dum)
tabulate occ,       generate(occ_dum)
tabulate twoind,    generate(twoind_dum)
tabulate tenurebin, generate(ten_dum)
tabulate censdiv,   generate(censdiv_dum)
tabulate year,      generate(year_dum)
tabulate agebin4,   generate(agebin4_dum)

* Interaction dummies (same construction as the top of the file); the
* empty-cell set differs on this sample, so the denominators are recounted
unab OCCDUMS : occ_dum*
foreach od of local OCCDUMS {
	local i = substr("`od'", 8, .)
	forvalues k = 2/3 {
		gen byte occten_d`i'_`k' = `od' * ten_dum`k'
	}
}
forvalues i = 1/12 {
	capture confirm variable agebin4_dum`i'
	if !_rc {
		forvalues k = 2/3 {
			gen byte ageten_d`i'_`k' = agebin4_dum`i' * ten_dum`k'
		}
	}
}
foreach v of varlist occten_d* ageten_d* {
	quietly summarize `v', meanonly
	if r(max) == 0 drop `v'
}
unab OCCTENLIST : occten_d*
unab AGETENLIST : ageten_d*
local NOCCTEN_B : word count `OCCTENLIST'
local NAGETEN_B : word count `AGETENLIST'


* ---------- Selection runs: lasso + F-tests, 4 columns ----------
* c1 = gamma annual, c2 = alpha annual, c3 = gamma hourly, c4 = alpha hourly

matrix GFT  = J(14, 4, .)
matrix GFTP = J(14, 4, .)

capture log close earnsel
log using "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/OtherOutput/ThirdDraft/3.2_EarningsSelection.log", ///
	append text name(earnsel)

local col = 0
foreach m in fearn fhwage {
	local sfx = cond("`m'"=="fearn", "_fearn", "")

	foreach o in gamma alpha {
		local ++col
		local dv = cond("`o'"=="gamma", "gammaP_WEIGHTED`sfx'", "alphaP_WEIGHTED`sfx'")

		lasso linear `dv' `LASSOCANDS', selection(plugin)
		lassocoef
		local ga_lasel_`col' "`e(allvars_sel)'"

		* F-tests per control set, factor notation (as in the F table above)
		quietly regress `dv' i.educwrths postgrad i.race OLF ///
			unemp student i.occ i.twoind i.tenurebin i.censdiv ///
			i.year i.agebin4 i.occ#i.tenurebin i.agebin4#i.tenurebin

		forvalues s = 1/14 {
			quietly testparm `TP`s''
			matrix GFT[`s', `col']  = r(F)
			matrix GFTP[`s', `col'] = r(p)
		}
	}
}

log close earnsel


* ---------- Lasso table (4 columns) ----------
* Reuses the fixed row list (lvar#/llab#/NIND) built for the 6-column table.

clear
set obs `=`NIND'+6'
gen str40 varlabel = ""
forvalues c = 1/4 {
	gen str12 c`c' = ""
}

forvalues i = 1/`NIND' {
	quietly replace varlabel = `"`llab`i''"' in `i'
}
quietly replace varlabel = "Census Division (of 10)" in `=`NIND'+1'
quietly replace varlabel = "Occupation (of 79)"      in `=`NIND'+2'
quietly replace varlabel = "Industry (of 34)"        in `=`NIND'+3'
quietly replace varlabel = "Year (of 37)"            in `=`NIND'+4'
quietly replace varlabel = "Occupation x Tenure (of `NOCCTEN_B')" in `=`NIND'+5'
quietly replace varlabel = "Age Bin x Tenure (of `NAGETEN_B')"    in `=`NIND'+6'

forvalues c = 1/4 {
	local sel "`ga_lasel_`c''"

	forvalues i = 1/`NIND' {
		local pos : list posof "`lvar`i''" in sel
		if `pos' > 0 quietly replace c`c' = "\checkmark" in `i'
	}

	local ncd  = 0
	local nocc = 0
	local nind = 0
	local nyr  = 0
	local noct = 0
	local nagt = 0
	foreach v of local sel {
		if strmatch("`v'", "censdiv_dum*") local ++ncd
		if strmatch("`v'", "occ_dum*")     local ++nocc
		if strmatch("`v'", "twoind_dum*")  local ++nind
		if strmatch("`v'", "year_dum*")    local ++nyr
		if strmatch("`v'", "occten_d*")    local ++noct
		if strmatch("`v'", "ageten_d*")    local ++nagt
	}
	quietly replace c`c' = "`ncd'/10"  in `=`NIND'+1'
	quietly replace c`c' = "`nocc'/79" in `=`NIND'+2'
	quietly replace c`c' = "`nind'/34" in `=`NIND'+3'
	quietly replace c`c' = "`nyr'/37"  in `=`NIND'+4'
	quietly replace c`c' = "`noct'/`NOCCTEN_B'" in `=`NIND'+5'
	quietly replace c`c' = "`nagt'/`NAGETEN_B'" in `=`NIND'+6'
}

listtex varlabel c1 c2 c3 c4 using "`OUT'/3.2_gamalpha_lasso_selection.tex", ///
	replace ///
	head("\begin{tabular}{lcc|cc}" ///
	     "\hline\hline" ///
	     " & \multicolumn{2}{c|}{Annual Earnings} & \multicolumn{2}{c}{Hourly Wage} \\" ///
	     "Variable & Gamma & Alpha & Gamma & Alpha \\" ///
	     "\hline") ///
	foot("\hline\hline" ///
	     "\multicolumn{5}{l}{\footnotesize Lasso, plugin lambda. Outcomes are gamma/alpha from raw earnings differences,} \\" ///
	     "\multicolumn{5}{l}{\footnotesize consolidated by mixed regression. Age 46-49 and tenure 0-1 are omitted references.} \\" ///
	     "\end{tabular}") ///
	rstyle(tabular)


* ---------- F-test table (4 columns) ----------

clear
set obs 14
gen str40 varlabel = ""
forvalues c = 1/4 {
	gen str40 c`c' = ""
}

forvalues i = 1/14 {
	local lab : word `i' of `SETLABELS'
	quietly replace varlabel = `"`lab'"' in `i'

	forvalues c = 1/4 {
		local fval = GFT[`i', `c']
		local pval = GFTP[`i', `c']
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
		quietly replace c`c' = strtrim("`fval_fmt'`stars'") + " (" + strtrim("`pval_fmt'") + ")" in `i'
	}
}

listtex varlabel c1 c2 c3 c4 using "`OUT'/3.2_gamalpha_ftest.tex", ///
	replace ///
	head("\begin{tabular}{lcc|cc}" ///
	     "\hline\hline" ///
	     " & \multicolumn{2}{c|}{Annual Earnings} & \multicolumn{2}{c}{Hourly Wage} \\" ///
	     "Control set & Gamma & Alpha & Gamma & Alpha \\" ///
	     "\hline") ///
	foot("\hline" ///
	     "\multicolumn{5}{l}{\footnotesize Note: joint F-statistics on each control set, p-values in parentheses.} \\" ///
	     "\multicolumn{5}{l}{\footnotesize Outcomes are gamma/alpha from raw earnings differences, consolidated by mixed} \\" ///
	     "\multicolumn{5}{l}{\footnotesize regression. * p$<$0.10, ** p$<$0.05, *** p$<$0.01} \\" ///
	     "\hline\hline" ///
	     "\end{tabular}") ///
	rstyle(tabular)

clear
