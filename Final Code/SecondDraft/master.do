
clear all
set more off

global Code "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Final Code/SecondDraft/"



do "${Code}1_DataLoading.do"
do "${Code}2_DataLabeling.do"
do "${Code}3_DataCleaning.do"
do "${Code}3.1_TenureOccInd.do"

do "${Code}4_GamAlphaCalc.do"
do "${Code}5_MixedRegConsolidate.do"



* Run the full analysis once per earnings measure (fhwage = hourly wage,
* fearn = annual earnings). MEAS drives the DV selection and output naming
* inside 7_Analysis.do and 7.1_OtherTables.do.
foreach m in fhwage fearn {
    global MEAS "`m'"
    do "${Code}7_Analysis.do"
}

do "${Code}7.1_OtherTables.do"
