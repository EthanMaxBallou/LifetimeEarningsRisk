
clear all
set more off

global Code "/Users/ethanballou/Documents/GitHub/LifetimeEarningsRisk/Final Code/SecondDraft/"



do "${Code}1_DataLoading.do"
do "${Code}2_DataLabeling.do"
do "${Code}3_DataCleaning.do"
do "${Code}TenureOccInd.do"

do "${Code}4_GamAlphaCalc.do"
do "${Code}5_MixedRegConsolidate.do"

do "${Code}6_Analysis.do"


