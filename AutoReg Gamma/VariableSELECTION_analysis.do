* Lasso, stepwise regression, ridge

* run both and compare across in both coefficents, selection of variables, and significance  


use "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", clear


* If not already installed, install the ridgereg package:
ssc install ridgereg


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
stepwise, pr(.05): regress gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)


* LASSO

lasso linear gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared i.(state year occ censdiv race), selection(adaptive) rseed(12345)

lassoknots

lasso linear gammaP_WEIGHTED (i.(state year occ censdiv race)) PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared, selection(adaptive) rseed(12345) 

lassoknots



* Ridge

*ridgereg gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared state_dum* year_dum* occ_dum* censdiv_dum* race_dum*, model(grr1)




use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear


tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)

gen sumjkq = J + Q + 2

gen tenure_squared = tenure^2
gen edmaxyrs_squared = edmaxyrs^2
gen edmaxyrs_cubed = edmaxyrs^3

gen PRsquare = PrRecess^2
gen rGDPsquare = rGDPgrow^2
gen fhwageSQ = fhwage0_P0^2



* Run same on non-weighted gamma

* 0.01 because of larger sample size

stepwise, pr(.01): regress gam_fhwage0_A_ sumjkq J Q PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)


* LASSO

lasso linear gam_fhwage0_A_ sumjkq J Q PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared i.(state year occ censdiv race), selection(adaptive) rseed(12345)

lassoknots

lasso linear gam_fhwage0_A_ (i.(state year occ censdiv race)) sumjkq J Q PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared, selection(adaptive) rseed(12345) 

lassoknots



* Ridge

*ridgereg gam_fhwage0_A_ sumjkq J Q PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5), model(grr1)










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


