

* THERE ARE A FEW DATA CLEANING STEPS STILL - weeks, add student and OLF and unemp status

* After data is cleaned, gamma nad alpha are calculated in the interstage section of the replication





*** This program creates measures of residual earnings, representing deviations of individuals' wages
*** from age-earnings profiles and their own long-term trends. These are saved in files called "permVtemp7-..." .

*** The first half of the program creates residuals from the "simpler specification" that includes a 
*** common age-earnings profile, person-specific random effects (an intercept and in one case an earnings
*** growth rate), and fixed effects for years and census divisions.

*** The second half creates residuals from the "extended specification." The main change is to allow the age-earnings
*** profile to vary across groups defined by race, education, birth years. The specification also allows census division
*** fixed effects to vary by year and includes time trends for each level of education.

*** Each of those halves concludes by creating variables measuring for each person-year the amount by which 
*** residual log earnings grew over the next z years, for many different lengths z and saves them
*** in a different file called "Residuals-..." .




local DVLIST "fearn fhwage"



*** Simpler Specification


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

label define agebin_lbl 1 "22-29" 2 "30-37" 3 "38-45" 4 "46-53 (ref)" 5 "54-61" 6 "62-69"
label values agebin agebin_lbl
label variable agebin "Age bin (6 groups, 46-53 = reference)"

* Tenure bins (tenure is in whole years): 0-1 (reference), 2-5, 6+
* Unemployed are assigned to the 0-1 reference bin regardless of recorded tenure.
gen tenurebin = .
replace tenurebin = 1 if tenure>=0 & tenure<=1
replace tenurebin = 2 if tenure>=2 & tenure<=5
replace tenurebin = 3 if tenure>=6 & tenure!=.
replace tenurebin = 1 if unemp==1

label define tenurebin_lbl 1 "0-1 (ref)" 2 "2-5" 3 "6+"
label values tenurebin tenurebin_lbl
label variable tenurebin "Tenure bin (0-1 = reference; unemployed assigned to 0-1)"

save "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_CombinedwithTEN.dta", replace



* Average earnings age profile for each group (group = white + cohort + educwrths)

preserve
collapse (mean) fearn, by(currentage group)
twoway line fearn currentage, by(group, cols(6) title("Average Log Earnings by Age, by Group")) ///
    xtitle("Age") ytitle("Mean fearn")
graph export "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Plots/avg_fearn_by_age_group.png", replace width(2000)
restore





foreach y in `DVLIST' {

** Random effect has intercept only

mixed `y' EDU1 EDU2 EDU3 EDU4 i.(EDU1 EDU2 EDU3 EDU4)#(c.currentage c.currentagesq c.currentagecube c.currentagefourth) PrRecess OLF tenure i.(censdiv year occ race cohort twoind) i.currentage c.currentagesq c.currentagecube c.currentagefourth || personid: , tech(nr 5 dfp 5 bfgs 5)

	predict `y'_xb0, xb
	predict `y'D0, fitted
	predict `y'0, residuals
		label variable `y'_xb0 "fitted `y' including only fixed parameters"
		label variable `y'D0 "fitted `y', from initial regression"
		label variable `y'0 "residual `y' (fixed effects and person RE's removed)"
	replace `y'_xb0=. if `y'==.
	replace `y'D0=. if `y'==.
	gen `y'_xbres0 =`y'-`y'_xb0 if `y' !=.
		label variable `y'_xbres0 " `y' - `y'_xb0 "
	sum `y' `y'_xbres0 `y'0

** Random effect has intercept and growth rate

mixed `y' EDU1 EDU2 EDU3 EDU4 i.(EDU1 EDU2 EDU3 EDU4)#(c.currentage c.currentagesq c.currentagecube c.currentagefourth) PrRecess OLF tenure i.(censdiv year occ race cohort twoind) i.currentage c.currentagesq c.currentagecube c.currentagefourth || personid: currentage, cov(uns) tech(nr 5 dfp 5 bfgs 5)

	predict `y'_xb1, xb
	predict `y'D1, fitted
	predict `y'1, residuals
		label variable `y'_xb1 "fitted `y' including only fixed parameters"
		label variable `y'D1 "fitted `y', from initial regression"
		label variable `y'1 "residual `y' (fixed effects and person RE's removed)"
	replace `y'_xb1=. if `y'==.
	replace `y'D1=. if `y'==.
	gen `y'_xbres1 =`y'-`y'_xb1 if `y' !=.
		label variable `y'_xbres1 " `y' - `y'_xb1 "
	sum `y' `y'_xbres0 `y'0
	sum `y' `y'_xbres1 `y'1
}
	gen temp=fearnD1-fearn_xb1 if fearnD1!=. & fearn_xb1!=.
		gen tempslope = 0.5*(F2.temp-temp)
		egen fearn1_P1 = max(tempslope), by(personid year)
		drop temp tempslope
	gen temp=fhwageD1-fhwage_xb1 if fhwageD1!=. & fhwage_xb1!=.
		gen tempslope = 0.5*(F2.temp-temp)
		egen fhwage1_P1 = max(tempslope), by(personid year)
		drop temp tempslope
	label variable fearn1_P1 "estimated indiv. annual earnings growth rate"
	label variable fhwage1_P1 "estimated indiv. hourly earnings growth rate"
	move fearn1_P1 fearn1
	move fhwage1_P1 fhwage1

compress


save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_simpleSPEC.dta", replace


***********************************************************************
**                                                             	     **  
** CREATE DIFFERENCES                                          	     **
**                                                             	     **
***********************************************************************   
set matsize 1200


foreach x in `DVLIST' {
	sort personid year

	forvalues z=1(1)41 {
 		forvalues y=0/1 {

	 	gen G`z'_`x'`y' = F`z'.`x'`y' - `x'`y' if F`z'.`x'`y' !=. & `x'`y' !=. 

		label variable G`z'_`x'`y' "growth of `x'`y' between years t+1 and t+`=`z'+1' "

		}
	}
	compress
	save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_simpleSPEC_difference.dta", replace


}



save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_simpleSPEC_difference.dta", replace



/*


*** Extended Specification


use "$DATA/permVtemp7", clear




foreach y in `DVLIST' {

** Random effect has intercept only

mixed `y' i.year i.censdiv##c.year i.currentage i.(group postgrad)##(c.currentage c.currentagesq c.currentagecube c.currentagefourth) i.(educwrths postgrad)#c.year  || personid: , tech(nr 5 dfp 5 bfgs 5)

	predict `y'_xb0, xb
	predict `y'D0, fitted
	predict `y'0, residuals
		label variable `y'_xb0 "fitted `y' including only fixed parameters"
		label variable `y'D0 "fitted `y', from initial regression"
		label variable `y'0 "residual `y' (fixed effects and person RE's removed)"
	replace `y'_xb0=. if `y'==.
	replace `y'D0=. if `y'==.
	gen `y'_xbres0 =`y'-`y'_xb0 if `y' !=.
		label variable `y'_xbres0 " `y' - `y'_xb0 "
	sum `y' `y'_xbres0 `y'0

** Random effect has intercept and growth rate

mixed `y' i.year i.censdiv##c.year i.currentage i.(group postgrad)##(c.currentage c.currentagesq c.currentagecube c.currentagefourth) i.(educwrths postgrad)#c.year  || personid: currentage, cov(uns) tech(nr 5 dfp 5 bfgs 5)

	predict `y'_xb1, xb
	predict `y'D1, fitted
	predict `y'1, residuals
		label variable `y'_xb1 "fitted `y' including only fixed parameters"
		label variable `y'D1 "fitted `y', from initial regression"
		label variable `y'1 "residual `y' (fixed effects and person RE's removed)"
	replace `y'_xb1=. if `y'==.
	replace `y'D1=. if `y'==.
	gen `y'_xbres1 =`y'-`y'_xb1 if `y' !=.
		label variable `y'_xbres1 " `y' - `y'_xb1 "
	sum `y' `y'_xbres0 `y'0
	sum `y' `y'_xbres1 `y'1
}
	gen temp=fearnD1-fearn_xb1 if fearnD1!=. & fearn_xb1!=.
		gen tempslope = 0.5*(F2.temp-temp)
		egen fearn1_P1 = max(tempslope), by(personid year)
		drop temp tempslope
	gen temp=fhwageD1-fhwage_xb1 if fhwageD1!=. & fhwage_xb1!=.
		gen tempslope = 0.5*(F2.temp-temp)
		egen fhwage1_P1 = max(tempslope), by(personid year)
		drop temp tempslope
	label variable fearn1_P1 "estimated indiv. annual earnings growth rate"
	label variable fhwage1_P1 "estimated indiv. hourly earnings growth rate"
	move fearn1_P1 fearn1
	move fhwage1_P1 fhwage1

compress

save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_extendedSPEC.dta", replace


***********************************************************************
**                                                             	     **  
** CREATE DIFFERENCES                                          	     **
**                                                             	     **
***********************************************************************   
set matsize 1200


foreach x in `DVLIST' {
	sort personid year

	forvalues z=1(1)41 {
 		forvalues y=0/1 {

	 	gen G`z'_`x'`y' = F`z'.`x'`y' - `x'`y' if F`z'.`x'`y' !=. & `x'`y' !=. 

		label variable G`z'_`x'`y' "growth of `x'`y' between years t+1 and t+`=`z'+1' "

		}
	}
	compress
	save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_extendedSPEC_difference.dta", replace

}

save "/Users/ethanballou/Documents/Data/LER_Draft2/gamma_extendedSPEC_difference.dta", replace




*/






*****************************************************
**			 GAMMA			   **
*****************************************************

   * gam_[VAR]_jjqq     = (1/2)*(G2_[VAR])*(Ljj.G[jj+2+qq]_[VAR])



global DVLIST "fearn fhwage"	
global MAXORDER "1"				
global MODELLIST "A"	







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
	gen gam_fearn1_A_ = .
	gen gam_fhwage0_A_ = .
	gen gam_fhwage1_A_ = .

	label variable JplusQ "=J+Q"
	label variable JJQQ "1st two dig=J, 2nd two dig=Q"

    save `stats_long_gamma', replace
restore




gen gam_fearn0_A_ = .
gen gam_fearn1_A_ = .
gen gam_fhwage0_A_ = .
gen gam_fhwage1_A_ = .



forvalues j=2(1)32 {
	forvalues q=2(1)`=(35-`j')' {



**NOTE: HERE IS WHERE WE ARE COMPUTING THE GAMMA STATISTICS
**NOTE: BY STARTING J AND Q FROM 2, WE ARE IMPOSING THE BELIEF THAT TRANSITORY SHOCKS ARE MA(1)
**NOTE: WE WOULD START J AND Q FROM 3 IF WE WANT TO ALLOW FOR TRANSITORY SHOCKS TO BE MA(2)

		foreach x in $DVLIST {
			forvalues y=0/$MAXORDER { 
				foreach model in $MODELLIST {

	
					replace gam_`x'`y'_`model'_ = (1/2)*(G2_`x'`y')*(L`j'.G`=`j'+2+`q''_`x'`y') 

				}
			}
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

   *  alph_[VAR]_jjqq    = -1*(Gqq_[VAR])*(Ljj.Gjj_[VAR])



global DVLIST "fearn fhwage"	
global MAXORDER "1"				
global MODELLIST "A"	



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
	gen alph_fearn1_A_ = .
	gen alph_fhwage0_A_ = .
	gen alph_fhwage1_A_ = .

	label variable JplusQ "=J+Q"
	label variable JJQQ "1st two dig=J, 2nd two dig=Q"

    save `stats_long_alpha', replace
restore


gen alph_fearn0_A_ = .
gen alph_fearn1_A_ = .
gen alph_fhwage0_A_ = .
gen alph_fhwage1_A_ = .



forvalues j=2(1)32 {
	forvalues q=2(1)`=(35-`j')' {



**NOTE: HERE IS WHERE WE ARE COMPUTING THE ALPHA STATISTICS
**NOTE: BY STARTING J AND Q FROM 2, WE ARE IMPOSING THE BELIEF THAT TRANSITORY SHOCKS ARE MA(1)
**NOTE: WE WOULD START J AND Q FROM 3 IF WE WANT TO ALLOW FOR TRANSITORY SHOCKS TO BE MA(2)

		foreach x in $DVLIST {
			forvalues y=0/$MAXORDER { 
				foreach model in $MODELLIST {

	
					replace alph_`x'`y'_`model'_ = -1*(G`q'_`x'`y')*(L`j'.G`j'_`x'`y')

				}
			}
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
save "/Users/ethanballou/Documents/Data/Risk/GammaRaw.dta", replace
restore

preserve
use `stats_long_alpha', clear
save "/Users/ethanballou/Documents/Data/Risk/AlphaRaw.dta", replace
restore




keep personid year



merge 1:m personid year using "/Users/ethanballou/Documents/Data/Risk/AlphaRaw.dta"

drop JplusQ JJQQ

keep if _merge==3
drop _merge




merge 1:1 personid year J Q using "/Users/ethanballou/Documents/Data/Risk/GammaRaw.dta"

drop JplusQ JJQQ

drop _merge



gen JplusQ = J + Q
gen JJQQ = 100*J + Q
label variable JplusQ "=J+Q"
label variable JJQQ "1st two dig=J, 2nd two dig=Q"


save "/Users/ethanballou/Documents/Data/Risk/AlphaGammaRaw.dta", replace




