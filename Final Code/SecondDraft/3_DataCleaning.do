
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





* 2011



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

keep personid year over sex age relation edyrs state earnings annhrs

save, replace




* 2013

* 2015

* 2017

* 2019

* 2021

* 2023












