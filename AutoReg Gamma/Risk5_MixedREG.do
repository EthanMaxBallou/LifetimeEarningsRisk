
* Mixed Regression (Table 5 in Paper)

use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear

drop if missing(J) | missing(Q)
drop if missing(gam_fhwage0_A_)

gen sumjkq = J + Q + 2
gen JQ=J*Q
gen JJQQp = (J*100) + Q

gen idyear=.
recast long idyear

replace idyear=100*personid+(year-1969)

ren gam_fhwage0_A_ GAMMA 


mixed GAMMA sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog


estat recovar, corr
predict b*, reffects
predict gamma_real, fitted


gen gamma_sorta = b2 + _b[_cons] + ((b1 + _b[sumjkq]) * 2)



* Creating composite gamma for each (i,t)

areg gamma_real i.JJQQp, a(idyear)

predict res, r
gen SquaredRES = res^2

* same JJQQ have the same values of msr and sqrtinvmsr
egen msr = mean(SquaredRES), by(JJQQp)
gen sqrtinvmsr = sqrt(1/msr) 

* person i in year t has a common value across J and Q
egen sumsqrtinvmsr = sum(sqrtinvmsr), by(idyear)

* gets weights for each person i in year t
gen wt = sqrtinvmsr/sumsqrtinvmsr


gen temp3 = wt * gamma_real
egen gammaP_WEIGHTED = sum(temp3), by(idyear)



* creating a weighted JplusQ
*gen jqwt = wt * JplusQ
*egen JplusQ_gam_`x'`y'_`model'_wt = sum(jqwt), by(idyear) 


drop temp3 sumsqrtinvmsr SquaredRES msr res

save "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", replace


*replace gam_`x'`y'_`model'_best = . if JplusQ_gam_`x'`y'_`model'_wt ==0
*replace JplusQ_gam_`x'`y'_`model'_wt = . if JplusQ_gam_`x'`y'_`model'_wt ==0






