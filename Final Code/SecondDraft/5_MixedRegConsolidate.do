

* Replication Risk5_MixedREG.do from first draft


* Mixed Regression (Table 5 in Paper)



******use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear


use "/Users/ethanballou/Documents/Data/Risk/AlphaGammaRaw.dta", clear

drop if missing(J) | missing(Q)
drop if missing(gam_fhwage0_A_)
drop if missing(alph_fhwage0_A_)


drop gam_fearn0_A_ alph_fearn0_A_


gen sumjkq = J + Q + 2
gen JQ=J*Q
gen JJQQp = (J*100) + Q

gen idyear=.
recast long idyear

replace idyear=100*personid+(year-1969)




* Gamma consolidation


ren gam_fhwage0_A_ GAMMA 


mixed GAMMA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog


estat recovar, corr
predict b*, reffects
*predict gamma_real, fitted


gen new_gamma = GAMMA - sumjkq * (_b[sumjkq] + b1) - J * (_b[J])


* Creating composite gamma for each (i,t)

areg new_gamma i.JJQQp, a(idyear)

predict res, r
gen SquaredRES = res^2

* same JJQQ have the same values of msr and sqrtinvmsr
egen msr = mean(SquaredRES), by(JJQQp)
gen sqrtinvmsr = sqrt(1/msr) 

* person i in year t has a common value across J and Q
egen sumsqrtinvmsr = sum(sqrtinvmsr), by(idyear)

* gets weights for each person i in year t
gen wt = sqrtinvmsr/sumsqrtinvmsr


gen temp3 = wt * new_gamma
egen gammaP_WEIGHTED = sum(temp3), by(idyear)



drop temp3 sumsqrtinvmsr SquaredRES msr res J Q sumjkq JJQQp JplusQ GAMMA new_gamma JQ sqrtinvmsr wt


duplicates drop








* Alpha consolidation


ren alph_fhwage0_A_ ALPHA 


mixed ALPHA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog


estat recovar, corr
predict b*, reffects
*predict alpha_real, fitted


gen new_alpha = ALPHA - sumjkq * (_b[sumjkq] + b1) - J * (_b[J])


* Creating composite alpha for each (i,t)

areg new_alpha i.JJQQp, a(idyear)


predict res, r
gen SquaredRES = res^2

* same JJQQ have the same values of msr and sqrtinvmsr
egen msr = mean(SquaredRES), by(JJQQp)
gen sqrtinvmsr = sqrt(1/msr) 

* person i in year t has a common value across J and Q
egen sumsqrtinvmsr = sum(sqrtinvmsr), by(idyear)

* gets weights for each person i in year t
gen wt = sqrtinvmsr/sumsqrtinvmsr


gen temp3 = wt * new_alpha
egen alphaP_WEIGHTED = sum(temp3), by(idyear)



drop temp3 sumsqrtinvmsr SquaredRES msr res J Q sumjkq JJQQp JplusQ ALPHA new_alpha JQ sqrtinvmsr wt


duplicates drop


save "/Users/ethanballou/Documents/Data/Risk/Consolidated_AlphaGamma.dta", replace


*replace gam_`x'`y'_`model'_best = . if JplusQ_gam_`x'`y'_`model'_wt ==0
*replace JplusQ_gam_`x'`y'_`model'_wt = . if JplusQ_gam_`x'`y'_`model'_wt ==0





