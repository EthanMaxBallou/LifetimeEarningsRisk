

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


use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_Combined.dta", clear



foreach y in `DVLIST' {

** Random effect has intercept only

mixed `y' i.year i.censdiv i.currentage c.currentagesq c.currentagecube c.currentagefourth || personid: , tech(nr 5 dfp 5 bfgs 5)

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

mixed `y' i.year i.censdiv i.currentage c.currentagesq c.currentagecube c.currentagefourth || personid: currentage, cov(uns) tech(nr 5 dfp 5 bfgs 5)

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


save "$DATA/permVtemp7-REtrends-NoGr.dta", replace


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
	save "$TEMPDATA/Residuals-REtrends-NoGr.dta", replace

}



save "$DATA/Residuals-REtrends-NoGr.dta", replace


 


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
save"$DATA/permVtemp7-REtrends.dta", replace


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
	save "$TEMPDATA/Residuals-REtrends.dta", replace

}

save "$DATA/Residuals-REtrends.dta", replace







