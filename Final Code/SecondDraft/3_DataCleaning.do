
* What variables are needed?


/*

List of variables in needed at Gamma Consolidation stage (excluding squares and derived variables, and gamma/alpha variables):

Year
Personid
State
Censusdiv
over - sample subpopulation identifier
relation
occupation
soc2010 - occupation
oneind - 1 digit industry
twoind - 2 digit industry
race
student
self ?
both ?
edumaxyrs
educwrths - binned
postgrad
age
risktolerance
union
hourly - indicator for hourly pay
veteran
limited - disability
rGDPgrowth
PrRecess
unemp
OLF - in or out of labor force
tenure
nojobinfo
tenmiss - tenure cannot be inferred
tenmiss26 - tenure cannot be inferred for those under 26
lowtenure - tenure less than 1 year
white
cohort
group
agegroup
birth group
AEP - percentile annual earnings distribution
ma5AEP - moving average 5 year AEP
no earnings in prev 5 years




Variables needed from PSID:

Year
PersonID
State
CensusDiv
Relation
Occupation - all
Industry - all
Over - sample subpopulation identifier
Race
Student
Education - all
Age
RiskTolerance
Hourly
Union
Veteran
Limited - disability
Unemployed
Tenure - YRS W/ EMP
Cohort

+ income variables



- Variables are computed in the CREATE-permVtemp_data.dta in replication
- Initial data setup files just clean each year since variable names change across time


All that is needed in the following from each year:

personid year over sex age relation edyrs state earnings annhrs annwks race OLF student unemp (BLS variables for dollars adjustment - gdp growth, inflation, and probability of recession)

- RiskTolerance
- Veteran
- Limited
- Tenure
- Union
- Hourly
- Occupation
- Industry
- Cohort


- CAN BASCIALLY SKIP MOST OF THE STEPS WITH CNEF SINCE IT IS ALREADY CLEANED
- HOWEVER CNEF DOES HAVE RISK TOLERANCE OR UNION OR SOME OF THE OTHER VARIABLES - No Race, annual weeks worked, or student status

- CNEF CAN BE MATCHED TO PSID VIA: psid_id = ER30001*1000 + ER30002 and CNEF person identifier


*/



***** USE BARE BONES PSID DATA UP TO GAMMA CALC, THEN MERGE TO GET OTHER DEMOGRAPHIC VARIABLES LATER *****



save "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_Cleaned.dta", replace


use "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_Cleaned.dta", clear




* RENAMING OF PSID VARIABLES TO MATCH EARLIER WAVES *



* 2011


preserve


rename ER47318 sex
rename ER34104 age
rename ER34119 edyrs
rename ER52237 earnings
rename ER52175 annhrs
rename ER47303 state
rename ER34102 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2011
gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.
gen relation=ER34103 if ER34103 < 10
	replace relation=1 if ER34103==10 & seqno==1
	replace relation=5 if ER34103==10 & seqno!=1
	replace relation=2 if ER34103==20|ER34103==22|ER34103==90 
	replace relation=3 if (ER34103 >= 30 & ER34103 <= 35)|ER34103==38
	replace relation=4 if ER34103==40|ER34103==50|(ER34103>=60 & ER34103<= 65)
	replace relation=4 if ER34103==37|(ER34103>=47 & ER34103<=48)|(ER34103>=57 & ER34103<=58)
	replace relation=4 if (ER34103>=66 & ER34103 <=75)|(ER34103>=95 & ER34103<=101)
	replace relation=5 if (ER34103>=83 & ER34103 <=88)|ER34103==98
	replace relation=5 if relation==.

replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=0 if state>51
 replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs

tempfile temp_2011
save `temp_2011'


restore




* 2013


preserve


rename ER32000 sex
rename ER34204 age
rename ER34230 edyrs
rename ER53003 state
rename ER58038 earnings
rename ER57976 annhrs
rename ER34202 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2013
gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.
gen relation=ER34203 if ER34203 < 10
	replace relation=1 if ER34203==10 & seqno==1
	replace relation=5 if ER34203==10 & seqno!=1
	replace relation=2 if ER34203==20|ER34203==22|ER34203==90 
	replace relation=3 if (ER34203 >= 30 & ER34203 <= 35)|ER34203==38
	replace relation=4 if ER34203==40|ER34203==50|(ER34203>=60 & ER34203<= 65)
	replace relation=4 if ER34203==37|(ER34203>=47 & ER34203<=48)|(ER34203>=57 & ER34203<=58)
	replace relation=4 if (ER34203>=66 & ER34203 <=75)|(ER34203>=95 & ER34203<=101)
	replace relation=5 if (ER34203>=83 & ER34203 <=88)|ER34203==98
	replace relation=5 if relation==.
replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=0 if state>51
replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs


tempfile temp_2013
save `temp_2013'

restore




* 2015


preserve 


rename ER32000 sex
rename ER60017 age
rename ER34349 edyrs
rename ER60003 state
rename ER65216 earnings
rename ER65156 annhrs
rename ER34302 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2015
gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.
gen relation=ER34303 if ER34303 < 10
	replace relation=1 if ER34303==10 
	replace relation=5 if ER34303==10 & seqno!=1 
	replace relation=2 if ER34303==20|ER34303==22|ER34303==90 
	replace relation=3 if (ER34303 >= 30 & ER34303 <= 35)|ER34303==38
	replace relation=4 if ER34303==40|ER34303==50|(ER34303>=60 & ER34303<= 65)
	replace relation=4 if ER34303==37|(ER34303>=47 & ER34303<=48)|(ER34303>=57 & ER34303<=58)
	replace relation=4 if (ER34303>=66 & ER34303 <=75)|(ER34303>=95 & ER34303<=101)
	replace relation=5 if (ER34303>=83 & ER34303 <=88)|ER34303==98
	replace relation=5 if relation==.
replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
 replace age=999 if ER34303!=10
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=999 if state>51
replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs


tempfile temp_2015
save `temp_2015'

restore 





* 2017


preserve


rename ER32000 sex
rename ER66017 age
rename ER34548 edyrs
rename ER66003 state
rename ER71293 earnings
rename ER71233 annhrs
rename ER34502 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2017

gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.

gen relation=ER34503 if ER34503 < 10
	replace relation=1 if ER34503==10 
	replace relation=5 if ER34503==10 & seqno!=1 
	replace relation=2 if ER34503==20|ER34503==22|ER34503==90 
	replace relation=3 if (ER34503 >= 30 & ER34503 <= 35)|ER34503==38
	replace relation=4 if ER34503==40|ER34503==50|(ER34503>=60 & ER34503<= 65)
	replace relation=4 if ER34503==37|(ER34503>=47 & ER34503<=48)|(ER34503>=57 & ER34503<=58)
	replace relation=4 if (ER34503>=66 & ER34503 <=75)|(ER34503>=95 & ER34503<=101)
	replace relation=5 if (ER34503>=83 & ER34503 <=88)|ER34503==98
	replace relation=5 if relation==.

replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
 replace age=999 if ER34303!=10
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=999 if state>51
replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs


tempfile temp_2017
save `temp_2017'


restore





* 2019


preserve


rename ER32000 sex
rename ER72017 age
rename ER34752 edyrs
rename ER72003 state
rename ER77315 earnings
rename ER77255 annhrs
rename ER34702 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2019

gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.

gen relation=ER34703 if ER34703 < 10
	replace relation=1 if ER34703==10 
	replace relation=5 if ER34703==10 & seqno!=1 
	replace relation=2 if ER34703==20|ER34703==22|ER34703==90 
	replace relation=3 if (ER34703 >= 30 & ER34703 <= 35)|ER34703==38
	replace relation=4 if ER34703==40|ER34703==50|(ER34703>=60 & ER34703<= 65)
	replace relation=4 if ER34703==37|(ER34703>=47 & ER34703<=48)|(ER34703>=57 & ER34703<=58)
	replace relation=4 if (ER34703>=66 & ER34703 <=75)|(ER34703>=95 & ER34703<=101)
	replace relation=5 if (ER34703>=83 & ER34703 <=88)|ER34703==98
	replace relation=5 if relation==.

replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
 replace age=999 if ER34303!=10
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=999 if state>51
replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs



tempfile temp_2019
save `temp_2019'



restore





* 2021


preserve


rename ER32000 sex
rename ER78017 age
rename ER34952 edyrs
rename ER78003 state
rename ER81642 earnings
rename ER81582 annhrs
rename ER34902 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2021

gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.

gen relation=ER34903 if ER34903 < 10
	replace relation=1 if ER34903==10 
	replace relation=5 if ER34903==10 & seqno!=1 
	replace relation=2 if ER34903==20|ER34903==22|ER34903==90 
	replace relation=3 if (ER34903 >= 30 & ER34903 <= 35)|ER34903==38
	replace relation=4 if ER34903==40|ER34903==50|(ER34903>=60 & ER34903<= 65)
	replace relation=4 if ER34903==37|(ER34903>=47 & ER34903<=48)|(ER34903>=57 & ER34903<=58)
	replace relation=4 if (ER34903>=66 & ER34903 <=75)|(ER34903>=95 & ER34903<=101)
	replace relation=5 if (ER34903>=83 & ER34903 <=88)|ER34903==98
	replace relation=5 if relation==.

replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
 replace age=999 if ER34303!=10
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=999 if state>51
replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs



tempfile temp_2021
save `temp_2021'


restore





* 2023


preserve


rename ER32000 sex
rename ER82018 age
rename ER35152 edyrs
rename ER82003 state
rename ER85496 earnings
rename ER85436 annhrs
rename ER35102 seqno

gen personid=(ER30001*1000) + ER30002
gen year=2023

gen over=12 if ER30001>=3000 & ER30001<=5000
  replace over=11 if over==.

gen relation=ER35103 if ER35103 < 10
	replace relation=1 if ER35103==10 
	replace relation=5 if ER35103==10 & seqno!=1 
	replace relation=2 if ER35103==20|ER35103==22|ER35103==90 
	replace relation=3 if (ER35103 >= 30 & ER35103 <= 35)|ER35103==38
	replace relation=4 if ER35103==40|ER35103==50|(ER35103>=60 & ER35103<= 65)
	replace relation=4 if ER35103==37|(ER35103>=47 & ER35103<=48)|(ER35103>=57 & ER35103<=58)
	replace relation=4 if (ER35103>=66 & ER35103 <=75)|(ER35103>=95 & ER35103<=101)
	replace relation=5 if (ER35103>=83 & ER35103 <=88)|ER35103==98
	replace relation=5 if relation==.

replace annhrs=. if relation!=1|seqno!=1
replace earnings=. if relation!=1|seqno!=1
replace age=999 if age>125
 replace age=999 if age<1
 replace age=999 if ER34303!=10
replace edyrs=999 if edyrs>17
 replace edyrs=999 if edyrs<1
 replace edyrs=. if edyrs==999
replace state=999 if state>51
replace state=0 if state<1

drop if sex == .
drop if age > 120

keep personid year over sex age relation edyrs state earnings annhrs



tempfile temp_2023
save `temp_2023'



restore





* CNEF data ( up to 2009 )

* WHY CANT I JUST USE CNEF UP TO 2021???

* Import data using dictionary file
infile using "/Users/ethanballou/Documents/Data/LER_Draft2/CNEF/CNEF2/CNEF2.dct", clear


* run value labels CNEF do file here 
do "/Users/ethanballou/Documents/Data/LER_Draft2/CNEF/CNEF2/CNEF2-value-labels.do"


rename X11101LL personid 


forval i = 1970/2009 {

	if `i' == 1998 | `i' == 2000 | `i' == 2002 | `i' == 2004 | `i' == 2006 | `i' == 2008 {
		continue
	}

	preserve
	
	rename D11102LL_`i'_USA sex 
	rename D11101_`i'_USA age 
	rename D11105_`i'_USA relation
	rename D11109_`i'_USA edyrs
	rename L11101_`i'_USA state
	rename I11110_`i'_USA earnings 
	rename E11101_`i'_USA annhrs 
	rename X11104LL_`i'_USA over

	drop if sex == -4
	drop if age < 0

	gen year = `i'

	keep personid year over sex age relation edyrs state earnings annhrs

	tempfile temp_`i'
	save `temp_`i''
	
	restore

}



* Combine all CNEF temp files from 1970-2009
use `temp_1970', clear

forval i = 1971/2009 {
	if `i' == 1998 | `i' == 2000 | `i' == 2002 | `i' == 2004 | `i' == 2006 | `i' == 2008 {
		continue
	}
	append using `temp_`i''
}



replace personid = substr(personid, 3, .)
destring personid, replace force





* Combine with PSID years 2011-2023
append using `temp_2011'
append using `temp_2013'
append using `temp_2015'
append using `temp_2017'
append using `temp_2019'
append using `temp_2021'
append using `temp_2023'


replace annhrs=. if annhrs>6500
replace relation=999 if relation==.|relation==.s
replace earnings=. if earnings==.m|earnings==.s






preserve


** Importing annual Consumer Price Index for Urban Consumers (series CUUR0000SA0)

import delimited "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/AnnualCpi.csv", clear


keep year annual
ren annual cpi

** moving year forward by 1 because earnings are reported to PSID in following year

replace year=year+1


tempfile cpi_data
save `cpi_data'


restore










save "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_Combined.dta", replace


