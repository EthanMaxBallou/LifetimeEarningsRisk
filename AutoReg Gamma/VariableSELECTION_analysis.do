* Lasso, stepwise regression, ridge

* run both and compare across in both coefficents, selection of variables, and significance  


use "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", clear



tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)

* Generate squared terms for age, tenure, and edmaxyrs
gen tenure_squared = tenure^2
gen edmaxyrs_squared = edmaxyrs^2
gen edmaxyrs_cubed = edmaxyrs^3

gen PRsquare = PrRecess^2
gen rGDPsquare = rGDPgrow^2
gen fhwageSQ = fhwage0_P0^2



* Run the stepwise regression
*stepwise, pr(.05): regress gammaP_WEIGHTED OLF tenure edmaxyrs currentage fhwage0_P0 (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
*stepwise, pr(.05): regress gammaP_WEIGHTED OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
*stepwise, pr(.05): regress gammaP_WEIGHTED edmaxyrs_cubed rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
*stepwise, pr(.05): regress gammaP_WEIGHTED edmaxyrs_cubed PRsquare rGDPsquare fhwageSQ rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
stepwise, pr(.05): regress gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
stepwise, pr(.05) pe(.02) forward: regress gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)




*------------------------------------------------------------
* This is a new section regressing on the non-weighted version of gamma
*------------------------------------------------------------





* Run the stepwise regression
*stepwise, pr(.05): regress gamma_sorta OLF tenure edmaxyrs currentage fhwage0_P0 (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
*stepwise, pr(.05): regress gamma_sorta OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
*stepwise, pr(.05): regress gamma_sorta edmaxyrs_cubed rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
*stepwise, pr(.05): regress gamma_sorta edmaxyrs_cubed PRsquare rGDPsquare fhwageSQ rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)



* Run the stepwise regression
stepwise, pr(.05): regress gamma_sorta PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)








*------------------------------------------------------------
* 2. LASSO Regression
*    Stata’s built-in lasso routines can be used for variable selection.
*    Here we run a linear lasso regression with the adaptive selection method.
*------------------------------------------------------------
lasso linear price mpg weight length foreign i.headroom_cat, selection(adaptive) rseed(12345)

* To view the selected model variables after lasso, type:
lasso list


*------------------------------------------------------------
* 3. Ridge Regression
*    Ridge regression is not built into Stata’s base installation but is available 
*    via an SSC package. The following code installs and uses the 'ridgereg' package.
*------------------------------------------------------------

* If not already installed, install the ridgereg package:
ssc install ridgereg

* Run ridge regression with a specified lambda value (here, 0.1):
ridgereg price mpg weight length foreign , model(grr1)


