** THIS PROGRAM DEFINES MACROS TO KEEP TRACK OF VARIABLE LISTS

global DRAFT "Draft12"			
global DRAFT2 "Draft12"			
global DVLIST "fearn fwwage fhwage"	
global MAXORDER "0"				
global MODELLIST "A"			
global WINLVL "0.00001"

** DVLIST: list of earnings concepts for which volatility is measured
** MAXORDER: order of person-specific polynomial included in 1st stage
** MODELLIST: list of first-stage models to be run
** WINLVL: percentage of cases to be winsorized (from each end) in 2nd stage 


***REGRESSORS FOR FIRST-STAGE MODELS
	** 	NEED ONE XVEC[] FOR EACH MODEL				**
	**	[] CORRESPONDS TO MODEL NAME FROM MODELLIST	**

global xvec_A "i.agegrp##c.(ma5aep ma5aep2 tenure) i.agegrp#i.(group race cohort educwrths postgrad veteran over limited unemp OLF student noearn5 soc2010 twoind nojobinfo lowtenure tenmiss tenmiss26 self union hourly) c.year##i.(educwrths postgrad)"
	     
	****	Note: This is for earnings growth regressions. The
	**	specification also includes age, year, Census
	** 	division, and person fixed effects, as well as 
	**	"group"-specific quartic age-earnings profiles. (All 
	**	are estimated on the original pre-differenced data 
	**	in order to ensure consistency over time).

***REGRESSORS FOR SECOND-STAGE MODEL

global xvec4a  "c.(rGDPgrow PrRecess tenure) i.( unemp OLF student noearn5 soc2010 twoind nojobinfo tenureC tenmiss tenmiss26 self union hourly)"

global xvec4a2  "c.(rGDPgrow PrRecess tenure) i.( unemp OLF student noearn5 nojobinfo tenureC tenmiss tenmiss26 self union hourly)"

global xvec4b "c.(ma5aep ma5aep2) i.(race cohort educwrths postgrad veteran over limited censdiv) (i.futagegrp c.fyr c.year)#i.(educwrths postgrad ) i.futage i.year c.fyr"


	**** 	Note: xvec4a is interacted with fper, xvec4b is not.
	**	Specification also includes year and age dummies, the
	**	fixed effect from the first earnings regressions, and
	**	a quadratic in the mean value of "j+q" used to create
	**	the person-year mean (which differs across agents in
	**	part due to non-random attrition). xvec4a has the
	**	job-related varaibles from the earnings regressions, 
	**	and xvec4b has demographic varibles and others that 	
	**	change in perfectly predictable ways (like age, year) 
	**	, which is why they are not interacted with fper.
	**	xvec4a also adds a small number of dummies for low
	**	levels of tenure, recognizing that turnover rates are
	**	notably higher for workers with short tenure. 



***REGRESSORS FOR GROWTH RATE REGRESSIONS (like first stage)

global xvec_gr1 "c.(ma5aep ma5aep2 tenure) i.(race cohort educwrths postgrad veteran over limited unemp OLF student noearn5 soc2010 twoind nojobinfo lowtenure tenmiss tenmiss26 self union hourly censdiv tenureC)"

global xvec_gr3 "c.(rGDPgrow PrRecess) "

	**** 	Note: xvec_gr1 is not interacted and is nearly the
	** 	same as the specification from the 1st stage fearn 
	** 	(etc.) growth regressions. , xvec_gr3 interacts with 
	**	future periods and individuals' ages - this 
	**	represents variation in the effects of recessions 
	**	into future earnings. 


***REGRESSORS FOR AUTOREGRESSION

global xvec_AR "c.(ma5aep ma5aep2 tenure) i.(race cohort educwrths postgrad veteran over limited unemp OLF student noearn5 soc2010 twoind nojobinfo lowtenure tenmiss tenmiss26 self union hourly)"

	**** 	Note: Similar specification again except that here
	**	it excludes factors that change mechanically over
	**	time (age, year). No geographic dummies here either. 


*** MACROS TO KEEP TRACK OF VARIABLE LISTS

global xvlist "currentage currentagesq currentagecube currentagefourth group race white birthgrp cohort educwrths student over unemp OLF occ soc2010 twoind tenure lowtenure tenmiss tenmiss26 self both limited state censdiv year rGDPgrow PrRecess aep ma5aep ma5aep2 nojobinfo veteran union hourly postgrad noearn5 fearn0_P0 fwwage0_P0 fhwage0_P0 fearn1_P0 fearn1_P1 fwwage1_P0 fwwage1_P1 fhwage1_P0 fhwage1_P1"

global avlist "oneind agegrp edmaxyrs risktol relation"

global groupslist "111 112 113 114 121 122 123 124 131 132 133 134 141 142 143 144 211 212 213 214 221 222 223 224 231 232 233 234 241 242 243 244"


