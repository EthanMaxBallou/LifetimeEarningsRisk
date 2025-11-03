




/*


Old method for generating dummies - new method adds label to the name of the dummy

tabulate race, generate(race_dum)
tabulate censdiv, generate(censdiv_dum)
tabulate occ, generate(occ_dum)
tabulate year, generate(year_dum)
tabulate state, generate(state_dum)
tabulate cohort, generate(cohort_dum)
tabulate twoind, generate(twoind_dum)

use "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", clear


*/




* new method adds the labels to the dummies? Can't straight up rename the variable since they have to be specified in the regression i.( ex )


tabulate twoind, generate(twoind_)

* get the value label name
local vl : value label twoind

* get the actual codes in order
levelsof twoind, local(levels)

* start a counter
local i = 1
foreach l of local levels {
    local lbl : label `vl' `l'
    label var twoind_`i' "`lbl'"
    local ++i
}





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

