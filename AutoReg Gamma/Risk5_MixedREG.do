
* Mixed Regression (Table 5 in Paper)

use "/Users/ethanballou/Documents/Data/Risk/old_gam_data.dta", clear


drop if missing(J) | missing(Q)
drop if missing(gam_fhwage0_A_)


gen sumjkq = J + Q + 2
gen JQ=J*Q

gen idyear=.
recast long idyear

replace idyear=100*personid+(year-1969)



	** 4C. Hourly earnings

ren gam_fhwage0_A_ depvar 

mixed depvar sumjkq J ||  idyear: sumjkq, cov(unstructured) cluster(personid) var ltol(0.0001) matlog

estat recovar, corr

*est store m4_hour

predict xb_m4_hour, xb
predict re_m4_hour, fitted


*nlcom (Esigma2_eta: 100*_b[_cons]) (D: exp( _b[lns1_1_1:_cons] -  _b[lns1_1_2:_cons] )*(1-exp(2* _b[atr1_1_1_2:_cons] ))/(1+exp(2* _b[atr1_1_1_2:_cons] )))  (Ethetastar2: 10000*(exp( _b[lns1_1_1:_cons] -  _b[lns1_1_2:_cons] )*(1-exp(2* _b[atr1_1_1_2:_cons] ))/(1+exp(2* _b[atr1_1_1_2:_cons] ))*(_b[depvar:_cons]) ) + 10000*( _b[depvar:sumjkq])), post







