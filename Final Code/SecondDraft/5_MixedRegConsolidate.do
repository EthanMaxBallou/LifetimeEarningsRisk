

* Replication Risk5_MixedREG.do from first draft


* Mixed Regression (Table 5 in Paper)



******use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear


use "/Users/ethanballou/Documents/Data/Risk/AlphaGammaRaw.dta", clear

drop if missing(J) | missing(Q)





* Gamma consolidation



preserve


drop if missing(gam_fhwage0_A_)


keep gam_fhwage0_A_ personid year J Q JplusQ JJQQ


gen sumjkq = J + Q + 2

gen idyear=.
recast long idyear

replace idyear=100*personid+(year-1969)






ren gam_fhwage0_A_ GAMMA 


mixed GAMMA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog


estat recovar, corr
predict b*, reffects
*predict gamma_real, fitted


gen new_gamma = GAMMA - sumjkq * (_b[sumjkq] + b1) - J * (_b[J])


* Creating composite gamma for each (i,t)

areg new_gamma i.JJQQ, a(idyear)

predict res, r
gen SquaredRES = res^2

* same JJQQ have the same values of msr and sqrtinvmsr
egen msr = mean(SquaredRES), by(JJQQ)
gen sqrtinvmsr = sqrt(1/msr) 

* person i in year t has a common value across J and Q
egen sumsqrtinvmsr = sum(sqrtinvmsr), by(idyear)

* gets weights for each person i in year t
gen wt = sqrtinvmsr/sumsqrtinvmsr


gen temp3 = wt * new_gamma
egen gammaP_WEIGHTED = sum(temp3), by(idyear)



drop temp3 sumsqrtinvmsr SquaredRES msr res J Q sumjkq JJQQ JplusQ GAMMA new_gamma sqrtinvmsr wt


duplicates drop

rename b1 b1_gamma
rename b2 b2_gamma

drop idyear


tempfile gamma_tempfile
save `gamma_tempfile'


restore









* Alpha consolidation



preserve

drop if missing(alph_fhwage0_A_)


keep alph_fhwage0_A_ personid year J Q JplusQ JJQQ


gen sumjkq = J + Q + 2

gen idyear=.
recast long idyear

replace idyear=100*personid+(year-1969)



ren alph_fhwage0_A_ ALPHA 


mixed ALPHA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog


estat recovar, corr
predict b*, reffects
*predict alpha_real, fitted


gen new_alpha = ALPHA - sumjkq * (_b[sumjkq] + b1) - J * (_b[J])


* Creating composite alpha for each (i,t)

areg new_alpha i.JJQQ, a(idyear)


predict res, r
gen SquaredRES = res^2

* same JJQQ have the same values of msr and sqrtinvmsr
egen msr = mean(SquaredRES), by(JJQQ)
gen sqrtinvmsr = sqrt(1/msr) 

* person i in year t has a common value across J and Q
egen sumsqrtinvmsr = sum(sqrtinvmsr), by(idyear)

* gets weights for each person i in year t
gen wt = sqrtinvmsr/sumsqrtinvmsr


gen temp3 = wt * new_alpha
egen alphaP_WEIGHTED = sum(temp3), by(idyear)



drop temp3 sumsqrtinvmsr SquaredRES msr res J Q sumjkq JJQQ JplusQ ALPHA new_alpha sqrtinvmsr wt


duplicates drop


rename b1 b1_alpha
rename b2 b2_alpha

drop idyear



tempfile alpha_tempfile
save `alpha_tempfile'


restore






keep personid year

duplicates drop


merge 1:1 personid year using `gamma_tempfile', nogen


merge 1:1 personid year using `alpha_tempfile', nogen



drop if missing(gammaP_WEIGHTED) & missing(alphaP_WEIGHTED)



save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta", replace







use "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_Combined.dta", clear



* Merge to get demographic variables

**** DROP THE G VARS BEFORE MERGING

merge 1:1 personid year using "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta"

keep if _merge == 3
drop _merge



replace veteran = 0 if missing(veteran)



save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma_withDemographics.dta", replace










