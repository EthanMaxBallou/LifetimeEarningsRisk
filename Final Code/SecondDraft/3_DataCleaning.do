
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







save "/Users/ethanballou/Documents/Data/LER_Draft2/CNEF_Combined.dta", replace




clear all


do "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_GAMMACALCVARIABLES/J354703.do"

do "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_GAMMACALCVARIABLES/J354703_formats.do"





preserve




gen personid=(ER30001*1000) + ER30002

forvalues x=1968(1)1997  {
	gen seqno`x'=.
	gen relation`x'=.
	gen spanhead`x'=.
	gen racehead1_`x'=.
	gen racehead2_`x'=.
	gen racehead3_`x'=.
	gen racehead4_`x'=.
}
forvalues x=1999(2)2023 {
	gen seqno`x'=.
	gen relation`x'=.
	gen spanhead`x'=.
	gen racehead1_`x'=.
	gen racehead2_`x'=.
	gen racehead3_`x'=.
	gen racehead4_`x'=.
}

replace relation1968= ER30003
replace racehead1_1968= V181

replace relation1969= ER30022
replace seqno1969= ER30021
replace racehead1_1969= V801

replace relation1970= ER30045
replace seqno1970= ER30044
replace racehead1_1970= V1490

replace relation1971= ER30069
replace seqno1971= ER30068
replace racehead1_1971= V2202

replace relation1972 =ER30093
replace seqno1972= ER30092
replace racehead1_1972= V2828

replace relation1973= ER30119
replace seqno1973= ER30118
replace racehead1_1973= V3300

replace relation1974= ER30140
replace seqno1974= ER30139
replace racehead1_1974= V3720

replace relation1975= ER30162
replace seqno1975= ER30161
replace racehead1_1975= V4204

replace relation1976= ER30190
replace seqno1976 =ER30189
replace racehead1_1976= V5096

replace relation1977= ER30219
replace seqno1977= ER30218
replace racehead1_1977= V5662

replace relation1978= ER30248
replace seqno1978= ER30247
replace racehead1_1978= V6209

replace relation1979= ER30285
replace seqno1979= ER30284
replace racehead1_1979= V6802

replace relation1980= ER30315
replace seqno1980= ER30314
replace racehead1_1980= V7447

replace relation1981= ER30345
replace seqno1981= ER30344
replace racehead1_1981= V8099

replace relation1982= ER30375
replace seqno1982= ER30374
replace racehead1_1982= V8723

replace relation1983= ER30401
replace seqno1983= ER30400
replace racehead1_1983= V9408

replace relation1984 =ER30431
replace seqno1984= ER30430
replace racehead1_1984= V11055

replace relation1985= ER30465
replace seqno1985= ER30464
replace spanhead1985= V11937 
replace racehead1_1985= V11938
replace racehead2_1985= V11939

replace relation1986      =  ER30500
replace seqno1986          =  ER30499
replace spanhead1986   =  V13564
replace racehead1_1986= V13565
replace racehead2_1986= V13566

replace relation1987      =  ER30537
replace seqno1987          =  ER30536
replace spanhead1987   =  V14611
replace racehead1_1987= V14612
replace racehead2_1987= V14613

replace relation1988      =  ER30572
replace seqno1988          =  ER30571
replace spanhead1988   =  V16085
replace racehead1_1988= V16086
replace racehead2_1988= V16087

replace relation1989      =  ER30608
replace seqno1989          =  ER30607
replace spanhead1989   =  V17482
replace racehead1_1989= V17483
replace racehead2_1989= V17484

replace relation1990      =  ER30644
replace seqno1990          =  ER30643
replace spanhead1990   =  V18813
replace racehead1_1990= V18814
replace racehead2_1990= V18815

replace relation1991      =  ER30691
replace seqno1991          =  ER30690
replace spanhead1991   =  V20113
replace racehead1_1991= V20114
replace racehead2_1991= V20115

replace relation1992      =  ER30735
replace seqno1992          =  ER30734
replace spanhead1992   =  V21419
replace racehead1_1992= V21420
replace racehead2_1992= V21421

replace relation1993      =  ER30808
replace seqno1993          =  ER30807
replace spanhead1993   =  V23275
replace racehead1_1993= V23276
replace racehead2_1993= V23277

replace relation1994      =  ER33103
replace seqno1994          =  ER33102
replace spanhead1994   =  ER3941
replace racehead1_1994= ER3944
replace racehead2_1994= ER3945
replace racehead3_1994= ER3946

replace relation1995      =  ER33203
replace seqno1995          =  ER33202
replace spanhead1995   =  ER6811
replace racehead1_1995= ER6814
replace racehead2_1995= ER6815
replace racehead3_1995= ER6816

replace relation1996      =  ER33303
replace seqno1996          =  ER33302
replace spanhead1996   =  ER9057
replace racehead1_1996= ER9060
replace racehead2_1996= ER9061
replace racehead3_1996= ER9062

replace relation1997      =  ER33403
replace seqno1997          =  ER33402
replace racehead1_1997= ER11848
replace racehead2_1997= ER11849
replace racehead3_1997= ER11850
replace racehead4_1997= ER11851

replace relation1999      =  ER33503
replace seqno1999          =  ER33502
replace racehead1_1999= ER15928
replace racehead2_1999= ER15929
replace racehead3_1999= ER15930
replace racehead4_1999= ER15931

replace relation2001      =  ER33603
replace seqno2001          =  ER33602
replace racehead1_2001= ER19989
replace racehead2_2001= ER19990
replace racehead3_2001= ER19991
replace racehead4_2001= ER19992

replace relation2003      =  ER33703
replace seqno2003          =  ER33702
replace racehead1_2003= ER23426
replace racehead2_2003= ER23427
replace racehead3_2003= ER23428
replace racehead4_2003= ER23429

replace relation2005      =  ER33803
replace seqno2005          =  ER33802
replace spanhead2005   =  ER27392
replace racehead1_2005= ER27393
replace racehead2_2005= ER27394
replace racehead3_2005= ER27395
replace racehead4_2005= ER27396

replace relation2007      =  ER33903
replace seqno2007          =  ER33902
replace spanhead2007   =  ER40564
replace racehead1_2007= ER40565
replace racehead2_2007= ER40566
replace racehead3_2007= ER40567
replace racehead4_2007= ER40568

replace relation2009      =  ER34003
replace seqno2009          =  ER34002
replace spanhead2009   =  ER46542
replace racehead1_2009= ER46543
replace racehead2_2009= ER46544
replace racehead3_2009= ER46545
replace racehead4_2009= ER46546

replace relation2011     =  ER34103
replace seqno2011          =  ER34102
replace spanhead2011   =  ER51903
replace racehead1_2011= ER51904
replace racehead2_2011= ER51905
replace racehead3_2011= ER51906
replace racehead4_2011= ER51907

replace relation2013     =  ER34203
replace seqno2013          =  ER34202
replace spanhead2013   =  ER57658
replace racehead1_2013= ER57659
replace racehead2_2013= ER57660
replace racehead3_2013= ER57661
replace racehead4_2013= ER57662

replace relation2015     =  ER34303
replace seqno2015          =  ER34302
replace spanhead2015   =  ER64809
replace racehead1_2015= ER64810
replace racehead2_2015= ER64811
replace racehead3_2015= ER64812
replace racehead4_2015= ER64813

replace relation2017     =  ER34503
replace seqno2017          =  ER34502
replace spanhead2017   =  ER70881
replace racehead1_2017= ER70882
replace racehead2_2017= ER70883
replace racehead3_2017= ER70884
replace racehead4_2017= ER70885

replace relation2019     =  ER34703
replace seqno2019          =  ER34702
replace spanhead2019   =  ER76896
replace racehead1_2019= ER76897
replace racehead2_2019= ER76898
replace racehead3_2019= ER76899
replace racehead4_2019= ER76900

replace relation2021     =  ER34903
replace seqno2021          =  ER34902
replace spanhead2021   =  ER81143
replace racehead1_2021= ER81144
replace racehead2_2021= ER81145
replace racehead3_2021= ER81146
replace racehead4_2021= ER81147

replace relation2023     =  ER35103
replace seqno2023          =  ER35102
replace spanhead2023   =  ER85120
replace racehead1_2023= ER85121
replace racehead2_2023= ER85122
replace racehead3_2023= ER85123
replace racehead4_2023= ER85124

keep personid ER30001 relation* seqno* spanhead* racehead1_* racehead2_* racehead3_* racehead4_*

reshape long relation seqno spanhead racehead1_ racehead2_ racehead3_ racehead4_, i(personid) j(year)

ren racehead*_ racehead*



ren relation relation_orig

gen relation= . if year>=1983 & relation_orig < 10 & relation_orig > 0
		** NOTE: There should not be any such individuals, but this would clear any errors from the intended range of codes
	replace relation=1 if year>=1983 & relation_orig==10 
	replace relation=5 if year>=1983 & relation_orig==10 & seqno!=1
	replace relation=2 if year>=1983 & relation_orig==20|relation_orig==22|relation_orig==90 
	replace relation=3 if year>=1983 & (relation_orig >= 30 & relation_orig <= 35)|relation_orig==38
	replace relation=4 if year>=1983 & relation_orig==40|relation_orig==50|(relation_orig>=60 & relation_orig<= 65)
	replace relation=4 if year>=1983 & relation_orig==37|(relation_orig>=47 & relation_orig<=48)|(relation_orig>=57 & relation_orig<=58)
	replace relation=4 if year>=1983 & (relation_orig>=66 & relation_orig <=75)|(relation_orig>=95 & relation_orig<=101)
	replace relation=5 if year>=1983 & (relation_orig>=83 & relation_orig <=88)|relation_orig==98
	replace relation=0 if year>=1983 & relation_orig==0
	replace relation=5 if year>=1983 & relation_orig==.
replace relation=1 if year<1983 & relation_orig == 1
	replace relation=5 if year<1983 & relation_orig == 1 & seqno!=1
	replace relation=2 if year<1983 & (relation_orig==2|(relation_orig==9 & year>1968)) 
	replace relation=3 if year<1983 & relation_orig==3
	replace relation=4 if year<1983 & relation_orig>3 & relation_orig<8
	replace relation=5 if year<1983 & relation_orig==8
	replace relation=0 if year<1983 & relation_orig==0
	replace relation=5 if year<1983 & relation_orig==.




*****************************************************
**  GENERATING CONSISTENT RACE IDENTIFIERS  **
**
** Note: CNEF assigns each person same race as head. 
** Here we are more careful about possibility that some
** are different - prefer reports when the individual is the 
** head, followed by reports when individual is child of head.
*****************************************************

** 1. Harmonizing codes across years

gen hisp=0
	replace hisp=1 if spanhead>0 & spanhead<=7

gen raceh1=.
	replace raceh1=1 if racehead1==1 
	replace raceh1=2 if racehead1==2 
	replace raceh1=5 if (racehead1==3 & year<1985 ) | (racehead1==5 & year>1989 & year<2005)
	replace raceh1=3 if racehead1==3 & year>=1985
	replace raceh1=4 if  (year>1984 & racehead1==4 ) | (year>2003 & racehead1==5)
	replace raceh1=7 if racehead1>=6  & racehead1<8
	replace raceh1=7 if racehead1==8 & year==1985
	replace raceh1=8 if racehead1==7 & year<1985
		** NOTE: We create category 8 bec. many groups later reported
		** individually were initially grouped into category 7. Also leaving
		** category 9 ("don't know") as missing.
gen raceh2=.
	replace raceh2=1 if racehead2==1 
	replace raceh2=2 if racehead2==2 
	replace raceh2=5 if (racehead2==5 & year>1989 & year<2005) 
	replace raceh2=3 if racehead2==3 & year>=1985
	replace raceh2=4 if  (year>1984 & racehead2==4 ) | (year>2003 & racehead2==5)
	replace raceh2=7 if racehead2>=6  & racehead2<8
	replace raceh2=7 if racehead2==8 & year>=1985 & year<=1993
	replace raceh2=. if raceh2==raceh1
	replace raceh2=8 if racehead2==7 & year<1985
gen raceh3=.
	replace raceh3=1 if racehead3==1 
	replace raceh3=2 if racehead3==2 
	replace raceh3=5 if (racehead3==5 & year>1989 & year<2005) 
	replace raceh3=3 if racehead3==3 & year>=1985
	replace raceh3=4 if  (year>1984 & racehead3==4 ) | (year>2003 & racehead3==5)
	replace raceh3=7 if racehead3>=6  & racehead3<=8
	replace raceh3=. if raceh3==raceh1|raceh3==raceh2
gen raceh4=.
	replace raceh4=1 if racehead4==1 
	replace raceh4=2 if racehead4==2 
	replace raceh4=5 if (racehead4==5 & year>1989 & year<2005) 
	replace raceh4=3 if racehead4==3 & year>=1985
	replace raceh4=4 if  (year>1984 & racehead4==4 ) | (year>2003 & racehead4==5)
	replace raceh4=7 if racehead4>=6  & racehead4<=8
	replace raceh4=. if raceh4==raceh1|raceh4==raceh2|raceh4==raceh3
tab raceh1
tab raceh2
tab raceh3
tab raceh4

** 2. Assigning head's race - priority: Hispanic, (Black, Native American, Asian) if 1st mention, 
** (same list) if 2nd mention and 1st mention is White/Other, then (White, Other) if first mention

gen racehead=5 if hisp==1
	replace racehead=5 if racehead==. & (raceh1==5|raceh2==5)
	replace racehead=5 if racehead==. & (raceh3==5|raceh4==5) & ER30001>7000 & ER30001<9309
		** NOTE: This is the Latino sample. Since it is possible that a non-Latino
		** could join such a family, we require them to claim to be Hispanic.
	replace racehead=2 if racehead==. & raceh1==2
	replace racehead=3 if racehead==. & raceh1==3
	replace racehead=4 if racehead==. & raceh1==4
		** Anyone left listed first race as white/other/blank
	replace racehead=2 if racehead==. & raceh2==2
	replace racehead=3 if racehead==. & raceh2==3
	replace racehead=4 if racehead==. & raceh2==4
	replace racehead=1 if racehead==. & raceh1==1
	replace racehead=7 if racehead==. & raceh1==7
		** NOTE: This list covers all possible cases except raceh1=8,
		** which mean "not white, black, or Latino" before 1985
gen raceambig=1 if raceh1==8

** 3. Assigning values to individuals who were ever heads

ren racehead race_orig_var

gen racerule=.

gen ownrace1=race_orig_var if relation==1 & (seqno==1|year==1968)
	

** Rule 1: use original race variable if always same when head
egen rmax=max(ownrace1), by(personid)
egen rmin=min(ownrace1), by(personid)
gen race=rmax if rmax==rmin & rmax!=.
drop rmax rmin 
tab race, miss
gen temp=1 if race!=.
	replace temp=0 if temp==.
replace racerule=1 if race!=.

** Rule 2: Hispanic if race is missing and ever reports Hispanic when head
gen hisp1=1 if ownrace1==5
	replace hisp1=0 if ownrace1!=5 & ownrace1!=.
	egen hisp2=max(hisp1), by(personid)
replace race=5 if race==. & hisp2==1
drop hisp1 hisp2
replace racerule=2 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 3: Black if race is missing and ever reports Black when head
gen black1=1 if ownrace1==2
	replace black1=0 if ownrace1!=2 & ownrace1!=.
	egen black2=max(black1), by(personid)
replace race=2 if race==. & black2==1
drop black1 black2
replace racerule=3 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 4: More common response of Native American or Asian if race 
** 	is missing and ever reports either when head
gen natam1=1 if ownrace1==3
	replace natam1=0 if ownrace1!=3 & ownrace1!=.
	egen natam2=sum(natam1), by(personid)
gen asian1=1 if ownrace1==4
	replace asian1=0 if ownrace1!=4 & ownrace1!=.
	egen asian2=sum(asian1), by(personid)
replace race=3 if race==. & natam2>asian2 & natam2!=. & natam2>0
replace race=4 if race==. & asian2>=natam2 & asian2!=. & asian2>0
drop natam1 natam2 asian1 asian2
replace racerule=4 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 5: Other if race is missing and ever reports Other when head
gen oth1=1 if ownrace1==7
	replace oth1=0 if ownrace1!=7 & ownrace1!=.
	egen oth2=max(oth1), by(personid)
replace race=7 if race==. & oth2==1
drop oth1 oth2
replace racerule=5 if race!=. & temp==0
replace temp=1 if race!=.

** Note: Rules 1-5 categorizes everyone who was ever a head unless
** they were only heads before 1985 and always reported "other." If race
** was not coded by rules 2-6, then person must always have reported
** "white" when head and was thus coded by rule 1.

drop ownrace1

**  Rule 6: Most common race (excluding those rejected by individual)
**  of biological relatives if race is missing and individual reported
**  Other when head before 1985 (when there were fewer categories)

gen ownrace1=race_orig_var if year<1983 & relation_orig>=3 & relation_orig<=6
replace ownrace1=race_orig_var if year>=1983 &  (relation_orig ==30|relation_orig ==40|relation_orig ==50|relation_orig==60)

gen y=raceambig if race==. & relation==1 & (seqno==1|year==1968)
egen y2=max(y), by(personid)
gen ownrace2=ownrace1
	replace ownrace2=. if ownrace1==1|ownrace1==1|ownrace1==5
		** Eliminating categories that individual rejected when head
egen x=mode(ownrace2), maxmode by(personid)
replace race=x if race==. & y2==1
drop ownrace2 y y2 x
replace racerule=6 if race!=. & temp==0
replace temp=1 if race!=.


** 4. Assigning values for close bio relatives who were never heads

egen rmax=max(ownrace1), by(personid)
egen rmin=min(ownrace1), by(personid)

** Rule 7: use original race variable if always same for bio relative heads
replace race=rmax if race==. & rmax==rmin & rmax!=.
drop rmax rmin 
tab race, miss
replace racerule=7 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 8: Hispanic if race is missing and any bio relative head reports Hispanic
gen hisp1=1 if ownrace1==5
	replace hisp1=0 if ownrace1!=5 & ownrace1!=.
	egen hisp2=max(hisp1), by(personid)
replace race=5 if race==. & hisp2==1
drop hisp1 hisp2
replace racerule=8 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 9: Black if race is missing and any bio relative head reports Black
gen black1=1 if ownrace1==2
	replace black1=0 if ownrace1!=2 & ownrace1!=.
	egen black2=max(black1), by(personid)
replace race=2 if race==. & black2==1
drop black1 black2
replace racerule=9 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 10: Native American if race is missing and any bio relative head reports Native American
gen natam1=1 if ownrace1==3
	replace natam1=0 if ownrace1!=3 & ownrace1!=.
	egen natam2=max(natam1), by(personid)
replace race=3 if race==. & natam2==1
drop natam1 natam2
replace racerule=10 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 11: Asian if race is missing and any bio relative head reports Asian
gen asian1=1 if ownrace1==4
	replace asian1=0 if ownrace1!=4 & ownrace1!=.
	egen asian2=max(asian1), by(personid)
replace race=4 if race==. & asian2==1
drop asian1 asian2
replace racerule=11 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 12: For everyone else, use the mode of head's race
egen headrace1=mode(race_orig_var), maxmode by(personid)
replace race=headrace1 if race==.
drop headrace1
tab race, miss
replace racerule=12 if race!=. & temp==0
replace temp=1 if race!=.

** Rule 13: If anyone has been left out somehow, code race=other
replace race=7 if race==.
replace racerule=13 if race!=. & temp==0
replace temp=1 if race!=.

egen test1=max(race), by(personid)
egen test2=min(race), by(personid)
gen flag=test1-test2
tab flag

label define raceL  ///
       1 "White"  ///
       2 "Black"  ///
       3 "Native American"  ///
       4 "Asian or Pacific Islander"  ///
       5 "Latino"  ///
       7 "Other or Unknown"  

label values race      raceL


keep personid year seqno race



tempfile race_data
save `race_data'


restore








* Student and OLF



preserve


gen personid = (ER30001*1000)+ER30002 

gen OLF68=0
gen OLF69=0
gen OLF70=0
gen OLF71=0
gen OLF72=0
gen OLF73=0
gen OLF74=0
gen OLF75=0
gen OLF76=0
gen OLF77=0
gen OLF78=0
gen OLF79=0
gen OLF80=0
gen OLF81=0
gen OLF82=0
gen OLF83=0
gen OLF84=0
gen OLF85=0
gen OLF86=0
gen OLF87=0
gen OLF88=0
gen OLF89=0
gen OLF90=0
gen OLF91=0
gen OLF92=0
gen OLF93=0
gen OLF94=0
gen OLF95=0
gen OLF96=0
gen OLF97=0
gen OLF99=0
gen OLF101=0
gen OLF103=0
gen OLF105=0
gen OLF107=0
gen OLF109=0
gen OLF111=0
gen OLF113=0
gen OLF115=0
gen OLF117=0
gen OLF119=0
gen OLF121=0
gen OLF123=0
replace OLF79=1 if ER30293>=4 & ER30293<=8
replace OLF80=1 if ER30323>=4 & ER30323<=8
replace OLF81=1 if ER30353>=4 & ER30353<=8
replace OLF82=1 if ER30382>=4 & ER30382<=8
replace OLF83=1 if ER30411>=4 & ER30411<=8
replace OLF84=1 if ER30441>=4 & ER30441<=8
replace OLF85=1 if ER30474>=4 & ER30474<=8
replace OLF86=1 if ER30509>=4 & ER30509<=8
replace OLF87=1 if ER30545>=4 & ER30545<=8
replace OLF88=1 if ER30580>=4 & ER30580<=8
replace OLF89=1 if ER30616>=4 & ER30616<=8
replace OLF90=1 if ER30653>=4 & ER30653<=8
replace OLF91=1 if ER30699>=4 & ER30699<=8
replace OLF92=1 if ER30744>=4 & ER30744<=8
replace OLF93=1 if ER30816>=4 & ER30816<=8
replace OLF94=1 if ER33111>=4 & ER33111<=8
replace OLF95=1 if ER33211>=4 & ER33211<=8
replace OLF96=1 if ER33311>=4 & ER33311<=8
replace OLF97=1 if ER33411>=4 & ER33411<=8
replace OLF99=1 if ER33512>=4 & ER33512<=8
replace OLF101=1 if ER33612>=4 & ER33612<=8
replace OLF103=1 if ER33712>=4 & ER33712<=8
replace OLF105=1 if ER33813>=4 & ER33813<=8
replace OLF107=1 if ER33913>=4 & ER33913<=8
replace OLF109=1 if ER34016>=4 & ER34016<=8
replace OLF111=1 if ER34116>=4 & ER34116<=8
replace OLF113=1 if ER34216>=4 & ER34216<=8
replace OLF115=1 if ER34317>=4 & ER34317<=8
replace OLF117=1 if ER34516>=4 & ER34516<=8
replace OLF119=1 if ER34716>=4 & ER34716<=8
replace OLF121=1 if ER34916>=4 & ER34916<=8
replace OLF123=1 if ER35116>=4 & ER35116<=8
replace OLF76=1 if V4458>=4 & V4458<=8 & ER30190==1
replace OLF77=1 if V5373>=4 & V5373<=8 & ER30219==1
replace OLF78=1 if V5872>=4 & V5872<=8 & ER30248==1
replace OLF75=1 if V3967>=3 & V3967<=6 & ER30162==1 
replace OLF74=1 if V3528>=3 & V3528<=6 & ER30140==1 
replace OLF73=1 if V3114>=3 & V3114<=6 & ER30119==1 
replace OLF72=1 if V2581>=3 & V2581<=6 & ER30093==1 
replace OLF71=1 if V1983>=3 & V1983<=6 & ER30069==1 
replace OLF70=1 if V1278>=3 & V1278<=6 & ER30045==1



gen student69=0
gen student70=0
gen student71=0
gen student72=0
gen student73=0
gen student74=0
gen student75=0
gen student76=0
gen student77=0
gen student78=0
gen student79=0
gen student80=0
gen student81=0
gen student82=0
gen student83=0
gen student84=0
gen student85=0
gen student86=0
gen student87=0
gen student88=0
gen student89=0
gen student90=0
gen student91=0
gen student92=0
gen student93=0
gen student94=0
gen student95=0
gen student96=0
gen student97=0
gen student99=0
gen student101=0
gen student103=0
gen student105=0
gen student107=0
gen student109=0
gen student111=0
gen student113=0
gen student115=0
gen student117=0
gen student119=0
gen student121=0
gen student123=0
replace student79=1 if ER30293==7 
replace student80=1 if ER30323==7 
replace student81=1 if ER30353==7 
replace student82=1 if ER30382==7 
replace student83=1 if ER30411==7 
replace student84=1 if ER30441==7 
replace student85=1 if ER30474==7 
replace student86=1 if ER30509==7 
replace student87=1 if ER30545==7 
replace student88=1 if ER30580==7 
replace student89=1 if ER30616==7 
replace student90=1 if ER30653==7 
replace student91=1 if ER30699==7 
replace student92=1 if ER30744==7 
replace student93=1 if ER30816==7 
replace student94=1 if ER33111==7 
replace student95=1 if ER33211==7 
replace student96=1 if ER33311==7 
replace student97=1 if ER33411==7 
replace student99=1 if ER33512==7 
replace student101=1 if ER33612==7 
replace student103=1 if ER33712==7 
replace student105=1 if ER33813==7 
replace student107=1 if ER33913==7 
replace student109=1 if ER34016==7 
replace student111=1 if ER34116==7 
replace student113=1 if ER34216==7 
replace student115=1 if ER34317==7 
replace student117=1 if ER34516==7
replace student119=1 if ER34716==7
replace student121=1 if ER34916==7
replace student123=1 if ER35116==7
replace student76=1 if V4458==7 & ER30190==1
replace student77=1 if V5373==7 & ER30219==1
replace student78=1 if V5872==7 & ER30248==1
replace student75=1 if V3967==5 & ER30162==1 
replace student74=1 if V3528==5 & ER30140==1 
replace student73=1 if V3114==5 & ER30119==1 
replace student72=1 if V2581==5 & ER30093==1 
replace student71=1 if V1983==5 & ER30069==1 
replace student70=1 if V1278==5 & ER30045==1 

gen unemp68=0
gen unemp69=0
gen unemp70=0
gen unemp71=0
gen unemp72=0
gen unemp73=0
gen unemp74=0
gen unemp75=0
gen unemp76=0
gen unemp77=0
gen unemp78=0
gen unemp79=0
gen unemp80=0
gen unemp81=0
gen unemp82=0
gen unemp83=0
gen unemp84=0
gen unemp85=0
gen unemp86=0
gen unemp87=0
gen unemp88=0
gen unemp89=0
gen unemp90=0
gen unemp91=0
gen unemp92=0
gen unemp93=0
gen unemp94=0
gen unemp95=0
gen unemp96=0
gen unemp97=0
gen unemp99=0
gen unemp101=0
gen unemp103=0
gen unemp105=0
gen unemp107=0
gen unemp109=0
gen unemp111=0
gen unemp113=0
gen unemp115=0
gen unemp117=0
gen unemp119=0
gen unemp121=0
gen unemp123=0
replace unemp79=1 if ER30293==3
replace unemp80=1 if ER30323==3
replace unemp81=1 if ER30353==3
replace unemp82=1 if ER30382==3
replace unemp83=1 if ER30411==3
replace unemp84=1 if ER30441==3
replace unemp85=1 if ER30474==3
replace unemp86=1 if ER30509==3
replace unemp87=1 if ER30545==3
replace unemp88=1 if ER30580==3
replace unemp89=1 if ER30616==3
replace unemp90=1 if ER30653==3
replace unemp91=1 if ER30699==3
replace unemp92=1 if ER30744==3
replace unemp93=1 if ER30816==3
replace unemp94=1 if ER33111==3
replace unemp95=1 if ER33211==3
replace unemp96=1 if ER33311==3
replace unemp97=1 if ER33411==3
replace unemp99=1 if ER33512==3
replace unemp101=1 if ER33612==3
replace unemp103=1 if ER33712==3
replace unemp105=1 if ER33813==3
replace unemp107=1 if ER33913==3
replace unemp109=1 if ER34016==3
replace unemp111=1 if ER34116==3
replace unemp113=1 if ER34216==3
replace unemp115=1 if ER34317==3
replace unemp117=1 if ER34516==3
replace unemp119=1 if ER34716==3
replace unemp121=1 if ER34916==3
replace unemp123=1 if ER35116==3
replace unemp76=1 if V4458==3 & ER30190==1
replace unemp77=1 if V5373==3 & ER30219==1
replace unemp78=1 if V5872==3 & ER30248==1
replace unemp75=1 if V3967==2 & ER30162==1 
replace unemp74=1 if V3528==2 & ER30140==1 
replace unemp73=1 if V3114==2 & ER30119==1 
replace unemp72=1 if V2581==2 & ER30093==1 
replace unemp71=1 if V1983==2 & ER30069==1 
replace unemp70=1 if V1278==2 & ER30045==1 


keep personid OLF* student* unemp*

reshape long OLF student unemp, i(personid) j(yrx)
 
gen year = 1900+yrx
	drop yrx

label variable OLF "=1 if out of labor force (inc retired)"
label variable student "=1 if student"
label variable unemp "=1 if unemployed"


tempfile olf_data
save `olf_data'


restore








****** VETERAN AND OTHER


* can add marriage and child data later if needed


preserve


clear


do "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_VETERANMARRIAGE/J354995.do"

do "/Users/ethanballou/Documents/Data/LER_Draft2/PSID_VETERANMARRIAGE/J354995_formats.do"


gen personid=(ER30001*1000) + ER30002



forvalues x=1968(1)1997  {
	gen seqno`x'=.
	gen relation`x'=.
	gen vet`x'=.

}

forvalues x=1999(2)2023 {
	gen seqno`x'=.
	gen relation`x'=.
	gen vet`x'=.

}


replace vet1968 =1 if V315==1
replace vet1969 =1 if V796==1
replace vet1970 =1 if V1487==1
replace vet1971 =1 if V2199==1
replace vet1972 =1 if V2825==1
replace vet1973 =1 if V3243==1
replace vet1974 =1 if V3665==1
replace vet1975 =1 if V4140==1
replace vet1976 =1 if V4683==1
replace vet1977 =1 if V5603==1
replace vet1978 =1 if V6152==1
replace vet1979 =1 if V6749==1
replace vet1980 =1 if V7382==1
replace vet1981 =1 if V8034==1
replace vet1982 =1 if V8658==1
replace vet1983 =1 if V9344==1
replace vet1984 =1 if V10991==1
replace vet1985 =1 if V11940==1
replace vet1986 =1 if V13567==1
replace vet1987 =1 if V14614==1
replace vet1988 =1 if V16088==1
replace vet1989 =1 if V17485==1
replace vet1990 =1 if V18816==1
replace vet1991 =1 if V20116==1
replace vet1992 =1 if V21422==1
replace vet1993 =1 if V23278==1
replace vet1994 =1 if ER3947==1
replace vet1995 =1 if ER6817==1
replace vet1996 =1 if ER9063==1
replace vet1997 =1 if ER11852==1
replace vet1999 =1 if ER15935==1
replace vet2001 =1 if ER19996==1
replace vet2003 =1 if ER23433==1
replace vet2005 =1 if ER27400==1
replace vet2007 =1 if ER40572==1
replace vet2009 =1 if ER46550==1
replace vet2011 =1 if ER51911==1
replace vet2013 =1 if ER57666==1
replace vet2015 =1 if ER64818==1
replace vet2017 =1 if ER70890==1
replace vet2019 =1 if ER76905==1
replace vet2021 =1 if ER81152==1
replace vet2023 =1 if ER85129==1


replace relation1968= ER30003

replace relation1969= ER30022
replace seqno1969= ER30021

replace relation1970= ER30045
replace seqno1970= ER30044

replace relation1971= ER30069
replace seqno1971= ER30068

replace relation1972 =ER30093
replace seqno1972= ER30092

replace relation1973= ER30119
replace seqno1973= ER30118

replace relation1974= ER30140
replace seqno1974= ER30139

replace relation1975= ER30162
replace seqno1975= ER30161

replace relation1976= ER30190
replace seqno1976 =ER30189

replace relation1977= ER30219
replace seqno1977= ER30218

replace relation1978= ER30248
replace seqno1978= ER30247

replace relation1979= ER30285
replace seqno1979= ER30284

replace relation1980= ER30315
replace seqno1980= ER30314

replace relation1981= ER30345
replace seqno1981= ER30344

replace relation1982= ER30375
replace seqno1982= ER30374

replace relation1983= ER30401
replace seqno1983= ER30400

replace relation1984 =ER30431
replace seqno1984= ER30430

replace relation1985= ER30465
replace seqno1985= ER30464

replace relation1986      =  ER30500
replace seqno1986          =  ER30499

replace relation1987      =  ER30537
replace seqno1987          =  ER30536

replace relation1988      =  ER30572
replace seqno1988          =  ER30571

replace relation1989      =  ER30608
replace seqno1989          =  ER30607

replace relation1990      =  ER30644
replace seqno1990          =  ER30643

replace relation1991      =  ER30691
replace seqno1991          =  ER30690

replace relation1992      =  ER30735
replace seqno1992          =  ER30734

replace relation1993      =  ER30808
replace seqno1993          =  ER30807

replace relation1994      =  ER33103
replace seqno1994          =  ER33102

replace relation1995      =  ER33203
replace seqno1995          =  ER33202

replace relation1996      =  ER33303
replace seqno1996          =  ER33302

replace relation1997      =  ER33403
replace seqno1997          =  ER33402

replace relation1999      =  ER33503
replace seqno1999          =  ER33502

replace relation2001      =  ER33603
replace seqno2001          =  ER33602

replace relation2003      =  ER33703
replace seqno2003          =  ER33702

replace relation2005      =  ER33803
replace seqno2005          =  ER33802

replace relation2007      =  ER33903
replace seqno2007          =  ER33902

replace relation2009      =  ER34003
replace seqno2009          =  ER34002

replace relation2011     =  ER34103
replace seqno2011          =  ER34102

replace relation2013     =  ER34203
replace seqno2013          =  ER34202

replace relation2015     =  ER34303
replace seqno2015          =  ER34302

replace relation2017     =  ER34503
replace seqno2017          =  ER34502

replace relation2019     =  ER34703
replace seqno2019          =  ER34702

replace relation2021     =  ER34903
replace seqno2021          =  ER34902

replace relation2023     =  ER35103
replace seqno2023          =  ER35102



keep personid vet* relation* seqno*



reshape long vet relation seqno, i(personid) j(year)



ren relation relation_orig

gen relation= . if year>=1983 & relation_orig < 10 & relation_orig > 0
		** NOTE: There should not be any such individuals, but this would clear any errors from the intended range of codes
	replace relation=1 if year>=1983 & relation_orig==10 
	replace relation=5 if year>=1983 & relation_orig==10 & seqno!=1
	replace relation=2 if year>=1983 & relation_orig==20|relation_orig==22|relation_orig==90 
	replace relation=3 if year>=1983 & (relation_orig >= 30 & relation_orig <= 35)|relation_orig==38
	replace relation=4 if year>=1983 & relation_orig==40|relation_orig==50|(relation_orig>=60 & relation_orig<= 65)
	replace relation=4 if year>=1983 & relation_orig==37|(relation_orig>=47 & relation_orig<=48)|(relation_orig>=57 & relation_orig<=58)
	replace relation=4 if year>=1983 & (relation_orig>=66 & relation_orig <=75)|(relation_orig>=95 & relation_orig<=101)
	replace relation=5 if year>=1983 & (relation_orig>=83 & relation_orig <=88)|relation_orig==98
	replace relation=0 if year>=1983 & relation_orig==0
	replace relation=5 if year>=1983 & relation_orig==.
replace relation=1 if year<1983 & relation_orig == 1
	replace relation=5 if year<1983 & relation_orig == 1 & seqno!=1
	replace relation=2 if year<1983 & (relation_orig==2|(relation_orig==9 & year>1968)) 
	replace relation=3 if year<1983 & relation_orig==3
	replace relation=4 if year<1983 & relation_orig>3 & relation_orig<8
	replace relation=5 if year<1983 & relation_orig==8
	replace relation=0 if year<1983 & relation_orig==0
	replace relation=5 if year<1983 & relation_orig==.






replace vet = 0 if relation != 1

* Fill forward veteran status for each person
sort personid year
by personid: egen first_vet_while_head = max((vet == 1 & relation == 1) * year)
by personid: replace vet = 1 if year > first_vet_while_head & first_vet_while_head > 0


rename vet veteran

drop first_vet_while_head relation_orig relation seqno



tempfile vet_data
save `vet_data'



restore 







****** MACRO DATA IMPORTS *********

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






preserve


import delimited "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/PrRecess_VAR.csv", clear



gen year = real(substr(observation_date, 1, 4))
drop observation_date

rename recprousm156n PrRecess


replace year=year+1


tempfile recess_data
save `recess_data'


restore






preserve


import delimited "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/rGDP_VAR.csv", clear


gen year = real(substr(observation_date, 1, 4))
drop observation_date

rename a191rl1q225sbea rGDPgrow


replace year=year+1



tempfile rgdp_data
save `rgdp_data'


restore











use "/Users/ethanballou/Documents/Data/LER_Draft2/CNEF_Combined.dta", clear


merge 1:1 personid year using `olf_data', keep(1 3) nogenerate

merge 1:1 personid year using `race_data', keep(1 3) nogenerate

merge 1:1 personid year using `vet_data', keep(1 3) nogenerate



** Before 1979, data are for heads with seqno==1.
replace OLF=0 if seqno!=1 & year<1979
replace student=0 if seqno!=1 & year<1979
replace unemp=0 if seqno!=1 & year<1979

tsset personid year

** Additional qualifications for OLF or student status
	replace OLF=1 if (OLF==0|OLF==.) & year<1979 & (relation!=1|seqno!=1) & F.annhrs==0 & F.unemp==0 & (F.earnings==0|F.earnings==.)
	replace student=1 if student==0 & F.edyrs-edyrs>=1 & F.edyrs!=. & edyrs!=.





merge m:1 year using `cpi_data' 
	keep if _merge==3
	drop _merge

label variable cpi "CPI-U for preceding year"


merge m:1 year using `recess_data' 

	keep if _merge==3
	drop _merge

label variable PrRecess "Probability of Recession"


merge m:1 year using `rgdp_data' 
	keep if _merge==3
	drop _merge
label variable rGDPgrow "Real GDP growth rate"




**** CREATE LAST VARIABLES NEEDED FOR ANALYSIS ****



** renaming "sex" variable for clarity
	replace sex=0 if sex==2
	ren sex male

label variable personid "person ID"
label variable over "sample (main=11, SEO=12)"
label variable male "=1 if male"
label variable age "age"
label variable relation "relationship to HH head"
label variable edyrs "current years of completed schooling"
label variable state "state (PSID codes)"
label variable earnings "individual labor earnings"
label variable annhrs "individual annual work hours"

	label define overL  ///
	       11 "Main Sample PSID"  ///
	       12 "SEO low inc sample PSID"
	label values over overL

	label define maleL  ///
	       1 "Male"  ///
	       0 "Female"  ///
	       9 "NA"
	label values male maleL

	label define relationL  ///
	       1 "Head"  ///
	       2 "Spouse/partner"  ///
	       3 "Child"  ///
	       4 "Other relative"  ///
	       5 "Nonrelative"  ///
	     999 "NA"
	label values relation relationL

keep if male==1 & personid!=. & year!=.



label variable race "race/ethnicity"
label variable year "year"
label variable seqno "PSID interview sequence number"





*******************
* CREATE SOME VARIABLES *
***************************

xtset personid year
sort personid year


**Location-related

replace state=0 if state==.|state==.m|state==.s|state==999
	replace state=L.state if state==0 & L.state==F.state & L.state!=. & F.state!=.
	replace state=L2.state if state==0 & L2.state==F.state & L2.state!=. & F.state!=.
	replace state=L.state if state==0 & L.state==F2.state & L.state!=. & F2.state!=.
	replace state=L2.state if state==0 & L2.state==F2.state & L2.state!=. & F2.state!=.

	replace state=L.state if state==0 & L.state==F.state & L.state!=. & F.state!=.
	replace state=L2.state if state==0 & L2.state==F.state & L2.state!=. & F.state!=.
	replace state=L.state if state==0 & L.state==F2.state & L.state!=. & F2.state!=.
	replace state=L2.state if state==0 & L2.state==F2.state & L2.state!=. & F2.state!=.


gen censdiv=0

	replace censdiv=1 if (state==6 | state==18 | state==20 | state==28 |state==38 | state==44 )
	replace censdiv=2 if (state==29 | state==31 | state==37 )
	replace censdiv=3 if (state==12 | state==13 | state==21 | state==34 |state==48 )
	replace censdiv=4 if (state==14 | state==15 | state==22 | state==24 |state==26 | state==33 |state==40 )
	replace censdiv=5 if (state==7 | state==8 | state==9 | state==10 |state==19 | state==32 |state==39 | state==45 | state==47 )
	replace censdiv=6 if (state==1 | state==16 | state==23 | state==41 )
	replace censdiv=7 if (state==3 | state==17 | state==35 | state==42 )
	replace censdiv=8 if (state==2 | state==5 | state==11 | state==25 |state==27 | state==30 |state==43 | state==49 )
	replace censdiv=9 if (state==50 | state==4 | state==51 | state==36 |state==46 )

label variable censdiv "Census Division (0=unknown)"

move censdiv state
move state censdiv

	replace censdiv=L.censdiv if censdiv==0 & L.censdiv==F.censdiv & L.censdiv!=. & F.censdiv!=.
	replace censdiv=L2.censdiv if censdiv==0 & L2.censdiv==F.censdiv & L2.censdiv!=. & F.censdiv!=.
	replace censdiv=L.censdiv if censdiv==0 & L.censdiv==F2.censdiv & L.censdiv!=. & F2.censdiv!=.
	replace censdiv=L2.censdiv if censdiv==0 & L2.censdiv==F2.censdiv & L2.censdiv!=. & F2.censdiv!=.
	replace censdiv=L.censdiv if censdiv==0 & L.censdiv==F.censdiv & L.censdiv!=. & F.censdiv!=.
	replace censdiv=L2.censdiv if censdiv==0 & L2.censdiv==F.censdiv & L2.censdiv!=. & F.censdiv!=.
	replace censdiv=L.censdiv if censdiv==0 & L.censdiv==F2.censdiv & L.censdiv!=. & F2.censdiv!=.
	replace censdiv=L2.censdiv if censdiv==0 & L2.censdiv==F2.censdiv & L2.censdiv!=. & F2.censdiv!=.

label define censdivL  ///
 	0 "Unknown Census division" ///	
	1 "New England" ///
	2 "Middle Atlantic" ///
	3 "East North Central" ///
	4 "West North Central" ///
	5 "South Atlantic" ///
	6 "East South Central" ///
	7 "West South Central" ///
	8 "Mountain" ///
	9 "Pacific"

label define stateL  ///
 	 0 "Unknown State" ///	
	 1 "Alabama" ///
	 2 "Arizona" ///
	 3 "Arkansas" ///
	 4 "California" ///
	 5 "Colorado" ///
	 6 "Connecticut" ///
	 7 "Delaware" ///
	 8 "District of Columbia" ///
	 9 "Florida" ///
 	10 "Georgia" ///	
	11 "Idaho" ///
	12 "Illinois" ///
	13 "Indiana" ///
	14 "Iowa" ///
	15 "Kansas" ///
	16 "Kentucky" ///
	17 "Louisiana" ///
	18 "Maine" ///
	19 "Maryland" ///
 	20 "Massachusetts" ///	
	21 "Michigan" ///
	22 "Minnesota" ///
	23 "Mississippi" ///
	24 "Missouri" ///
	25 "Montana" ///
	26 "Nebraska" ///
	27 "Nevada" ///
	28 "New Hampshire" ///
	29 "New Jersey" ///
	30 "New Mexico" ///
	31 "New York" ///
	32 "North Carolina" ///
	33 "North Dakota" ///
	34 "Ohio" ///
	35 "Oklahoma" ///
	36 "Oregon" ///
	37 "Pennsylvania" ///
	38 "Rhode Island" ///
	39 "South Carolina" ///
	40 "South Dakota" ///
	41 "Tennessee" ///
	42 "Texas" ///
	43 "Utah" ///
	44 "Vermont" ///
	45 "Virginia" ///
	46 "Washington" ///
	47 "West Virginia" ///
	48 "Wisconsin" ///
	49 "Wyoming" ///
	50 "Alaska" ///
	51 "Hawaii" 

label values censdiv	 censdivL	
label values state	 stateL


** Education-related

replace edyrs=. if edyrs==.m|edyrs==.s
replace edyrs=17 if edyrs>17 & edyrs!=. 

egen edmaxyrs=max(edyrs), by(personid)
	replace edmaxyrs=17 if edmaxyrs>=17 & edmaxyrs!=.

label variable edyrs "current completed schooling (years)"
label variable edmaxyrs "max education ever attained (years)"


gen educwrths=.
	replace educwrths=1 if edmaxyrs!=. & edmaxyrs<12
	replace educwrths=2 if edmaxyrs!=. & edmaxyrs==12
	replace educwrths=3 if edmaxyrs!=. & edmaxyrs>12 & edmaxyrs<16
	replace educwrths=4 if edmaxyrs!=. & edmaxyrs>=16
	
gen postgrad=0
	replace postgrad=1 if edmaxyrs!=. & edmaxyrs>16
	

label variable educwrths "max level of education"
label variable postgrad "=1 if max ed is beyond college"

label define educwrthsL  ///
	1 "HS dropout (max ed = 0-11 yrs)" ///
	2 "HS grad only (max ed = 12 yrs)" ///
	3 "Some college (max ed = 13-15 yrs)" ///
	4 "College grad (max ed = 16 yrs or more)" 

label values educwrths	 educwrthsL


** Age-related

replace age=. if age==.m|age==.s|age>=99|age<1

gen y = year-age if year!=. & age!=.

	** The "currentage" variable created
	** here always increases by 1 from one year
	** to the next. The original "age variable
	** usually does too, but there are exceptions.

sort personid year
by personid: egen birthyr=min(y)
drop y

gen currentage = year - birthyr
replace age=currentage if age==.

by personid: egen startage=min(currentage)

by personid: egen firstyr=min(year)

label variable birthyr "person's birth year (year-currentage)"
label variable startage "age when person entered dataset"
label variable firstyr "year when person entered dataset"
label variable currentage "age (consistent across years)"




** Creating variables for quartic in age

gen currentagesq=currentage^2
	gen currentagecube=currentagesq*currentage
	  gen currentagefourth=currentagecube*currentage

label variable currentagesq "currentage squared"
label variable currentagecube "currentage cubed"
label variable currentagefourth "currentage (4th power)"





**********************************************************************************************
* GROUPS                                                                                     *
*  white vs. non-white, birth cohort, education relative to high school (see above) and age *
**********************************************************************************************
gen white=100 if race==1
  replace white=200 if race>1
    replace race=7 if race>7
label variable white "white (=100) or non-white (=200)"
label define whiteL  ///
	1 "white" ///
	2 "non-white"  
label values white  whiteL


gen cohort=10 if birthyr<1944
  replace cohort=20 if birthyr>=1944 & birthyr<=1952
  replace cohort=30 if birthyr>=1953 & birthyr<=1960
  replace cohort=40 if birthyr>=1961
label variable cohort "birth cohort"
label define cohortL  ///
	10 "born pre-1944" ///
	20 "born 1944-1952" ///
	30 "born 1953-1960" ///
	40 "born post-1960" 
label values cohort  cohortL


gen group=white+cohort+educwrths
  drop if group>244
label variable group "= white (1st dig) + cohort (2nd) + educwrths (3rd)"






*************************************************
*  CREATE EARNINGS VARIABLES  			*
*						*
* Lower limits for inclusion (limits excluded):	*
*						*
*	Annual: $500 real earnings	 	*
*	Weekly: $100/week		 	*
*		   5 weeks		 	*
*	Hourly: $3/hr (real) 	 	 	*
*		   200 annual hours	 	*
*						*
* Not creating fearn, fwwage,	 		*
*   or fhwage if reports status	 		*
*   of student at next survey 	 		*
* Not creating fearn if reports	 		*
*   status as out of labor force, but		*
*   still can use fwwage, fhwage b/c 		*
*   they are earnings per time worked. 		*
*    						*
***********************************************

gen realearn=earnings*(237.017/cpi) 
	replace realearn=359116.9 if realearn!=. & realearn>359116.9
label variable realearn "prior year earnings, in 2015 dollars"

** Note: The maximum value reported in the PSID increased
** by a factor of 100 during the sample period, much faster
** than inflation. The restriction imposes the same topcode for 
** all years and is set at the minimum topcode across all years.
** This restriction affects 511 observations out of 141,435 
** (0.36 percent) for fearn.

gen lnrearn=ln(realearn) if realearn>500

gen hwage=realearn/annhrs if realearn/annhrs>3 & annhrs>200 
gen lhwage=ln(hwage)

** Note: $3/hr is about 1/2 of the lowest level of
** the real US federal minimum wage over this period,
** in 2015 dollars.

sort personid year

gen fearn=F2.lnrearn if F2.student!=1 & F2.OLF!=1
gen fhwage=F2.lhwage if F2.student!=1


label variable lnrearn "log real earnings last year (2015 dollars)"
label variable fearn "log real earnings next year (2015 dollars)"
label variable hwage "real hourly wage last year (2015 dollars)"
label variable lhwage "log real hourly wage last year (2015 dollars)"
label variable fhwage "log real hourly wage next year (2015 dollars)"






*********************************************************************
* CREATE SAMPLE:                                                             
*  At time of interview:
*	men
*  	aged 22-69 (so F2.earnings will be earned at ages 23-70)
*	responded to survey
*********************************************************************

drop if year<1970
drop if year==.

keep if male==1
drop if currentage==.
keep if currentage>21 & currentage<70

drop male






save "/Users/ethanballou/Documents/Data/LER_Draft2/FullData_Combined.dta", replace




