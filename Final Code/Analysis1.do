

use "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", clear

ssc install ridgereg


tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)
tabulate cohort, generate(cohort_dum)
tabulate twoind, generate(twoind_dum)

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





* OLS

* No controls
regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube


* controls - no occ or ind
regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort)


* controls - no occ
regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year race cohort twoind)


* controls - no ind
regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort)


* All controls
regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube i.(state year occ race cohort twoind)




* Stepwise regression (Do with different controls (with ind and with occupation))

* No controls
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube 

* controls - no occ or ind
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)

* controls - no occ
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum2)

* controls - no ind
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4)

* All controls
stepwise, pr(.05): regress gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (race_dum1-race_dum5) (cohort_dum1-cohort_dum4) (twoind_dum1-twoind_dum2)




* LASSO

* No controls
quietly lasso linear gammaP_WEIGHTED EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, selection(bic) rseed(12345) 
lassoknots


* controls - no occ or ind
quietly lasso linear gammaP_WEIGHTED (i.(state year race cohort)) EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, selection(bic) rseed(12345) 
lassoknots


* controls - no occ
quietly lasso linear gammaP_WEIGHTED (i.(state year race cohort twoind)) EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, selection(bic) rseed(12345) 
lassoknots


* controls - no ind
quietly lasso linear gammaP_WEIGHTED (i.(state year occ race cohort)) EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, selection(bic) rseed(12345) 
lassoknots


* All controls
quietly lasso linear gammaP_WEIGHTED (i.(state year occ race cohort twoind)) EDU1 EDU2 EDU3 PrRecess rGDPgrow fhwage0_P0 ma5aep veteran OLF tenure currentage currentagesq currentagecube, selection(bic) rseed(12345) 
lassoknots



* LASSO across occ and ind

* occ
quietly lasso linear gammaP_WEIGHTED fhwage0_P0 tenure currentage currentagesq currentagecube i.(occ race cohort), selection(bic) rseed(12345)
lassoknots


* ind
quietly lasso linear gammaP_WEIGHTED fhwage0_P0 tenure currentage currentagesq currentagecube i.(twoind race cohort), selection(bic) rseed(12345)
lassoknots


* occ
stepwise, pr(.05): regress gammaP_WEIGHTED i.(occ)


* ind
stepwise, pr(.05): regress gammaP_WEIGHTED fhwage0_P0 tenure currentage currentagesq currentagecube i.(twoind race cohort)


