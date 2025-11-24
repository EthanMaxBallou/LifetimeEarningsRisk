clear all
set more off

do "1_DataLoading.do"
do "2_DataLabeling.do"
do "3_DataCleaning.do"
do "TenureOccInd.do"


do "4_GamAlphaCalc.do"
do "5_MixedRegConsolidate.do"


do "6_Analysis.do"
