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



* Scatter plot of age and gammaP_WEIGHTED
twoway (scatter gammaP_WEIGHTED currentage), title("Scatter plot of Age and gammaP_WEIGHTED") xlabel(, grid) ylabel(, grid)

* Scatter plot of ma5aep2 and gammaP_WEIGHTED
twoway (scatter gammaP_WEIGHTED ma5aep2), title("Scatter plot of ma5aep2 and gammaP_WEIGHTED") xlabel(, grid) ylabel(, grid)

* Scatter plot of currentagefourth and gammaP_WEIGHTED
twoway (scatter gammaP_WEIGHTED currentagefourth), title("Scatter plot of currentagefourth and gammaP_WEIGHTED") xlabel(, grid) ylabel(, grid)

* Scatter plot of tenure and gammaP_WEIGHTED
twoway (scatter gammaP_WEIGHTED tenure), title("Scatter plot of Tenure and gammaP_WEIGHTED") xlabel(, grid) ylabel(, grid)

* Scatter plot of edmaxyrs_squared and gammaP_WEIGHTED
twoway (scatter gammaP_WEIGHTED edmaxyrs_squared), title("Scatter plot of edmaxyrs_squared and gammaP_WEIGHTED") xlabel(, grid) ylabel(, grid)




* Run the stepwise regression
stepwise, pr(.05): regress gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared (state_dum1-state_dum51) (year_dum1-year_dum27) (occ_dum1-occ_dum77) (censdiv_dum1-censdiv_dum9) (race_dum1-race_dum5)


regress gammaP_WEIGHTED currentagecube currentagefourth ma5aep ma5aep2 i.(state occ censdiv)






* LASSO

quietly lasso linear gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared i.(state year occ censdiv race), selection(adaptive) rseed(12345)

lassoknots

quietly lasso linear gammaP_WEIGHTED (i.(state year occ censdiv race)) PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared, selection(adaptive) rseed(12345) 

lassoknots


regress gammaP_WEIGHTED currentagefourth ma5aep2 edmaxyrs_cubed fhwageSQ currentagesq i.(state year occ censdiv race)




* Create interactions of all the variables with edmaxyrs
foreach var in PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared {
    gen `var'_edyrs_sq = `var' * edmaxyrs
}

* Create interactions of all the variables with tenure
foreach var in PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared {
    gen `var'_ten = `var' * tenure
}

* LASSO with interactions
quietly lasso linear gammaP_WEIGHTED PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared ///
    PRsquare_edyrs_sq rGDPsquare_edyrs_sq fhwageSQ_edyrs_sq edmaxyrs_cubed_edyrs_sq ma5aep_edyrs_sq ma5aep2_edyrs_sq rGDPgrow_edyrs_sq PrRecess_edyrs_sq veteran_edyrs_sq OLF_edyrs_sq tenure_edyrs_sq edmaxyrs_edyrs_sq currentage_edyrs_sq fhwage0_P0_edyrs_sq currentagesq_edyrs_sq currentagecube_edyrs_sq currentagefourth_edyrs_sq tenure_squared_edyrs_sq ///
    PRsquare_ten rGDPsquare_ten fhwageSQ_ten edmaxyrs_cubed_ten ma5aep_ten ma5aep2_ten rGDPgrow_ten PrRecess_ten veteran_ten OLF_ten edmaxyrs_ten currentage_ten fhwage0_P0_ten currentagesq_ten currentagecube_ten currentagefourth_ten tenure_squared_ten ///
    i.(state year occ censdiv race), selection(adaptive) rseed(12345)

lassoknots

quietly lasso linear gammaP_WEIGHTED (i.(state year occ censdiv race)) PRsquare rGDPsquare fhwageSQ edmaxyrs_cubed ma5aep ma5aep2 rGDPgrow PrRecess veteran OLF tenure edmaxyrs currentage fhwage0_P0 currentagesq currentagecube currentagefourth tenure_squared edmaxyrs_squared ///
    PRsquare_edyrs_sq rGDPsquare_edyrs_sq fhwageSQ_edyrs_sq edmaxyrs_cubed_edyrs_sq ma5aep_edyrs_sq ma5aep2_edyrs_sq rGDPgrow_edyrs_sq PrRecess_edyrs_sq veteran_edyrs_sq OLF_edyrs_sq tenure_edyrs_sq edmaxyrs_edyrs_sq currentage_edyrs_sq fhwage0_P0_edyrs_sq currentagesq_edyrs_sq currentagecube_edyrs_sq currentagefourth_edyrs_sq tenure_squared_edyrs_sq ///
    PRsquare_ten rGDPsquare_ten fhwageSQ_ten edmaxyrs_cubed_ten ma5aep_ten ma5aep2_ten rGDPgrow_ten PrRecess_ten veteran_ten OLF_ten edmaxyrs_ten currentage_ten fhwage0_P0_ten currentagesq_ten currentagecube_ten currentagefourth_ten tenure_squared_ten, selection(adaptive) rseed(12345)

lassoknots


regress gammaP_WEIGHTED ma5aep2_edyrs_sq currentagefourth_edyrs_sq fhwageSQ_edyrs_sq edmaxyrs_cubed tenure fhwageSQ i.(state year occ censdiv race)





* Generate lagged value of gammaP_WEIGHTED for each person
bysort personid (year): gen L_gammaP_WEIGHTED = gammaP_WEIGHTED[_n-1]

* Run the regression with the lagged value
regress gammaP_WEIGHTED L_gammaP_WEIGHTED currentagefourth edmaxyrs_squared currentagesq ma5aep ma5aep2 fhwageSQ i.(state year occ censdiv race)




gen age_less_than_35 = (currentage < 35)
gen age_greater_than_35 = (currentage >= 35)


gen L_gammaP_young = L_gammaP_WEIGHTED * age_less_than_35
gen L_gammaP_old = L_gammaP_WEIGHTED * age_greater_than_35


* Run the regression with the lagged value and its interactions
regress gammaP_WEIGHTED L_gammaP_old L_gammaP_young

mean gammaP_WEIGHTED

mean L_gammaP_old
mean L_gammaP_young


bysort personid (year): gen first_year_gamma = gammaP_WEIGHTED if _n == 1

mean first_year_gamma




* Generate change in gammaP_WEIGHTED across years for each person
bysort personid (year): gen delta_gammaP_WEIGHTED = gammaP_WEIGHTED - gammaP_WEIGHTED[_n-1]

* Regress the change in gammaP_WEIGHTED on the selected variables for each person
regress delta_gammaP_WEIGHTED currentagefourth edmaxyrs edmaxyrs_squared currentagesq currentage ma5aep ma5aep2 i.(state year occ censdiv race)




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







