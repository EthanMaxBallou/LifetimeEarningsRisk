
label define ER10001L  ///
       1 "Release number 1 - April 1999"  ///
       2 "Release number 2 - May 1999"  ///
       3 "Release number 3- June 1999"  ///
       4 "Release number 4 - May 2008"  ///
       5 "Release number 5 - November 2013"  ///
       6 "Release number 6 - January 2016"  ///
       7 "Release number 7 - March 2016"

forvalues n = 1/56 {
    label define ER10004L `n' "Actual state (FIPS code)"  , modify
}
label define ER10004L       99 "DK; NA"  , modify
label define ER10004L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER10010L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/51 {
    label define ER12221L `n' "Actual state (PSID State code)"  , modify
}
label define ER12221L       99 "DK; NA"  , modify
label define ER12221L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER13001L  ///
       1 "Release number 1 - August 2001"  ///
       2 "Release number 2 - October 2001"  ///
       3 "Release number 3 - January 2002"  ///
       4 "Release number 4 - May 2008"  ///
       5 "Release number 5 - November 2013"  ///
       6 "Release number 6 - February 2014"  ///
       7 "Release number 7 - January 2016"  ///
       8 "Release number 8 - November 2017"  ///
       9 "Release number 9 - June 2023"

forvalues n = 1/51 {
    label define ER13004L `n' "Actual state (PSID State code)"  , modify
}
label define ER13004L       99 "DK; NA"  , modify
label define ER13004L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER13005L `n' "Actual state (FIPS code)"  , modify
}
label define ER13005L       99 "DK; NA"  , modify
label define ER13005L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER13011L  ///
       1 "Male"  ///
       2 "Female"

label define ER17001L  ///
       1 "Release number 1 - November 2002"  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - November 2013"  ///
       4 "Release number 4 - February 2014"  ///
       5 "Release number 5 - January 2016"  ///
       6 "Release number 6 - November 2017"  ///
       7 "Release number 7 - June 2023"

forvalues n = 1/51 {
    label define ER17004L `n' "Actual state (PSID State code)"  , modify
}
label define ER17004L       99 "DK; NA"  , modify
label define ER17004L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER17005L `n' "Actual state (FIPS code)"  , modify
}
label define ER17005L       99 "DK; NA"  , modify
label define ER17005L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER17014L  ///
       1 "Male"  ///
       2 "Female"

label define ER2001L  ///
       1 "Release number 1 - August 1995"  ///
       2 "Release number 2 - January 2003"  ///
       3 "Release number 3 - March 2004"  ///
       4 "Release number 4 - May 2008"  ///
       5 "Release number 5 - November 2013"  ///
       6 "Release number 6 - January 2016"

forvalues n = 14/96 {
    label define ER2007L `n' "Actual age"  , modify
}
label define ER2007L       97 "Ninety-seven years of age or older"  , modify
label define ER2007L        0 "Wild code"  , modify
label define ER2007L       99 "NA; DK"  , modify

label define ER2008L  ///
       1 "Male"  ///
       2 "Female"  ///
       0 "Wild code"

label define ER21001L  ///
       1 "Release number 1 - December 2004"  ///
       2 "Release number 2 - October 2005"  ///
       3 "Release number 3 - November 2005"  ///
       4 "Release number 4 - May 2008"  ///
       5 "Release number 5 - November 2013"  ///
       6 "Release number 6 - February 2014"  ///
       7 "Release number 7 - January 2016"  ///
       8 "Release number 8 - November 2017"  ///
       9 "Release number 9 - June 2023"

forvalues n = 1/51 {
    label define ER21003L `n' "Actual state (PSID State code)"  , modify
}
label define ER21003L       99 "DK; NA"  , modify
label define ER21003L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER21004L `n' "Actual state (FIPS code)"  , modify
}
label define ER21004L       99 "DK; NA"  , modify
label define ER21004L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER21018L  ///
       1 "Male"  ///
       2 "Female"

label define ER25001L  ///
       1 "Release number 1, March 2007"  ///
       2 "Release number 2, May 2007"  ///
       3 "Release number 3, November 2013"  ///
       4 "Release number 4, February 2014"  ///
       5 "Release number 5, January 2016"  ///
       6 "Release number 6, November 2017"  ///
       7 "Release number 7, June 2023"

forvalues n = 1/51 {
    label define ER25003L `n' "Actual state (PSID State code)"  , modify
}
label define ER25003L       99 "DK; NA"  , modify
label define ER25003L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER25004L `n' "Actual state (FIPS code)"  , modify
}
label define ER25004L       99 "DK; NA"  , modify
label define ER25004L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER25018L  ///
       1 "Male"  ///
       2 "Female"

label define ER30000L  ///
       1 "Release number 1, May 2025"

label define ER30003L  ///
       1 "Head"  ///
       2 `"Wife/"Wife""'  ///
       3 "Son or daughter"  ///
       4 "Brother or sister"  ///
       5 "Father or mother"  ///
       6 "Grandchild, niece, nephew, other relatives under 18"  ///
       7 "Other, including in-laws, other adult relatives"  ///
       8 "Husband or Wife of Head who moved out or died in the year prior to the 1968 interview"  ///
       9 "NA"  ///
       0 "Individual from core sample who was born or moved in after the 1968 interview; individual from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308)"

forvalues n = 1/16 {
    label define ER30010L `n' "Highest grade or year of schooling completed"  , modify
}
label define ER30010L       17 "At least one year of postgraduate work"  , modify
label define ER30010L       99 "NA; DK"  , modify
label define ER30010L        0 "Preschool; born or moved in after the 1968 interview or individual from Immigrant or Latino samples (ER30003=0); still in school (ER30009=1 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30021L `n' "Individuals in the family at the time of the 1969 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30021L `n' "Individuals in institutions at the time of the 1969 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30021L `n' "Individuals who moved out of the FU or out of institutions between the 1968 and 1969 interviews but who were not included in another responding FU for 1969. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30021L `n' "Individuals living in 1968 but who died by the time of the 1969 interview"  , modify
}
label define ER30021L        0 "Born or moved in after the 1969 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse for 1969 or mover-out nonresponse in 1968 (ER30020=0)"  , modify

label define ER30022L  ///
       1 "Head in 1969; 1968 Head who was mover-out nonresponse by the time of the 1969 interview"  ///
       2 "Wife in 1969; 1968 Wife who was mover-out nonresponse by the time of the 1969 interview"  ///
       3 "Son or daughter, including stepchildren and foster children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative, including in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1969 interview (ER30020>0 and ER30021=0); main family nonresponse for 1969 or mover-out nonresponse from 1968 (ER30020=0)"

forvalues n = 1/20 {
    label define ER30044L `n' "Individuals in the family at the time of the 1970 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30044L `n' "Individuals in institutions at the time of the 1970 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30044L `n' "Individuals who moved out of the FU or out of institutions between the 1969 and 1970 interviews but who were not included in another responding FU for 1970. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30044L `n' "Individuals who were living in 1969 but who died by the time of the 1970 interview"  , modify
}
label define ER30044L        0 "Inap.:  born or moved in after the 1970 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1970 or mover-out nonresponse by 1969 (ER30043=0)"  , modify

label define ER30045L  ///
       1 "Head in 1970; 1969 Head who was mover-out nonresponse by the time of the 1970 interview"  ///
       2 "Wife in 1970; 1969 Wife who was mover-out nonresponse by the time of the 1970 interview"  ///
       3 "Child, stepchild"  ///
       4 "Sibling"  ///
       5 "Parent"  ///
       6 "Grandchild, great-grandchild"  ///
       7 "In-law or other relative"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1970 interview (ER30043>0 and ER30044=0); main family nonresponse by 1970 or mover-out nonresponse by 1969 (ER30043=0)"

forvalues n = 1/17 {
    label define ER30052L `n' "Highest grade or year of school completed"  , modify
}
label define ER30052L       99 "NA; DK"  , modify
label define ER30052L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1970 interview (ER30043>0 and ER30044=0); main family nonresponse by 1970 or mover-out nonresponse by 1969 (ER30043=0); Head or Wife in 1970 (ER30044=1-20 and ER30045=1 or 02); did not stop school or individual was age 25 or older (ER30051=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30068L `n' "Individuals in the family at the time of the 1971 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30068L `n' "Individuals in institutions at the time of the 1971 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30068L `n' "Individuals who moved out of the FU or out of institutions between the 1970 and 1971 interviews but who were not included in another responding FU for 1971. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30068L `n' "Individuals who were living in 1970 but died by the time of the 1971 interview"  , modify
}
label define ER30068L        0 "Inap.:  born or moved in after the 1971 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1971 or mover-out nonresponse by 1970 (ER30067=0)"  , modify

label define ER30069L  ///
       1 "Head in 1971; 1970 Head who was mover-out nonresponse by the time of the 1971 interview"  ///
       2 "Wife in 1971; 1970 Wife who was mover-out nonresponse by the time of the 1971 interview"  ///
       3 "Child, stepchild"  ///
       4 "Sibling"  ///
       5 "Parent"  ///
       6 "Grandchild, great-grandchild"  ///
       7 "In-law or other relative"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of family)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1971 interview (ER30067>0 and ER30068=0); main family nonresponse by 1971 or mover-out nonresponse by 1970 (ER30067=0)"

forvalues n = 1/17 {
    label define ER30076L `n' "Highest grade or year of school completed"  , modify
}
label define ER30076L       99 "NA; DK"  , modify
label define ER30076L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1971 interview (ER30067>0 and ER30068=0); main family nonresponse by 1971 or mover-out nonresponse by 1970 (ER30067=0); Head or Wife in 1971 (ER30068=1-20 and ER30069=1 or 02); did not stop school or individual was age 25 or older (ER30075=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30092L `n' "Individuals in the family at the time of the 1972 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30092L `n' "Individuals in institutions at the time of the 1972 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30092L `n' "Individuals who moved out of the FU or out of institutions between the 1971 and 1972 interviews but who were not included in another responding FU for 1972. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30092L `n' "Individuals who were living in 1971 but who died by the time of the 1972 interview"  , modify
}
label define ER30092L        0 "Inap.:  born or moved in after the 1972 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1972 or mover-out nonresponse by 1971 (ER30091=0)"  , modify

label define ER30093L  ///
       1 "Head in 1972; 1971 Head who was mover-out nonresponse by the time of the 1972 interview"  ///
       2 "Wife in 1972; 1971 Wife who was mover-out nonresponse by the time of the 1972 interview"  ///
       3 "Child, stepchild"  ///
       4 "Sibling"  ///
       5 "Parent"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of the family)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1972 interview (ER30091>0 and ER30092=0); main family nonresponse by 1972 or mover-out nonresponse by 1971 (ER30091=0)"

forvalues n = 1/17 {
    label define ER30100L `n' "Highest grade or year of school completed"  , modify
}
label define ER30100L       99 "NA; DK"  , modify
label define ER30100L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1972 interview (ER30091>0 and ER30092=0); main family nonresponse by 1972 or mover-out nonresponse by 1971 (ER30091=0); Head or Wife in 1972 (ER30092=1-20 and ER30093=1 or 02); did not stop school or individual was age 25 or older (ER30099=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30118L `n' "Individuals in FU at the time of the 1973 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30118L `n' "Individuals in institutions at the time of the 1973 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30118L `n' "Individuals who moved out of the FU or out of institutions between the 1972 and 1973 interviews but who were not included in another responding FU for 1973. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30118L `n' "Individuals who were living in 1972 but who died by the time of the 1973 interview"  , modify
}
label define ER30118L        0 "Inap.:  born or moved in after the 1973 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1973 or mover-out nonresponse by 1972 (ER30117=0)"  , modify

label define ER30119L  ///
       1 "Head in 1973; 1972 Head who was mover-out nonresponse by the time of the 1973 interview"  ///
       2 "Wife in 1973; 1972 Wife who was mover-out nonresponse by the time of the 1973 interview"  ///
       3 "Son or daughter; includes stepchildren or adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1973 interview (ER30117>0 and ER30118=0); main family nonresponse by 1973 or mover-out nonresponse by 1972 (ER30117=0)"

forvalues n = 1/17 {
    label define ER30126L `n' "Highest grade or year of school completed"  , modify
}
label define ER30126L       99 "NA; DK"  , modify
label define ER30126L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1973 or mover-out nonresponse by 1972 (ER30117=0); Head or Wife in 1973 (ER30118=1-20 and ER30119=1 or 02); born or moved in after the 1973 interview (ER30117>0 and ER30118=0); did not stop school or individual was age 25 or older (ER30125=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30139L `n' "Individuals in FU at the time of 1974 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30139L `n' "Individuals in institutions at the time of the 1974 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30139L `n' "Individuals who moved out of the FU or out of institutions between the 1973 and 1974 interviews but who were not included in another responding FU for 1974. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30139L `n' "Individuals who were living in 1973 but who died by the time of the 1974 interview"  , modify
}
label define ER30139L        0 "Inap.:  born or moved in after the 1974 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1974 or mover-out nonresponse by 1973 (ER30138=0)"  , modify

label define ER30140L  ///
       1 "Head in 1974; 1973 Head who was mover-out nonresponse by the time of the 1974 interview"  ///
       2 "Wife in 1974; 1973 Wife who was mover-out nonresponse by the time of the 1974 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1974 interview (ER30138>0 and ER30139=0); main family nonresponse by 1974 or mover-out nonresponse by 1973 (ER30138=0)"

forvalues n = 1/17 {
    label define ER30147L `n' "Highest grade or year of school completed"  , modify
}
label define ER30147L       99 "NA; DK"  , modify
label define ER30147L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1974 interview (ER30138>0 and ER30139=0); main family nonresponse by 1974 or mover-out nonresponse by 1973 (ER30138=0); Head or Wife in 1974 (ER30139=1-20 and ER30140=1 or 02); did not stop school or individual was age 25 or older (ER30146=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30161L `n' "Individuals in FU at the time of the 1975 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30161L `n' "Individuals in institutions at the time of the 1975 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30161L `n' "Individuals who moved out of the FU or out of institutions between the 1974 and 1975 interviews but who were not included in another responding FU for 1975. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30161L `n' "Individuals who were living in 1974 but who died by the time of the 1975 interview"  , modify
}
label define ER30161L        0 "Inap.:  born or moved in after the 1975 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1975 or mover-out nonresponse by 1974 (ER30160=0)"  , modify

label define ER30162L  ///
       1 "Head in 1975; 1974 Head who was mover-out nonresponse by the time of the 1975 interview"  ///
       2 "Wife in 1975; 1974 Wife who was mover-out nonresponse by the time of the 1975 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1975 interview (ER30160>0 and ER30161=0); main family nonresponse by 1975 or mover-out nonresponse by 1974 (ER30160=0)"

forvalues n = 1/17 {
    label define ER30169L `n' "Highest grade or year of school completed"  , modify
}
label define ER30169L       99 "NA; DK"  , modify
label define ER30169L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1975 or mover-out nonresponse by 1974 (ER30160=0); born or moved in after the 1975 interview (ER30160>0 and ER30161=0); Head or Wife in 1975 (ER30161=1-20 and ER30162=1 or 02); did not stop school or not a person under 25 (ER30168=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30189L `n' "Individuals in FU at the time of the 1976 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30189L `n' "Individuals in institutions at the time of the 1976 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30189L `n' "Individuals who moved out of the FU or out of institutions between the 1975 and 1976 interviews but were not included in another responding FU for 1976. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30189L `n' "Individuals who were living in 1975 but who died by the time of the 1976 interview"  , modify
}
label define ER30189L        0 "Inap.:  born or moved in after the 1976 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1976 or mover-out nonresponse by 1975 (ER30188=0)"  , modify

label define ER30190L  ///
       1 "Head in 1976; 1975 Head who was mover-out nonresponse by the time of the 1976 interview"  ///
       2 "Wife in 1976; 1975 Wife who was mover-out nonresponse by the time of the 1976 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1976 interview (ER30188>0 and ER30189=0); main family nonresponse by 1976 or mover-out nonresponse by 1975 (ER30188=0)"

forvalues n = 1/17 {
    label define ER30197L `n' "Highest grade or year of school completed"  , modify
}
label define ER30197L       99 "NA; DK"  , modify
label define ER30197L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1976 or mover-out nonresponse by 1975 (ER30188=0); born or moved in after the 1976 interview (ER30188>0 and ER30189=0); did not stop school or other individual age 25 or older (ER30189=1-20, ER30190=1 or 02 and ER30196=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30218L `n' "Individuals in FU at the time of the 1977 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30218L `n' "Individuals in institutions at the time of the 1977 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30218L `n' "Individuals who moved out of the FU or out of institutions between the 1976 and 1977 interviews but who were not included in another responding FU for 1977. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30218L `n' "Individuals who were living in 1976 but who died by the time of the 1977 interview"  , modify
}
label define ER30218L        0 "Inap.:  born or moved in after the 1977 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1977 or mover-out nonresponse by 1976 (ER30217=0)"  , modify

label define ER30219L  ///
       1 "Head in 1977; 1976 Head who was mover-out nonresponse by the time of the 1977 interview"  ///
       2 "Wife in 1977; 1976 Wife who was mover-out nonresponse by the time of the 1977 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1977 interview (ER30217>0 and ER30218=0); main family nonresponse by 1977 or mover-out nonresponse by 1976 (ER30217=0)"

forvalues n = 1/17 {
    label define ER30226L `n' "Highest grade or year of school completed"  , modify
}
label define ER30226L       99 "NA; DK"  , modify
label define ER30226L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1977 interview (ER30217>0 and ER30218=0); main family nonresponse by 1977 or mover-out nonresponse by 1976 (ER30217=0); did not stop school or other individual age 25 or older (ER30218=1-20, ER30219=1 or 20 and ER30225=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30247L `n' "Individuals in FU at the time of the 1978 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30247L `n' "Individuals in institutions at the time of the 1978 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30247L `n' "Individuals who moved out of the FU or out of institutions between the 1977 and 1978 interviews but who were not included in another responding FU for 1978. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30247L `n' "Individuals who were living in 1977 but who died by the time of the 1978 interview"  , modify
}
label define ER30247L        0 "Inap.:  born or moved in after the 1978 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1978 or mover-out nonresponse by 1977 (ER30246=0)"  , modify

label define ER30248L  ///
       1 "Head in 1978; 1977 Head who was mover-out nonresponse by the time of the 1978 interview"  ///
       2 "Wife in 1978; 1977 Wife who was mover-out nonresponse by the time of the 1978 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1978 interview (ER30246>0 and ER30247=0); main family nonresponse by 1978 or mover-out nonresponse by 1977 (ER30246=0)"

forvalues n = 1/17 {
    label define ER30255L `n' "Highest grade or year of school completed"  , modify
}
label define ER30255L       99 "NA; DK"  , modify
label define ER30255L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1978 interview (ER30246>0 and ER30247=0); main family nonresponse by 1978 or mover-out nonresponse by 1977 (ER30246=0); did not stop school or other individual was age 25 or older (ER30247=1-20, ER30248=1 or 02 and ER30254=5 or 9)"  , modify

forvalues n = 1/20 {
    label define ER30284L `n' "Individuals in the family at the time of the 1979 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30284L `n' "Individuals in institutions at the time of the 1979 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30284L `n' "Individuals who moved out of the FU or out of institutions between the 1978 and 1979 interviews but who were not included in another responding FU for 1979. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30284L `n' "Individuals who were living in 1978 but who died by the time of the 1978 interview"  , modify
}
label define ER30284L        0 "Inap.:  born or moved in after the 1979 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1979 or mover-out nonresponse by 1978 (ER30283=0)"  , modify

label define ER30285L  ///
       1 "Head in 1979; 1978 Head who was mover-out nonresponse by the time of the 1979 interview"  ///
       2 "Wife in 1979; 1978 Wife who was mover-out nonresponse by the time of the 1979 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative, includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1979 interview (ER30283>0 and ER30284=0); main family nonresponse by 1979 or mover-out nonresponse by 1978 (ER30283=0)"

forvalues n = 1/17 {
    label define ER30296L `n' "Highest grade or year of school completed"  , modify
}
label define ER30296L       99 "NA; DK"  , modify
label define ER30296L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1979 interview (ER30283>0 and ER30284=0); main family nonresponse by 1979 or mover-out nonresponse by 1978 (ER30283=0); in institution in both 1978 and 1979 (ER30284=51-59 and ER30288=0); not a person aged 16 or older (ER30286=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30314L `n' "Individuals in the family at the time of the 1980 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30314L `n' "Individuals in institutions at the time of the 1980 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30314L `n' "Individuals who moved out of the FU or out of institutions between the 1979 and 1980 interviews but who were not included in another responding FU for 1980. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30314L `n' "Individuals who were living in 1979 but who died by the time of the 1980 interview"  , modify
}
label define ER30314L        0 "Inap.:  born or moved in after the 1980 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1980 or mover-out nonresponse by 1979 (ER30313=0)"  , modify

label define ER30315L  ///
       1 "Head in 1980; 1979 Head who was mover-out nonresponse by the time of the 1980 interview"  ///
       2 "Wife in 1980; 1979 Wife who was mover-out nonresponse by the time of the 1980 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Mother or father of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1980 interview (ER30313>0 and ER30314=0); main family nonresponse by 1980 or mover-out nonresponse by 1979 (ER30313=0)"

forvalues n = 1/17 {
    label define ER30326L `n' "Highest grade or year of school completed"  , modify
}
label define ER30326L       99 "NA; DK"  , modify
label define ER30326L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1980 interview (ER30313>0 and ER30314=0); main family nonresponse by 1980 or mover-out nonresponse by 1979 (ER30313=0); in an institution in both 1979 and 1980 (ER30314=51-59 and ER30318=0); not a person aged 16 or older (ER30316=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30344L `n' "Individuals in the family at the time of the 1981 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30344L `n' "Individuals in institutions at the time of the 1981 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30344L `n' "Individuals who moved out of the FU or out of institutions between the 1980 and 1981 interviews but who were not included in another responding FU for 1981. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30344L `n' "Individuals who were living in 1980 but who died by the time of the 1981 interview"  , modify
}
label define ER30344L        0 "Inap.:  born or moved in after the 1981 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1981 or splitoff nonresponse by 1980 (ER30343=0)"  , modify

label define ER30345L  ///
       1 "Head in 1981; 1980 Head who was mover-out nonresponse by the time of the 1981 interview"  ///
       2 "Wife in 1981; 1980 Wife who was mover-out nonresponse by the time of the 1981 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1981 interview (ER30343>0 and ER30344=0); main family nonresponse by 1981 or mover-out nonresponse by 1980 (ER30343=0)"

forvalues n = 1/17 {
    label define ER30356L `n' "Highest grade or year of school completed"  , modify
}
label define ER30356L       99 "NA; DK"  , modify
label define ER30356L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1981 interview (ER30343>0 and ER30344=0); main family nonresponse by 1981 or mover-out nonresponse by 1980 (ER30343=0); in an institution in both 1980 and 1981 (ER30344=51-59 and ER30348=0); not a person aged 16 or older (ER30346=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30374L `n' "Individuals in the family at the time of the 1982 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30374L `n' "Individuals in institutions at the time of the 1982 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30374L `n' "Individuals who moved out of the FU or out of institutions between the 1981 and 1982 interviews but who were not included in another responding FU for 1982. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30374L `n' "Individuals who were living in 1981 but died by the time of the 1982 interview"  , modify
}
label define ER30374L        0 "Inap.:  born or moved in after the 1982 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1982 or mover-out nonresponse by 1981 (ER30373=0)"  , modify

label define ER30375L  ///
       1 "Head in 1982; 1981 Head who was mover-out nonresponse by the time of the 1982 interview"  ///
       2 "Wife in 1982; 1981 Wife who was mover-out nonresponse by the time of the 1982 interview"  ///
       3 "Son or daughter; includes stepchildren and adopted children"  ///
       4 "Brother or sister of Head"  ///
       5 "Father or mother of Head"  ///
       6 "Grandchild or great-grandchild"  ///
       7 "Other relative; includes in-laws"  ///
       8 "Nonrelative"  ///
       9 "Husband of Head (i.e., Wife was Head of FU)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1982 interview (ER30373>0 and ER30374=0); main family nonresponse by 1982 or mover-out nonresponse by 1981 (ER30373=0)"

forvalues n = 1/17 {
    label define ER30384L `n' "Highest grade or year of school completed"  , modify
}
label define ER30384L       99 "NA; DK"  , modify
label define ER30384L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1982 interview (ER30373>0 and ER30374=0); main family nonresponse by 1982 or mover-out nonresponse by 1981 (ER30373=0); in an institution in both 1981 and 1982 (ER30374=51-59 and ER30378=0); not a person aged 16 or older (ER30376=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30400L `n' "Individuals in the family at the time of the 1983 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30400L `n' "Individuals in institutions at the time of the 1983 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30400L `n' "Individuals who moved out of the FU or out of institutions between the 1982 and 1983 interviews but who were not included in another responding FU for 1983. All such individuals were nonresponse."  , modify
}
forvalues n = 81/89 {
    label define ER30400L `n' "Individuals who were living in 1982 but died by the time of the 1983 interview"  , modify
}
label define ER30400L        0 "Inap.:  born or moved in after the 1983 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1983 or mover-out nonresponse by 1982 (ER30399=0)"  , modify

label define ER30401L  ///
      10 "Head in 1983; 1982 Head who was mover-out nonresponse by the time of the 1983 interview"  ///
      20 "Legal Wife in 1983; 1982 Wife who was mover-out nonresponse by the time of the 1983 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1981 family, since consecutive interviews may be taken less or more than twelve months apart; 1982 "Wife" who was mover-out nonresponse by the time of the 1983 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20),  but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1983 interview (ER30399>0 and ER30400=0); main family nonresponse by 1983 or mover-out nonresponse by 1982 (ER30399=0)"

forvalues n = 1/17 {
    label define ER30413L `n' "Highest grade or year of school completed"  , modify
}
label define ER30413L       99 "NA; DK"  , modify
label define ER30413L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1983 interview (ER30399>0 and ER30400=0); main family nonresponse by 1983 or mover-out nonresponse by 1982 (ER30399=0); in an institution in both 1982 and 1983 (ER30400=51-59 and ER30406=0); not a person aged 16 or older (ER30402=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30430L `n' "Individuals in the family at the time of the 1984 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30430L `n' "Individuals in institutions at the time of the 1984 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30430L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1983 and 1984 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30430L `n' "Individuals who were living in 1983 but died by the time of the 1984 interview"  , modify
}
label define ER30430L        0 "Inap.:  born or moved in after the 1984 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1984 or mover-out nonresponse by 1983 (ER30429=0)"  , modify

label define ER30431L  ///
      10 "Head in 1984; 1983 Head who was mover-out nonresponse by the time of the 1984 interview"  ///
      20 "Legal Wife in 1984; 1983 Wife who was mover-out nonresponse by the time of the 1984 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1982 family, since consecutive interviews may be taken less or more than twelve months apart; 1983 "Wife" who was mover-out nonresponse by the time of the 1984 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1984 interview (ER30429>0 and ER30430=0); main family nonresponse by 1984 or mover-out nonresponse by 1983 (ER30429=0)"

forvalues n = 1/17 {
    label define ER30443L `n' "Highest grade or year of school completed"  , modify
}
label define ER30443L       99 "NA; DK"  , modify
label define ER30443L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1984 interview (ER30429>0 and ER30430=0); main family nonresponse by 1984 or mover-out nonresponse by 1983 (ER30429=0); in an institution in both 1983 and 1984 (ER30430=51-59 and ER30436=0); not a person aged 16 or older (ER30432=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30464L `n' "Individuals in the family at the time of the 1985 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30464L `n' "Individuals in institutions at the time of the 1985 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30464L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1984 and 1985 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30464L `n' "Individuals who were living in 1984 but died by the time of the 1985 interview"  , modify
}
label define ER30464L        0 "Inap.:  born or moved in after the 1985 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1985 or mover-out nonresponse by 1984 (ER30463=0)"  , modify

label define ER30465L  ///
      10 "Head in 1985; 1984 Head who was mover-out nonresponse by the time of the 1985 interview"  ///
      20 "Legal Wife in 1985; 1984 Wife who was mover-out nonresponse by the time of the 1985 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1983 family, since consecutive interviews may be taken less or more than twelve months apart; 1984 "Wife" who was mover-out nonresponse by the time of the 1985 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1985 interview (ER30463>0 and ER30464=0); main family nonresponse by 1985 or mover-out nonresponse by 1984 (ER30463=0)"

forvalues n = 1/17 {
    label define ER30478L `n' "Highest grade or year of school completed"  , modify
}
label define ER30478L       99 "NA; DK"  , modify
label define ER30478L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1985 interview (ER30463>0 and ER30464=0); main family nonresponse by 1985 or mover-out nonresponse by 1984 (ER30463=0); in an institution in both 1984 and 1985 (ER30464=51-59 and ER30470=0); not a person aged 16 or older (ER30466=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30499L `n' "Individuals in the family at the time of the 1986 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30499L `n' "Individuals in institutions at the time of the 1986 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30499L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1985 and 1986 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30499L `n' "Individuals who were living in 1985 but died by the time of the 1986 interview"  , modify
}
label define ER30499L        0 "Inap.:  born or moved in after the 1986 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1986 or mover-out nonresponse by 1985 (ER30498=0)"  , modify

label define ER30500L  ///
      10 "Head in 1986; 1985 Head who was mover-out nonresponse by the time of the 1986 interview"  ///
      20 "Legal Wife in 1986; 1985 Wife who was mover-out nonresponse by the time of the 1986 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1985 family, since consecutive interviews may be taken less or more than twelve months apart; 1985 "Wife" who was mover-out nonresponse by the time of the 1986 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1986 interview (ER30498>0 and ER30499=0); main family nonresponse by 1986 or mover-out nonresponse by 1985 (ER30498=0)"

forvalues n = 1/17 {
    label define ER30513L `n' "Highest grade or year of school completed"  , modify
}
label define ER30513L       99 "NA; DK"  , modify
label define ER30513L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1986 interview (ER30498>0 and ER30499=0); main family nonresponse by 1986 or mover-out nonresponse by 1985 (ER30498=0); in an institution in both 1985 and 1986 (ER30499=51-59 and ER30505=0); not a person aged 16 or older (ER30501=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30536L `n' "Individuals in the family at the time of the 1987 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30536L `n' "Individuals in institutions at the time of the 1987 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30536L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1986 and 1987 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30536L `n' "Individuals who were living in 1986 but died by the time of the 1987 interview"  , modify
}
label define ER30536L        0 "Inap.:  born or moved in after the 1987 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1987 or mover-out nonresponse by 1986 (ER30535=0)"  , modify

label define ER30537L  ///
      10 "Head in 1987; 1986 Head who was mover-out nonresponse by the time of the 1987 interview"  ///
      20 "Legal Wife in 1987; 1986 Wife who was mover-out nonresponse by the time of the 1987 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1986 family, since consecutive interviews may be taken less or more than twelve months apart; 1986 "Wife" who was mover-out nonresponse by the time of the 1987 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1987 interview (ER30535>0 and ER30536=0); main family nonresponse by 1987 or mover-out nonresponse by 1986 (ER30535=0)"

forvalues n = 1/17 {
    label define ER30549L `n' "Highest grade or year of school completed"  , modify
}
label define ER30549L       99 "NA; DK"  , modify
label define ER30549L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1987 interview (ER30535>0 and ER30536=0); main family nonresponse by 1987 or mover-out nonresponse by 1986 (ER30535=0); in an institution in both 1986 and 1987 (ER30536=51-59 and ER30542=0); not a person aged 16 or older (ER30538=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30571L `n' "Individuals in the family at the time of the 1988 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30571L `n' "Individuals in institutions at the time of the 1988 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30571L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1987 and 1988 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30571L `n' "Individuals who were living in 1987 but died by the time of the 1988 interview"  , modify
}
label define ER30571L        0 "Inap.:  born or moved in after the 1988 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1988 or mover-out nonresponse by 1987 (ER30570=0)"  , modify

label define ER30572L  ///
      10 "Head in 1988; 1987 Head who was mover-out nonresponse by the time of the 1988 interview"  ///
      20 "Legal Wife in 1988; 1987 Wife who was mover-out nonresponse by the time of the 1988 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1987 family, since consecutive interviews may be taken less or more than twelve months apart; 1987 "Wife" who was mover-out nonresponse by the time of the 1988 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1988 interview (ER30570>0 and ER30571=0); main family nonresponse by 1988 or mover-out nonresponse by 1987 (ER30570=0)"

forvalues n = 1/17 {
    label define ER30584L `n' "Highest grade or year of school completed"  , modify
}
label define ER30584L       99 "NA; DK"  , modify
label define ER30584L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1988 or mover-out nonresponse by 1987 (ER30570=0); born or moved in after the 1988 interview (ER30570>0 and ER30571=0); in an institution in both 1987 and 1988 (ER30571=51-59 and ER30577=0); not a person aged 16 or older (ER30573=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30607L `n' "Individuals in the family at the time of the 1989 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30607L `n' "Individuals in institutions at the time of the 1989 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30607L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1988 and 1989 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30607L `n' "Individuals who were living in 1988 but died by the time of the 1989 interview"  , modify
}
label define ER30607L        0 "Inap.:  born or moved in after the 1989 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1989 or mover-out nonresponse by 1988 (ER30606=0)"  , modify

label define ER30608L  ///
      10 "Head in 1989; 1988 Head who was mover-out nonresponse by the time of the 1989 interview"  ///
      20 "Legal Wife in 1989; 1988 Wife who was mover-out nonresponse by the time of the 1989 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1988 family, since consecutive interviews may be taken less or more than twelve months apart; 1988 "Wife" who was mover-out nonresponse by the time of the 1989 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1989 interview (ER30606>0 and ER30607=0); main family nonresponse by 1989 or mover-out nonresponse by 1988 (ER30606=0)"

forvalues n = 1/17 {
    label define ER30620L `n' "Highest grade or year of school completed"  , modify
}
label define ER30620L       99 "NA; DK"  , modify
label define ER30620L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); born or moved in after the 1989 interview (ER30606>0 and ER30607=0); main family nonresponse by 1989 or mover-out nonresponse by 1988 (ER30606=0); in an institution in both 1988 and 1989 (ER30607=51-59 and ER30613=0); not a person aged 16 or older (ER30609=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30643L `n' "Individuals in the family at the time of the 1990 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30643L `n' "Individuals in institutions at the time of the 1990 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30643L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1989 and 1990 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30643L `n' "Individuals who were living in 1989 but died by the time of the 1990 interview"  , modify
}
label define ER30643L        0 "Inap.:  born or moved in after the 1990 interview; from Immigrant or Latino recontact sample (ER30001=3001-3511,4001-4851, 9044-9308); main family nonresponse by 1990 or mover-out nonresponse by 1989 (ER30642=0)"  , modify

label define ER30644L  ///
      10 "Head in 1990; 1989 Head who was mover-out nonresponse by the time of the 1990 interview"  ///
      20 "Legal Wife in 1990; 1989 Wife who was mover-out nonresponse by the time of the 1990 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1989 family, since consecutive interviews may be taken less or more than twelve months apart; 1989 "Wife" who was mover-out nonresponse by the time of the 1990 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino recontact sample (ER30001=3001-3511,4001-4851, 9044-9308); main family nonresponse by 1990 or mover-out nonresponse by 1989 (ER30642=0); born or moved in after the 1990 interview (ER30642>0 and ER30643=0)"

forvalues n = 1/17 {
    label define ER30657L `n' "Highest grade or year of school completed"  , modify
}
label define ER30657L       99 "NA; DK"  , modify
label define ER30657L        0 "Inap.:  from Immigrant or Latino recontact sample (ER30001=3001-3511,4001-4851, 9044-9308); main family nonresponse by 1990 or mover-out nonresponse by 1989 (ER30642=0); born or moved in after the 1990 interview (ER30642>0 and ER30643=0); in an institution in both 1989 and 1990 (ER30643=51-59 and ER30649=0); not a person aged 16 or older (ER30645=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30690L `n' "Individuals in the family at the time of the 1991 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30690L `n' "Individuals in institutions at the time of the 1991 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30690L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1990 and 1991 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30690L `n' "Individuals who were living in 1990 but died by the time of the 1991 interview"  , modify
}
label define ER30690L        0 "Inap.:  born or moved in after the 1991 interview; from Immigrant or Latino recontact sample (ER30001=3001-3511,4001-4851, 9044-9308); main family nonresponse by 1991 or mover-out nonresponse by 1990 (ER30689=0)"  , modify

label define ER30691L  ///
      10 "Head in 1991; 1990 Head who was mover-out nonresponse by the time of the 1991 interview"  ///
      20 "Legal Wife in 1991; 1990 Wife who was mover-out nonresponse by the time of the 1991 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1990 family, since consecutive interviews may be taken less or more than twelve months apart; 1990 "Wife" who was mover-out nonresponse by the time of the 1991 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino recontact sample (ER30001=3001-3511,4001-4851, 9044-9308); main family nonresponse by 1991 or mover-out nonresponse by 1990 (ER30689=0); born or moved in after the 1991 interview (ER30689>0 and ER30690=0)"

forvalues n = 1/17 {
    label define ER30703L `n' "Highest grade or year of school completed"  , modify
}
label define ER30703L       99 "NA; DK"  , modify
label define ER30703L        0 "Inap.:  from Immigrant or Latino recontact sample (ER30001=3001-3511,4001-4851, 9044-9308); main family nonresponse by 1991 or mover-out nonresponse by 1990 (ER30689=0); born or moved in after the 1991 interview (ER30689>0 and ER30690=0); in an institution in both 1990 and 1991 (ER30690=51-59 and ER30696=0); not a person aged 16 or older (ER30692=001-015)"  , modify

forvalues n = 1/20 {
    label define ER30734L `n' "Individuals in the family at the time of the 1992 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30734L `n' "Individuals in institutions at the time of the 1992 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30734L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1991 and 1992 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30734L `n' "Individuals who were living in 1991 but died by the time of the 1992 interview"  , modify
}
label define ER30734L        0 "Inap.:  born or moved in after the 1992 interview; from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1992 or mover-out nonresponse by 1991 (ER30733=0)"  , modify

label define ER30735L  ///
      10 "Head in 1992; 1991 Head who was mover-out nonresponse by the time of the 1992 interview"  ///
      20 "Legal Wife in 1992; 1991 Wife who was mover-out nonresponse by the time of the 1992 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1991 family, since consecutive interviews may be taken less or more than twelve months apart; 1991 "Wife" who was mover-out nonresponse by the time of the 1992 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1992 or mover-out nonresponse by 1991 (ER30733=0); born or moved in after the 1992 interview (ER30733>0 and ER30734=0)"

forvalues n = 1/17 {
    label define ER30748L `n' "Highest grade or year of school completed"  , modify
}
label define ER30748L       99 "NA; DK"  , modify
label define ER30748L        0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1992 or mover-out nonresponse by 1991 (ER30733=0); in an institution in both 1991 and 1992 (ER30734=51-59 and ER30740=0); not a person aged 16 or older (ER30736=001-015); born or moved in after the 1992 interview (ER30733>0 and ER30734=0)"  , modify

forvalues n = 1/20 {
    label define ER30807L `n' "Individuals in the family at the time of the 1993 interview"  , modify
}
forvalues n = 51/59 {
    label define ER30807L `n' "Individuals in institutions at the time of the 1993 interview"  , modify
}
forvalues n = 71/80 {
    label define ER30807L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1992 and 1993 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER30807L `n' "Individuals who were living in 1992 but died by the time of the 1993 interview"  , modify
}
label define ER30807L        0 "Inap.:  born or moved in after the 1993 interview; from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1993 or mover-out nonresponse by 1992 (ER30806=0)"  , modify

label define ER30808L  ///
      10 "Head in 1993; 1992 Head who was mover-out nonresponse by the time of the 1993 interview"  ///
      20 "Legal Wife in 1993; 1992 Wife who was mover-out nonresponse by the time of the 1993 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1992 family, since consecutive interviews may be taken less or more than twelve months apart; 1992 "Wife" who was mover-out nonresponse by the time of the 1993 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1993 or mover-out nonresponse by 1992 (ER30806=0); born or moved in after the 1993 interview (ER30806>0 and ER30807=0)"

forvalues n = 1/17 {
    label define ER30820L `n' "Highest grade or year of school completed"  , modify
}
label define ER30820L       99 "NA"  , modify
label define ER30820L        0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1993 or mover-out nonresponse by 1992 (ER30806=0); born or moved in after the 1993 interview (ER30806>0 and ER30807=0); in an institution in both 1992 and 1993 (ER30807=51-59 and ER30813=0); not a person aged 16 or older (ER30809=001-015)"  , modify

label define ER32000L  ///
       1 "Male"  ///
       2 "Female"  ///
       9 "NA"

label define ER32006L  ///
       0 "This individual is nonsample and not part of the elderly group (ER30002=170-229 and ER30609<64 and ER30645<64 and ER30692<64 and ER30736<64 and ER30809<64 and ER33104<64)"  ///
       1 "This individual is original sample (ER30002=001-026)"  ///
       2 "This individual is born-in sample (ER30002=030-169)"  ///
       3 "This individual is moved-in sample"  ///
       4 "This individual is joint inclusion sample"  ///
       5 "This individual was a followable nonsample parent"  ///
       6 "This individual is nonsample elderly (ER30002=170-229 and ER30609=64-120 or ER30645=64-120 or ER30692=64-120 or ER30736=64-120 or ER30809=64-120 or ER33104=64-120)"

forvalues n = 1/20 {
    label define ER33102L `n' "Individuals in the family at the time of the 1994 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33102L `n' "Individuals in institutions at the time of the 1994 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33102L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1993 and 1994 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33102L `n' "Individuals who were living in 1993 but died by the time of the 1994 interview"  , modify
}
label define ER33102L        0 "Inap.:  born or moved in after the 1994 interview; from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1994 or mover-out nonresponse by 1993 (ER33101=0)"  , modify

label define ER33103L  ///
      10 "Head in 1994; 1993 Head who was mover-out nonresponse by the time of the 1994 interview"  ///
      20 "Legal Wife in 1994; 1993 Wife who was mover-out nonresponse by the time of the 1994 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1993 family, since consecutive interviews may be taken less or more than twelve months apart; 1993 "Wife" who was mover-out nonresponse by the time of the 1994 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1994 or mover-out nonresponse by 1993 (ER33101=0)"

forvalues n = 1/17 {
    label define ER33115L `n' "Highest grade or year of school completed"  , modify
}
label define ER33115L       98 "DK"  , modify
label define ER33115L       99 "NA"  , modify
label define ER33115L        0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1994 or mover-out nonresponse by 1993 (ER33101=0); in an institution in both 1993 and 1994 (ER33102=51-59 and ER33108=0); born or moved in after the 1994 interview (ER33101>0 and ER33102=0); not a person aged 16 or older (ER33104=001-015)"  , modify

forvalues n = 1/20 {
    label define ER33202L `n' "Individuals in the family at the time of the 1995 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33202L `n' "Individuals in institutions at the time of the 1995 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33202L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1994 and 1995 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33202L `n' "Individuals who were living in 1994 but died by the time of the 1995 interview"  , modify
}
label define ER33202L        0 "Inap.:  born or moved in after the 1995 interview; from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1995 or mover-out nonresponse by 1994 (ER33201=0)"  , modify

label define ER33203L  ///
      10 "Head in 1995; 1994 Head who was mover-out nonresponse by the time of the 1995 interview"  ///
      20 "Legal Wife in 1995; 1994 Wife who was mover-out nonresponse by the time of the 1995 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1994 family, since consecutive interviews may be taken less or more than twelve months apart; 1994 "Wife" who was mover-out nonresponse by the time of the 1995 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1995 or mover-out nonresponse by 1994 (ER33201=0); born or moved in after the 1995 interview (ER33201>0 and ER33202=0)"

forvalues n = 1/17 {
    label define ER33215L `n' "Highest grade or year of school completed"  , modify
}
label define ER33215L       98 "DK"  , modify
label define ER33215L       99 "NA"  , modify
label define ER33215L        0 "Inap.: from Immigrant sample (ER30001=3001-3511,4001-4851); main family nonresponse by 1995 or mover-out nonresponse by 1994 (ER33201=0); in an institution in both 1994 and 1995 (ER33202=51-59 and ER33208=0); born or moved in after the 1995 interview (ER33201>0 and ER33202=0); not a person aged 16 or older (ER33204=001-015)"  , modify

forvalues n = 1/20 {
    label define ER33302L `n' "Individuals in the family at the time of the 1996 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33302L `n' "Individuals in institutions at the time of the 1996 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33302L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1995 and 1996 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33302L `n' "Individuals who were living in 1995 but died by the time of the 1996 interview"  , modify
}
label define ER33302L        0 "Inap.:  born or moved in after the 1996 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1996 or mover-out nonresponse by 1995 (ER33301=0)"  , modify

label define ER33303L  ///
      10 "Head in 1996; 1995 Head who was mover-out nonresponse by the time of the 1996 interview"  ///
      20 "Legal Wife in 1996; 1995 Wife who was mover-out nonresponse by the time of the 1996 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1995 family, since consecutive interviews may be taken less or more than twelve months apart; 1995 "Wife" who was mover-out nonresponse by the time of the 1996 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1996 or mover-out nonresponse by 1995 (ER33301=0); born or moved in after the 1996 interview (ER33301>0 and ER33302=0)"

forvalues n = 1/17 {
    label define ER33315L `n' "Highest grade or year of school completed"  , modify
}
label define ER33315L       98 "DK"  , modify
label define ER33315L       99 "NA"  , modify
label define ER33315L        0 "Inap.:  from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1996 or mover-out nonresponse by 1995 (ER33301=0); in an institution in both 1995 and 1996 (ER33302=51-59 and ER33308=0); born or moved in after the 1996 interview (ER33301>0 and ER33302=0); not a person aged 16 or older (ER33304=001-015)"  , modify

forvalues n = 1/20 {
    label define ER33402L `n' "Individuals in the family at the time of the 1997 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33402L `n' "Individuals in institutions at the time of the 1997 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33402L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1996 and 1997 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33402L `n' "Individuals who were living in 1996 but died by the time of the 1997 interview"  , modify
}
label define ER33402L        0 "Inap.:  born or moved in after the 1997 interview; from Immigrant or Latino samples (ER30001=3001-3511,4001-4851,7001-9308); main family nonresponse by 1997 or mover-out nonresponse by 1996 (ER33401=0)"  , modify

label define ER33403L  ///
      10 "Head in 1997; 1996 Head who was mover-out nonresponse by the time of the 1997 interview"  ///
      20 "Legal Wife in 1997; 1996 Wife who was mover-out nonresponse by the time of the 1997 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more or who was present in the 1996 family, since consecutive interviews may be taken less or more than twelve months apart; 1996 "Wife" who was mover-out nonresponse by the time of the 1997 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap. from Immigrant Sample added in 1999, from Immigrant Sample added in 2017 or Latino samples (ER30001=3442-3511, 4001-4851, 7001-9308); main family nonresponse by 1997 or mover-out nonresponse by 1996 (ER33401=0); born or moved in after the 1997 interview (ER33401>0 and ER33402=0)"

forvalues n = 1/17 {
    label define ER33415L `n' "Highest grade or year of school completed"  , modify
}
label define ER33415L       98 "DK"  , modify
label define ER33415L       99 "NA"  , modify
label define ER33415L        0 "Inap.:  from Immigrant 99 recontact, Immigrant 17 or Latino samples (ER30001=3442-3511,4001-4851,7001-9308); main family nonresponse by 1997 or mover-out nonresponse by 1996 (ER33401=0); in an institution in both 1996 and 1997 (ER33402=51-59 and ER33408=0); born or moved in after the 1997 interview (ER33401>0 and ER33402=0); not a person aged 16 or older (ER33404=001-015)"  , modify

forvalues n = 1/20 {
    label define ER33502L `n' "Individuals in the family at the time of the 1999 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33502L `n' "Individuals in institutions at the time of the 1999 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33502L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1997 and 1999 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33502L `n' "Individuals who were living in 1997 but died by the time of the 1999 interview"  , modify
}
label define ER33502L        0 "Inap.:  born or moved in after the 1999 interview; from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 1999 or mover-out nonresponse by 1997 (ER33501=0)"  , modify

label define ER33503L  ///
      10 "Head in 1999; 1997 Head who was mover-out nonresponse by the time of the 1999 interview"  ///
      20 "Legal Wife in 1999; 1997 Wife who was mover-out nonresponse by the time of the 1999 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 1997 "Wife" who was mover-out nonresponse by the time of the 1999 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 1999 or mover-out nonresponse by 1997 (ER33501=0); born or moved in after the 1999 interview (ER33501>0 and ER33502=0)"

forvalues n = 1/17 {
    label define ER33516L `n' "Highest grade or year of school completed"  , modify
}
label define ER33516L       98 "DK"  , modify
label define ER33516L       99 "NA"  , modify
label define ER33516L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 1999 or mover-out nonresponse by 1997 (ER33501=0);  in an institution in both 1997 and 1999 (ER33502=51-59 and ER33508=0); associated with a 1999 FU but actually moved out before 1998 (ER33508=5, 6, or 8 and ER33510<1998) or born or moved in after the 1999 interview (ER33501>0 and ER33502=0);  not a person aged 16 or older (ER33504=001-015)"  , modify

forvalues n = 1/20 {
    label define ER33602L `n' "Individuals in the family at the time of the 2001 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33602L `n' "Individuals in institutions at the time of the 2001 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33602L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 1999 and 2001 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33602L `n' "Individuals who were living in 1999 but died by the time of the 2001 interview"  , modify
}
label define ER33602L        0 "Inap.:  born or moved in after the 2001 interview; from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2001 or mover-out nonresponse by 1999 (ER33601=0)"  , modify

label define ER33603L  ///
      10 "Head in 2001; 1999 Head who was mover-out nonresponse by the time of the 2001 interview"  ///
      20 "Legal Wife in 2001; 1999 Wife who was mover-out nonresponse by the time of the 2001 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 1999 "Wife" who was mover-out nonresponse by the time of the 2001 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20), but those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2001 or mover-out nonresponse by 1999 (ER33601=0); born or moved in after the 2001 interview (ER33601>0 and ER33602=0)"

forvalues n = 1/17 {
    label define ER33616L `n' "Highest grade or year of school completed"  , modify
}
label define ER33616L       98 "DK"  , modify
label define ER33616L       99 "NA"  , modify
label define ER33616L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2001 or mover-out nonresponse by 1999 (ER33601=0); in an institution in both 1999 and 2001 (ER33602=51-59 and ER33608=0); associated with a 2001 FU but moved out before 2000 (ER33608=5, 6, or 8 and ER33610<2000) or born or moved in after the 2001 interview (ER33601>0 and ER33602=0); not a person aged 16 or older (ER33604=001-015, 999)"  , modify

forvalues n = 1/20 {
    label define ER33702L `n' "Individuals in the family at the time of the 2003 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33702L `n' "Individuals in institutions at the time of the 2003 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33702L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2001 and 2003 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33702L `n' "Individuals who were living in 2001 but died by the time of the 2003 interview"  , modify
}
label define ER33702L        0 "Inap.:  born or moved in after the 2003 interview; from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2003 or mover-out nonresponse by 2001 (ER33701=0)"  , modify

label define ER33703L  ///
      10 "Head in 2003; 2001 Head who was mover-out nonresponse by the time of the 2003 interview"  ///
      20 "Legal Wife in 2003; 2001 Wife who was mover-out nonresponse by the time of the 2003 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 2001 "Wife" who was mover-out nonresponse by the time of the 2003 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife (code 20) who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister."  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives (code 20) only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife (code 20); those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife (code 20); those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2003 or mover-out nonresponse by 2001 (ER33701=0); born or moved in after the 2003 interview (ER33701>0 and ER33702=0)"

forvalues n = 1/17 {
    label define ER33716L `n' "Highest grade or year of school completed"  , modify
}
label define ER33716L       98 "DK"  , modify
label define ER33716L       99 "NA"  , modify
label define ER33716L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2003 or mover-out nonresponse by 2001 (ER33701=0); born or moved in after the 2003 interview (ER33701>0 and ER33702=0); in an institution in both 2001 and 2003 (ER33702=51-59 and ER33708=0); associated with 2003 FU but actually moved out before 2002 (ER33708=5, 6, or 8 and ER33710<2002) or moved in in 2003 (ER33708=1 and ER33710=2003); not a person aged 16 or older (ER33704=001-015, 999)"  , modify

forvalues n = 1/20 {
    label define ER33802L `n' "Individuals in the family at the time of the 2005 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33802L `n' "Individuals in institutions at the time of the 2005 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33802L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2003 and 2005 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33802L `n' "Individuals who were living in 2003 but died by the time of the 2005 interview"  , modify
}
label define ER33802L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2005 or mover-out nonresponse by 2003 (ER33801=0)"  , modify

label define ER33803L  ///
      10 "Head in 2005; 2003 Head who was mover-out nonresponse by the time of the 2005 interview"  ///
      20 "Legal Wife in 2005; 2003 Wife who was mover-out nonresponse by the time of the 2005 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 2003 "Wife" who was mover-out nonresponse by the time of the 2005 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife [code 20] who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister"  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives [code 20] only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2005 or mover-out nonresponse by 2003 (ER33801=0)"

forvalues n = 1/17 {
    label define ER33817L `n' "Highest grade or year of school completed"  , modify
}
label define ER33817L       98 "DK"  , modify
label define ER33817L       99 "NA"  , modify
label define ER33817L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2005 or mover-out nonresponse by 2003 (ER33801=0); in an institution in both 2003 and 2005 (ER33802=51-59 and ER33808=0); not a person aged 16 or older (ER33804=001-015, 999); associated with 2005 FU but actually moved out before 2004 (ER33808=5, 6, or 8 and ER33810<2004) or moved in in 2005 (ER33808=1 and ER33810=2005)"  , modify

forvalues n = 1/20 {
    label define ER33902L `n' "Individuals in the family at the time of the 2007 interview"  , modify
}
forvalues n = 51/59 {
    label define ER33902L `n' "Individuals in institutions at the time of the 2007 interview"  , modify
}
forvalues n = 71/80 {
    label define ER33902L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2005 and 2007 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER33902L `n' "Individuals who were living in 2005 but died by the time of the 2007 interview"  , modify
}
label define ER33902L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2007 or mover-out nonresponse by 2005 (ER33901=0)"  , modify

label define ER33903L  ///
      10 "Head in 2007; 2005 Head who was mover-out nonresponse by the time of the 2007 interview"  ///
      20 "Legal Wife in 2007; 2005 Wife who was mover-out nonresponse by the time of the 2007 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 2005 "Wife" who was mover-out nonresponse by the time of the 2007 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife [code 20] who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister"  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives [code 20] only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2007 or mover-out nonresponse by 2005 (ER33901=0)"

forvalues n = 1/17 {
    label define ER33917L `n' "Highest grade or year of school completed"  , modify
}
label define ER33917L       98 "DK"  , modify
label define ER33917L       99 "NA"  , modify
label define ER33917L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2007 or mover-out nonresponse by 2005 (ER33901=0); in an institution in both 2005 and 2007 (ER33902=51-59 and ER33908=0); not a person aged 16 or older (ER33904=001-015, 999); associated with 2007 FU but actually moved out before 2006 (ER33908=5, 6, or 8 and ER33910<2006) or moved in in 2007 (ER33908=1 and ER33910=2007)"  , modify

forvalues n = 1/20 {
    label define ER34002L `n' "Individuals in the family at the time of the 2009 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34002L `n' "Individuals in institutions at the time of the 2009 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34002L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2007 and 2009 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34002L `n' "Individuals who were living in 2007 but died by the time of the 2009 interview"  , modify
}
label define ER34002L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2009 or mover-out nonresponse by 2007 (ER34001=0)"  , modify

label define ER34003L  ///
      10 "Head in 2009; 2007 Head who was mover-out nonresponse by the time of the 2009 interview"  ///
      20 "Legal Wife in 2009; 2007 Wife who was mover-out nonresponse by the time of the 2009 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 2007 "Wife" who was mover-out nonresponse by the time of the 2009 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife [code 20] who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister"  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives [code 20] only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2009 or mover-out nonresponse by 2007 (ER34002=0)"

forvalues n = 1/17 {
    label define ER34020L `n' "Highest grade or year of school completed"  , modify
}
label define ER34020L       98 "DK"  , modify
label define ER34020L       99 "NA"  , modify
label define ER34020L        0 `"Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2009 or mover-out nonresponse by 2007 (ER34001=0); in an institution in both 2007 and 2009 (ER34002=51-59 and ER34008=0); not a person aged 16 or older (ER34004=001-015, 999); associated with 2009 FU but actually moved out before 2008 (ER34008=5, 6, or 8 and ER34010<2008) or moved in in 2009 and was not a Head or Wife/"Wife" (ER34008=1 and ER34010=2009 and ER34002 GE 2 and ER34003 GE 30)"'  , modify

forvalues n = 1/20 {
    label define ER34102L `n' "Individuals in the family at the time of the 2011 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34102L `n' "Individuals in institutions at the time of the 2011 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34102L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2009 and 2011 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34102L `n' "Individuals who were living in 2009 but died by the time of the 2011 interview"  , modify
}
label define ER34102L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2011 or mover-out nonresponse by 2009 (ER34101=0)"  , modify

label define ER34103L  ///
      10 "Head in 2011; 2009 Head who was mover-out nonresponse by the time of the 2011 interview"  ///
      20 "Legal Wife in 2011; 2009 Wife who was mover-out nonresponse by the time of the 2011 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 2009 "Wife" who was mover-out nonresponse by the time of the 2011 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife [code 20] who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister"  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives [code 20] only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2011 or mover-out nonresponse by 2009 (ER34102=0)"

forvalues n = 1/17 {
    label define ER34119L `n' "Highest grade or year of school completed"  , modify
}
label define ER34119L       98 "DK"  , modify
label define ER34119L       99 "NA"  , modify
label define ER34119L        0 `"Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2011 or mover-out nonresponse by 2009 (ER34101=0); in an institution in both 2009 and 2011 (ER34102=51-59 and ER34108=0); not a person aged 16 or older (ER34104=001-015, 999); associated with 2011 FU but actually moved out before 2010 (ER34108=5, 6, or 8 and ER34110<2010) or moved in in 2011 and was not a Head or Wife/"Wife" (ER34108=1 and ER34110=2011 and ER34102 GE 2 and ER34103 GE 30)"'  , modify

forvalues n = 1/20 {
    label define ER34202L `n' "Individuals in the family at the time of the 2013 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34202L `n' "Individuals in institutions at the time of the 2013 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34202L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2011 and 2013 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34202L `n' "Individuals who were living in 2011 but died by the time of the 2013 interview"  , modify
}
label define ER34202L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2013 or mover-out nonresponse by 2011 (ER34201=0)"  , modify

label define ER34203L  ///
      10 "Head in 2013; 2011 Head who was mover-out nonresponse by the time of the 2013 interview"  ///
      20 "Legal Wife in 2013; 2011 Wife who was mover-out nonresponse by the time of the 2013 interview"  ///
      22 `""Wife"--female cohabitor who has lived with Head for 12 months or more; 2011 "Wife" who was mover-out nonresponse by the time of the 2013 interview"'  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Wife [code 20] who are not children of Head)"  ///
      35 `"Son or daughter of "Wife" but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"'  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Wife, or spouse of Head`=char(146)'s brother or sister"  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal wives [code 20] only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Wife [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Wife [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Wife (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Wife (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Wife (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Wife (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Wife (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Legal husband of Head"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Wife (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes homosexual partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2013 or mover-out nonresponse by 2011 (ER34202=0)"

forvalues n = 1/17 {
    label define ER34230L `n' "Highest grade or year of school completed"  , modify
}
label define ER34230L       99 "DK; NA; refused"  , modify
label define ER34230L        0 `"Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2013 or mover-out nonresponse by 2011 (ER34101=0); in an institution in both 2011 and 2013 (ER34102=51-59 and ER34108=0); not a person aged 16 or older (ER34104=001-015, 999); associated with 2013 FU but actually moved out before 2012 (ER34108=5, 6, or 8 and ER34110<2012) or moved in in 2013 and was not a Head or Wife/"Wife" (ER34108=1 and ER34110=2013 and ER34102 GE 2 and ER34103 GE 30)"'  , modify

forvalues n = 1/20 {
    label define ER34302L `n' "Individuals in the family at the time of the 2015 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34302L `n' "Individuals in institutions at the time of the 2015 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34302L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2013 and 2015 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34302L `n' "Individuals who were living in 2013 but died by the time of the 2015 interview"  , modify
}
label define ER34302L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2015 or mover-out nonresponse by 2013 (ER34301=0)"  , modify

label define ER34303L  ///
      10 "Head in 2015; 2013 Head who was mover-out nonresponse by the time of the 2015 interview"  ///
      20 "Legal Spouse in 2015; 2013 Spouse who was mover-out nonresponse by the time of the 2015 interview"  ///
      22 "Partner--female cohabitor who has lived with Head for 12 months or more; 2013 Partner who was mover-out nonresponse by the time of the 2015 interview"  ///
      30 "Son or daughter of Head (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Head (children of legal Spouse [code 20] who are not children of Head)"  ///
      35 "Son or daughter of Partner but not Head (includes only those children of mothers whose relationship to Head is 22 but who are not children of Head)"  ///
      37 "Son-in-law or daughter-in-law of Head (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Head (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Head; i.e., brother or sister of legal Spouse, or spouse of Head`=char(146)'s brother or sister"  ///
      48 "Brother or sister of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Head (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Head (includes parents of legal spouses [code 20] only)"  ///
      58 "Father or mother of Head`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Head (includes grandchildren of legal Spouse [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Head (includes great-grandchildren of legal Spouse [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Head (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Spouse (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Head"  ///
      69 "Great-grandfather or great-grandmother of legal Spouse (code 20)"  ///
      70 "Nephew or niece of Head"  ///
      71 "Nephew or niece of legal Spouse (code 20)"  ///
      72 "Uncle or Aunt of Head"  ///
      73 "Uncle or Aunt of legal Spouse (code 20)"  ///
      74 "Cousin of Head"  ///
      75 "Cousin of legal Spouse (code 20)"  ///
      83 "Children of first-year cohabitor but not of Head (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Head"  ///
      90 "Uncooperative legal spouse of Head (this individual is unable or unwilling to be designated as Head)"  ///
      95 "Other relative of Head"  ///
      96 "Other relative of legal Spouse (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes same-sex partners, friends of children of the FU, etc.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2015 or mover-out nonresponse by 2013 (ER34302=0)"

forvalues n = 1/17 {
    label define ER34349L `n' "Highest grade or year of school completed"  , modify
}
label define ER34349L       99 "DK; NA; refused"  , modify
label define ER34349L        0 "Inap.:  from Latino sample (ER30001=7001-9308); from Immigrant 2017 sample (ER30001=4001-4851); main family nonresponse by 2015 or mover-out nonresponse by 2013 (ER34201=0); in an institution in both 2013 and 2015 (ER34202=51-59 and ER34208=0); not a person aged 16 or older (ER34204=001-015, 999); associated with 2015 FU but actually moved out before 2014 (ER34208=5, 6, or 8 and ER34210<2014) or moved in in 2015 and was not a Head or Spouse/Partner (ER34208=1 and ER34210=2015 and ER34202 GE 2 and ER34203 GE 30)"  , modify

forvalues n = 1/20 {
    label define ER34502L `n' "Individuals in the family at the time of the 2017 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34502L `n' "Individuals in institutions at the time of the 2017 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34502L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2015 and 2017 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34502L `n' "Individuals who were living in 2015 but died by the time of the 2017 interview"  , modify
}
label define ER34502L        0 "Inap.:  from Immigrant 17 recontact sample (ER30001=4700-4851) or Multiplicity sample (ER30001=4001-4462 and ER32052=2019); from Latino sample (ER30001=7001-9308); main family nonresponse by 2017 or mover-out nonresponse by 2015 (ER34501=0)"  , modify

label define ER34503L  ///
      10 "Reference Person in 2017; 2015 Reference Person who was mover-out nonresponse by the time of the 2017 interview"  ///
      20 "Legal Spouse in 2017; 2015 Spouse who was mover-out nonresponse by the time of the 2017 interview"  ///
      22 "Partner--cohabitor who has lived with Reference Person for 12 months or more; 2015 Partner who was mover-out nonresponse by the time of the 2017 interview"  ///
      30 "Son or daughter of Reference Person (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Reference Person (children of legal Spouse [code 20] who are not children of Reference Person)"  ///
      35 "Son or daughter of Partner but not Reference Person (includes only those children of mothers whose relationship to Reference Person is 22 but who are not children of Reference Person)"  ///
      37 "Son-in-law or daughter-in-law of Reference Person (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Reference Person (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Reference Person (i.e., brother or sister of legal Spouse; spouse of HD`=char(146)'s brother or sister; spouse of legal Spouse`=char(146)'s brother or sister)"  ///
      48 "Brother or sister of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Reference Person (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Reference Person (includes parents of legal spouses [code 20] only)"  ///
      58 "Father or mother of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Reference Person (includes grandchildren of legal Spouse [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Reference Person (includes great-grandchildren of legal Spouse [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Reference Person (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Spouse (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Reference Person"  ///
      69 "Great-grandfather or great-grandmother of legal Spouse (code 20)"  ///
      70 "Nephew or niece of Reference Person"  ///
      71 "Nephew or niece of legal Spouse (code 20)"  ///
      72 "Uncle or Aunt of Reference Person"  ///
      73 "Uncle or Aunt of legal Spouse (code 20)"  ///
      74 "Cousin of Reference Person"  ///
      75 "Cousin of legal Spouse (code 20)"  ///
      83 "Children of first-year cohabitor but not of Reference Person (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Reference Person"  ///
      90 "Uncooperative legal spouse of Reference Person (this individual is unable or unwilling to be designated as Reference Person or Spouse)"  ///
      92 "Uncooperative partner of Reference Person (this individual is unable or unwilling to be designated as Partner)"  ///
      95 "Other relative of Reference Person"  ///
      96 "Other relative of legal Spouse (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes friends of children of the FU, boyfriend/girlfriend of son/daughter, et al.)"  ///
       0 "Inap.:  from Immigrant 17 recontact sample (ER30001=4700-4851) or Multiplicity sample (ER30001=4001-4462 and ER32052=2019); from Latino sample (ER30001=7001-9308); main family nonresponse by 2017 or mover-out nonresponse by 2015 (ER34502=0)"

forvalues n = 1/17 {
    label define ER34548L `n' "Highest grade or year of school completed"  , modify
}
label define ER34548L       99 "DK; NA; refused"  , modify
label define ER34548L        0 "Inap.:  from Immigrant 17 recontact sample (ER30001=4700-4851) or Multiplicity sample (ER30001=4001-4462 and ER32052=2019); from Latino sample (ER30001=7001-9308); main family nonresponse by 2017 or mover-out nonresponse by 2015 (ER34301=0); in an institution in both 2015 and 2017 (ER34302=51-59 and ER34508=0); not a person aged 16 or older (ER34504=001-015, 999); associated with 2017 FU but actually moved out before 2016 (ER34508=5, 6, or 8 and ER34510<2016) or moved in in 2017 and was not a Reference Person or Spouse/Partner (ER34508=1 and ER34510=2017 and ER34302 GE 2 and ER34303 GE 30)"  , modify

forvalues n = 1/20 {
    label define ER34702L `n' "Individuals in the family at the time of the 2019 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34702L `n' "Individuals in institutions at the time of the 2019 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34702L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2017 and 2019 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34702L `n' "Individuals who were living in 2017 but died by the time of the 2019 interview"  , modify
}
label define ER34702L        0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2019 or mover-out nonresponse by 2017 (ER34701=0)"  , modify

label define ER34703L  ///
      10 "Reference Person in 2019; 2017 Reference Person who was mover-out nonresponse by the time of the 2019 interview"  ///
      20 "Legal Spouse in 2019; 2017 Spouse who was mover-out nonresponse by the time of the 2019 interview"  ///
      22 "Partner--cohabitor who has lived with Reference Person for 12 months or more; 2017 Partner who was mover-out nonresponse by the time of the 2019 interview"  ///
      30 "Son or daughter of Reference Person (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Reference Person (children of legal Spouse [code 20] who are not children of Reference Person)"  ///
      35 "Son or daughter of Partner but not Reference Person (includes only those children of mothers whose relationship to Reference Person is 22 but who are not children of Reference Person)"  ///
      37 "Son-in-law or daughter-in-law of Reference Person (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Reference Person (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Reference Person (i.e., brother or sister of legal Spouse; spouse of HD`=char(146)'s brother or sister; spouse of legal Spouse`=char(146)'s brother or sister)"  ///
      48 "Brother or sister of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Reference Person (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Reference Person (includes parents of legal spouses [code 20] only)"  ///
      58 "Father or mother of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Reference Person (includes grandchildren of legal Spouse [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Reference Person (includes great-grandchildren of legal Spouse [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Reference Person (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Spouse (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Reference Person"  ///
      69 "Great-grandfather or great-grandmother of legal Spouse (code 20)"  ///
      70 "Nephew or niece of Reference Person"  ///
      71 "Nephew or niece of legal Spouse (code 20)"  ///
      72 "Uncle or Aunt of Reference Person"  ///
      73 "Uncle or Aunt of legal Spouse (code 20)"  ///
      74 "Cousin of Reference Person"  ///
      75 "Cousin of legal Spouse (code 20)"  ///
      83 "Children of first-year cohabitor but not of Reference Person (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Reference Person"  ///
      90 "Uncooperative legal spouse of Reference Person (this individual is unable or unwilling to be designated as Reference Person or Spouse)"  ///
      92 "Uncooperative partner of Reference Person (this individual is unable or unwilling to be designated as Partner)"  ///
      95 "Other relative of Reference Person"  ///
      96 "Other relative of legal Spouse (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes friends of children of the FU, boyfriend/girlfriend of son/daughter, et al.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2019 or mover-out nonresponse by 2017 (ER34702=0)"

forvalues n = 1/17 {
    label define ER34752L `n' "Highest grade or year of school completed"  , modify
}
label define ER34752L       99 "DK; NA; refused"  , modify
label define ER34752L        0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2019 or mover-out nonresponse by 2017 (ER34501=0); in an institution in both 2017 and 2019 (ER34502=51-59 and ER34708=0); not a person aged 16 or older (ER34704=001-015, 999); associated with 2019 FU but actually moved out before 2018 (ER34708=5, 6, or 8 and ER34710<2018) or moved in in 2019 and was not a Reference Person or Spouse/Partner (ER34708=1 and ER34710=2019 and ER34502 GE 2 and ER34503 GE 30)"  , modify

forvalues n = 1/20 {
    label define ER34902L `n' "Individuals in the family at the time of the 2021 interview"  , modify
}
forvalues n = 51/59 {
    label define ER34902L `n' "Individuals in institutions at the time of the 2021 interview"  , modify
}
forvalues n = 71/80 {
    label define ER34902L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2019 and 2021 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER34902L `n' "Individuals who were living in 2019 but died by the time of the 2021 interview"  , modify
}
label define ER34902L        0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2021 or mover-out nonresponse by 2019 (ER34901=0)"  , modify

label define ER34903L  ///
      10 "Reference Person in 2021; 2019 Reference Person who was mover-out nonresponse by the time of the 20121 interview"  ///
      20 "Legal Spouse in 2021; 2019 Spouse who was mover-out nonresponse by the time of the 2021 interview"  ///
      22 "Partner--cohabitor who has lived with Reference Person for 12 months or more; 2019 Partner who was mover-out nonresponse by the time of the 2021 interview"  ///
      30 "Son or daughter of Reference Person (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Reference Person (children of legal Spouse [code 20] who are not children of Reference Person)"  ///
      35 "Son or daughter of Partner but not Reference Person (includes only those children of mothers whose relationship to Reference Person is 22 but who are not children of Reference Person)"  ///
      37 "Son-in-law or daughter-in-law of Reference Person (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Reference Person (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Reference Person (i.e., brother or sister of legal Spouse; spouse of HD`=char(146)'s brother or sister; spouse of legal Spouse`=char(146)'s brother or sister)"  ///
      48 "Brother or sister of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Reference Person (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Reference Person (includes parents of legal spouses [code 20] only)"  ///
      58 "Father or mother of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Reference Person (includes grandchildren of legal Spouse [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Reference Person (includes great-grandchildren of legal Spouse [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Reference Person (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Spouse (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Reference Person"  ///
      69 "Great-grandfather or great-grandmother of legal Spouse (code 20)"  ///
      70 "Nephew or niece of Reference Person"  ///
      71 "Nephew or niece of legal Spouse (code 20)"  ///
      72 "Uncle or Aunt of Reference Person"  ///
      73 "Uncle or Aunt of legal Spouse (code 20)"  ///
      74 "Cousin of Reference Person"  ///
      75 "Cousin of legal Spouse (code 20)"  ///
      83 "Children of first-year cohabitor but not of Reference Person (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Reference Person"  ///
      90 "Uncooperative legal spouse of Reference Person (this individual is unable or unwilling to be designated as Reference Person or Spouse)"  ///
      92 "Uncooperative partner of Reference Person (this individual is unable or unwilling to be designated as Partner)"  ///
      95 "Other relative of Reference Person"  ///
      96 "Other relative of legal Spouse (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes friends of children of the FU, boyfriend/girlfriend of son/daughter, et al.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2021 or mover-out nonresponse by 2019 (ER34902=0)"

forvalues n = 1/17 {
    label define ER34952L `n' "Highest grade or year of school completed"  , modify
}
label define ER34952L       99 "DK; NA; refused"  , modify
label define ER34952L        0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2021 or mover-out nonresponse by 2019 (ER34701=0); in an institution in both 2019 and 2021 (ER34702=51-59 and ER34908=0); not a person aged 16 or older (ER34904=001-015, 999); associated with 2021 FU but actually moved out before 2020 (ER34908=5, 6, or 8 and ER34910<2020) or moved in in 2021 and was not a Reference Person or Spouse/Partner (ER34908=1 and ER34910=2021 and ER34702 GE 2 and ER34703 GE 30)"  , modify

forvalues n = 1/20 {
    label define ER35102L `n' "Individuals in the family at the time of the 2023 interview"  , modify
}
forvalues n = 51/59 {
    label define ER35102L `n' "Individuals in institutions at the time of the 2023 interview"  , modify
}
forvalues n = 71/80 {
    label define ER35102L `n' "Individuals who moved out of the FU or out of institutions and established their own households between the 2021 and 2023 interviews"  , modify
}
forvalues n = 81/89 {
    label define ER35102L `n' "Individuals who were living in 2021 but died by the time of the 2023 interview"  , modify
}
label define ER35102L        0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2023 or mover-out nonresponse by 2021 (ER35101=0)"  , modify

label define ER35103L  ///
      10 "Reference Person in 2023; 2021 Reference Person who was mover-out nonresponse by the time of the 20121 interview"  ///
      20 "Legal Spouse in 2023; 2021 Spouse who was mover-out nonresponse by the time of the 2023 interview"  ///
      22 "Partner--cohabitor who has lived with Reference Person for 12 months or more; 2021 Partner who was mover-out nonresponse by the time of the 2023 interview"  ///
      30 "Son or daughter of Reference Person (includes adopted children but not stepchildren)"  ///
      33 "Stepson or stepdaughter of Reference Person (children of legal Spouse [code 20] who are not children of Reference Person)"  ///
      35 "Son or daughter of Partner but not Reference Person (includes only those children of mothers whose relationship to Reference Person is 22 but who are not children of Reference Person)"  ///
      37 "Son-in-law or daughter-in-law of Reference Person (includes stepchildren-in-law)"  ///
      38 "Foster son or foster daughter, not legally adopted"  ///
      40 "Brother or sister of Reference Person (includes step and half sisters and brothers)"  ///
      47 "Brother-in-law or sister-in-law of Reference Person (i.e., brother or sister of legal Spouse; spouse of HD`=char(146)'s brother or sister; spouse of legal Spouse`=char(146)'s brother or sister)"  ///
      48 "Brother or sister of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      50 "Father or mother of Reference Person (includes stepparents)"  ///
      57 "Father-in-law or mother-in-law of Reference Person (includes parents of legal spouses [code 20] only)"  ///
      58 "Father or mother of Reference Person`=char(146)'s cohabitor (the cohabitor is coded 22 or 88)"  ///
      60 "Grandson or granddaughter of Reference Person (includes grandchildren of legal Spouse [code 20] only; those of a cohabitor are coded 97)"  ///
      65 "Great-grandson or great-granddaughter of Reference Person (includes great-grandchildren of legal Spouse [code 20]; those of a cohabitor are coded 97)"  ///
      66 "Grandfather or grandmother of Reference Person (includes stepgrandparents)"  ///
      67 "Grandfather or grandmother of legal Spouse (code 20)"  ///
      68 "Great-grandfather or great-grandmother of Reference Person"  ///
      69 "Great-grandfather or great-grandmother of legal Spouse (code 20)"  ///
      70 "Nephew or niece of Reference Person"  ///
      71 "Nephew or niece of legal Spouse (code 20)"  ///
      72 "Uncle or Aunt of Reference Person"  ///
      73 "Uncle or Aunt of legal Spouse (code 20)"  ///
      74 "Cousin of Reference Person"  ///
      75 "Cousin of legal Spouse (code 20)"  ///
      83 "Children of first-year cohabitor but not of Reference Person (the parent of this child is coded 88)"  ///
      88 "First-year cohabitor of Reference Person"  ///
      90 "Uncooperative legal spouse of Reference Person (this individual is unable or unwilling to be designated as Reference Person or Spouse)"  ///
      92 "Uncooperative partner of Reference Person (this individual is unable or unwilling to be designated as Partner)"  ///
      95 "Other relative of Reference Person"  ///
      96 "Other relative of legal Spouse (code 20)"  ///
      97 "Other relative of cohabitor (the cohabitor is code 22 or 88)"  ///
      98 "Other nonrelatives (includes friends of children of the FU, boyfriend/girlfriend of son/daughter, et al.)"  ///
       0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2023 or mover-out nonresponse by 2021 (ER35102=0)"

forvalues n = 1/17 {
    label define ER35152L `n' "Highest grade or year of school completed"  , modify
}
label define ER35152L       99 "DK; NA; refused"  , modify
label define ER35152L        0 "Inap.:  from Latino sample (ER30001=7001-9308); main family nonresponse by 2023 or mover-out nonresponse by 2021 (ER34901=0); in an institution in both 2021 and 2023 (ER34902=51-59 and ER35108=0); not a person aged 16 or older (ER35104=001-015, 999); associated with 2023 FU but actually moved out before 2022 (ER35108=5, 6, or 8 and ER35110<2022) or moved in in 2023 and was not a Reference Person or Spouse/Partner (ER35108=1 and ER35110=2023 and ER34902 GE 2 and ER34903 GE 30)"  , modify

label define ER36001L  ///
       1 "Release number 1, June 2009"  ///
       2 "Release number 2, October 2009"  ///
       3 "Release number 3, January 2012"  ///
       4 "Release number 4, December 2013"  ///
       5 "Release number 5, February 2014"  ///
       6 "Release number 6, January 2016"  ///
       7 "Release number 7, November 2017"  ///
       8 "Release number 8, June 2023"

forvalues n = 1/51 {
    label define ER36003L `n' "Actual state (PSID State code)"  , modify
}
label define ER36003L       99 "DK; NA"  , modify
label define ER36003L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER36004L `n' "Actual state (FIPS code)"  , modify
}
label define ER36004L       99 "DK; NA"  , modify
label define ER36004L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER36018L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/51 {
    label define ER4156L `n' "Actual state (PSID State code)"  , modify
}
label define ER4156L       99 "NA; DK;  Latino sample family"  , modify
label define ER4156L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER4157L `n' "Actual state (FIPS code)"  , modify
}
label define ER4157L       99 "NA; DK;  Latino sample family"  , modify
label define ER4157L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER42001L  ///
       1 "Release number 1, July 2011"  ///
       2 "Release number 2, November 2013"  ///
       3 "Release number 3, February 2014"  ///
       4 "Release number 4, January 2016"  ///
       5 "Release number 5, November 2017"  ///
       6 "Release number 6, June 2023"

forvalues n = 1/51 {
    label define ER42003L `n' "Actual state (PSID State code)"  , modify
}
label define ER42003L       99 "DK; NA"  , modify
label define ER42003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER42004L `n' "Actual state (FIPS code)"  , modify
}
label define ER42004L       99 "DK; NA"  , modify
label define ER42004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER42018L  ///
       1 "Male"  ///
       2 "Female"

label define ER47301L  ///
       1 "Release number 1, July 2013"  ///
       2 "Release number 2, November 2013"  ///
       3 "Release number 3, February 2014"  ///
       4 "Release number 4, January 2016"  ///
       5 "Release number 5, November 2017"  ///
       6 "Release number 6, June 2023"

forvalues n = 1/51 {
    label define ER47303L `n' "Actual state (PSID State code)"  , modify
}
label define ER47303L       99 "DK; NA"  , modify
label define ER47303L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER47304L `n' "Actual state (FIPS code)"  , modify
}
label define ER47304L       99 "DK; NA"  , modify
label define ER47304L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER47318L  ///
       1 "Male"  ///
       2 "Female"

label define ER5001L  ///
       1 "Release number 1 - August 1995"  ///
       2 "Release number 2 - January 2003"  ///
       3 "Release number 3 - March 2004"  ///
       4 "Release number 4 - May 2008"  ///
       5 "Release number 5 - November 2013"  ///
       6 "Release number 6 - January 2016"

forvalues n = 14/96 {
    label define ER5006L `n' "Actual age"  , modify
}
label define ER5006L       97 "Ninety-seven years of age or older"  , modify
label define ER5006L        0 "Wild code"  , modify
label define ER5006L       98 "NA; DK"  , modify
label define ER5006L       99 "NA; DK"  , modify

label define ER5007L  ///
       1 "Male"  ///
       2 "Female"  ///
       0 "Wild code"

label define ER53001L  ///
       1 "Release number 1, May 2015"  ///
       2 "Release number 2, January 2016"  ///
       3 "Release number 3, November 2017"  ///
       4 "Release number 4, June 2023"

forvalues n = 1/51 {
    label define ER53003L `n' "Actual state (PSID State code)"  , modify
}
label define ER53003L       99 "DK; NA"  , modify
label define ER53003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER53004L `n' "Actual state (FIPS code)"  , modify
}
label define ER53004L       99 "DK; NA"  , modify
label define ER53004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER53018L  ///
       1 "Male"  ///
       2 "Female"

label define ER60001L  ///
       1 "Release number 1, May 2017"  ///
       2 "Release number 2, June 2023"

forvalues n = 1/51 {
    label define ER60003L `n' "Actual state (PSID State code)"  , modify
}
label define ER60003L       99 "DK; NA"  , modify
label define ER60003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER60004L `n' "Actual state (FIPS code)"  , modify
}
label define ER60004L       99 "DK; NA"  , modify
label define ER60004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER60018L  ///
       1 "Male"  ///
       2 "Female"

label define ER66001L  ///
       1 "Release number 1, February 2019"  ///
       2 "Release number 2, August 2019"  ///
       3 "Release number 3, June 2023"

forvalues n = 1/51 {
    label define ER66003L `n' "Actual state (PSID State code)"  , modify
}
label define ER66003L       99 "DK; NA"  , modify
label define ER66003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER66004L `n' "Actual state (FIPS code)"  , modify
}
label define ER66004L       99 "DK; NA"  , modify
label define ER66004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER66018L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/51 {
    label define ER6996L `n' "Actual state (PSID State code)"  , modify
}
label define ER6996L       99 "NA; DK;  Latino sample family"  , modify
label define ER6996L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER6997L `n' "Actual state (FIPS code)"  , modify
}
label define ER6997L       99 "NA; DK;  Latino sample family"  , modify
label define ER6997L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define ER7001L  ///
       1 "Release number 1 - August 1996"  ///
       2 "Release number 2 - January 2003"  ///
       3 "Release number 3 - March 2004"  ///
       4 "Release number 4 - May 2008"  ///
       5 "Release number 5 - November 2013"  ///
       6 "Release number 6 - January 2016"

forvalues n = 14/96 {
    label define ER7006L `n' "Actual age"  , modify
}
label define ER7006L       97 "Ninety-seven years of age or older"  , modify
label define ER7006L        0 "Wild code"  , modify
label define ER7006L       98 "DK"  , modify
label define ER7006L       99 "NA"  , modify

label define ER7007L  ///
       1 "Male"  ///
       2 "Female"  ///
       0 "Wild code"

label define ER72001L  ///
       1 "Release number 1, March 2021"

forvalues n = 1/51 {
    label define ER72003L `n' "Actual state (PSID State code)"  , modify
}
label define ER72003L       99 "DK; NA"  , modify
label define ER72003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER72004L `n' "Actual state (FIPS code)"  , modify
}
label define ER72004L       99 "DK; NA"  , modify
label define ER72004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER72018L  ///
       1 "Male"  ///
       2 "Female"

label define ER78001L  ///
       1 "Release number 1, June 2023"  ///
       2 "Release number 2, October 2023"  ///
       3 "Release number 3, May 2025"

forvalues n = 1/51 {
    label define ER78003L `n' "Actual state (PSID State code)"  , modify
}
label define ER78003L       99 "DK; NA"  , modify
label define ER78003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER78004L `n' "Actual state (FIPS code)"  , modify
}
label define ER78004L       99 "DK; NA"  , modify
label define ER78004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER78018L  ///
       1 "Male"  ///
       2 "Female"

label define ER82001L  ///
       1 "Release number 1, May 2025"

forvalues n = 1/51 {
    label define ER82003L `n' "Actual state (PSID State code)"  , modify
}
label define ER82003L       99 "DK; NA"  , modify
label define ER82003L        0 "Inap.: U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER82004L `n' "Actual state (FIPS code)"  , modify
}
label define ER82004L       99 "DK; NA"  , modify
label define ER82004L        0 "Inap.: U.S. territory or foreign country"  , modify

label define ER82019L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/51 {
    label define ER9247L `n' "Actual state (PSID State code)"  , modify
}
label define ER9247L       99 "DK; NA"  , modify
label define ER9247L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 1/56 {
    label define ER9248L `n' "Actual state (FIPS code)"  , modify
}
label define ER9248L       99 "DK; NA"  , modify
label define ER9248L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V1L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

label define V10001L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V10003L `n' "Actual state (PSID State code)"  , modify
}
label define V10003L       99 "DK; NA"  , modify
label define V10003L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V1008L `n' "Actual age of Head"  , modify
}
label define V1008L       98 "Ninety-eight years or older"  , modify
label define V1008L       99 "NA"  , modify

label define V1010L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 17/97 {
    label define V10419L `n' "Actual age"  , modify
}
label define V10419L       98 "98 years of age or older"  , modify
label define V10419L       99 "NA"  , modify

label define V10420L  ///
       1 "Male"  ///
       2 "Female"

label define V1101L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V1103L `n' "Actual state (PSID State code)"  , modify
}
label define V1103L       99 "DK; NA"  , modify
label define V1103L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V11101L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V11103L `n' "Actual state (PSID State code)"  , modify
}
label define V11103L       99 "DK; NA"  , modify
label define V11103L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 16/97 {
    label define V11606L `n' "Actual age"  , modify
}
label define V11606L       98 "Ninety-eight years of age or older"  , modify
label define V11606L       99 "NA"  , modify

label define V11607L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/96 {
    label define V117L `n' "Actual age"  , modify
}
label define V117L       97 "Ninety-seven years or older"  , modify
label define V117L       98 "DK"  , modify
label define V117L       99 "NA"  , modify

label define V119L  ///
       1 "Male"  ///
       2 "Female"  ///
       9 "NA"

forvalues n = 1/56 {
    label define V12380L `n' "Actual state (FIPS code)"  , modify
}
label define V12380L       99 "DK; NA"  , modify
label define V12380L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 16/93 {
    label define V1239L `n' "Actual age"  , modify
}
label define V1239L       99 "NA age"  , modify

label define V1240L  ///
       1 "Male"  ///
       2 "Female"

label define V12501L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V12503L `n' "Actual state (PSID State code)"  , modify
}
label define V12503L       99 "DK; NA"  , modify
label define V12503L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V13011L `n' "Actual age"  , modify
}
label define V13011L       98 "Ninety-eight years of age or older"  , modify
label define V13011L       99 "NA"  , modify

label define V13012L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V13632L `n' "Actual state (FIPS code)"  , modify
}
label define V13632L       99 "DK; NA"  , modify
label define V13632L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V13701L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V13703L `n' "Actual state (PSID State code)"  , modify
}
label define V13703L       99 "DK; NA"  , modify
label define V13703L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V14114L `n' "Actual age"  , modify
}
label define V14114L       98 "Ninety-eight years of age or older"  , modify
label define V14114L       99 "NA"  , modify

label define V14115L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V14679L `n' "Actual state (FIPS code)"  , modify
}
label define V14679L       99 "DK; NA"  , modify
label define V14679L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V14801L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V14803L `n' "Actual state (PSID State code)"  , modify
}
label define V14803L       99 "DK; NA"  , modify
label define V14803L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V15130L `n' "Actual age"  , modify
}
label define V15130L       98 "Ninety-eight years of age or older"  , modify
label define V15130L       99 "NA"  , modify

label define V15131L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V16153L `n' "Actual state (FIPS code)"  , modify
}
label define V16153L       99 "DK; NA"  , modify
label define V16153L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V16301L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V16303L `n' "Actual state (PSID State code)"  , modify
}
label define V16303L       99 "DK; NA"  , modify
label define V16303L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 18/97 {
    label define V16631L `n' "Actual age"  , modify
}
label define V16631L       98 "Ninety-eight years of age or older"  , modify
label define V16631L       99 "NA"  , modify

label define V16632L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V17539L `n' "Actual state (FIPS code)"  , modify
}
label define V17539L       99 "DK; NA"  , modify
label define V17539L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V17701L  ///
       2 "Release Number 2 - May 2008"  ///
       3 "Release Number 3 - December 2013"

forvalues n = 1/51 {
    label define V17703L `n' "Actual state (PSID State code)"  , modify
}
label define V17703L       99 "DK; NA"  , modify
label define V17703L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V1801L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V1803L `n' "Actual state (PSID State code)"  , modify
}
label define V1803L       99 "DK; NA"  , modify
label define V1803L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V18049L `n' "Actual age"  , modify
}
label define V18049L       98 "Ninety-eight years of age or older"  , modify
label define V18049L       99 "NA"  , modify

label define V18050L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V18890L `n' "Actual state (FIPS code)"  , modify
}
label define V18890L       99 "DK; NA"  , modify
label define V18890L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V19001L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V19003L `n' "Actual state (PSID State code)"  , modify
}
label define V19003L       99 "DK; NA"  , modify
label define V19003L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V19349L `n' "Actual age"  , modify
}
label define V19349L       98 "Ninety-eight years of age or older"  , modify
label define V19349L       99 "NA"  , modify

label define V19350L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 15/97 {
    label define V1942L `n' "Actual age"  , modify
}
label define V1942L       98 "Ninety-eight years of age or older"  , modify
label define V1942L       99 "NA, DK"  , modify

label define V1943L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V20190L `n' "Actual state (FIPS code)"  , modify
}
label define V20190L       99 "DK; NA"  , modify
label define V20190L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V20301L  ///
       3 "Release number 3 - May 2008"  ///
       4 "Release number 4 - December 2013"

forvalues n = 1/51 {
    label define V20303L `n' "Actual state (PSID State code)"  , modify
}
label define V20303L       99 "DK; NA"  , modify
label define V20303L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 14/97 {
    label define V20651L `n' "Actual age"  , modify
}
label define V20651L       98 "Ninety-eight years of age or older"  , modify
label define V20651L       99 "NA"  , modify

label define V20652L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V21496L `n' "Actual state (FIPS code)"  , modify
}
label define V21496L       99 "DK; NA"  , modify
label define V21496L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V21601L  ///
       1 "Release number 1 - January 1998"  ///
       2 "Release number 2 - February 1998"  ///
       3 "Release number 3 - April 2000"  ///
       4 "Release number 4 - May 2008"

forvalues n = 1/51 {
    label define V21603L `n' "Actual state (PSID State code)"  , modify
}
label define V21603L       99 "DK; NA"  , modify
label define V21603L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 14/97 {
    label define V22406L `n' "Actual age"  , modify
}
label define V22406L       98 "Ninety-eight years of age or older"  , modify
label define V22406L       99 "NA"  , modify

label define V22407L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/56 {
    label define V23328L `n' "Actual state (FIPS code)"  , modify
}
label define V23328L       99 "DK; NA"  , modify
label define V23328L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V2401L  ///
       2 "Release number 2 -- May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V2403L `n' "Actual state (PSID State code)"  , modify
}
label define V2403L       99 "DK; NA"  , modify
label define V2403L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/96 {
    label define V2542L `n' "Actual age"  , modify
}
label define V2542L       99 "NA age"  , modify

label define V2543L  ///
       1 "Male"  ///
       2 "Female"

label define V3001L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V3003L `n' "Actual state (PSID State code)"  , modify
}
label define V3003L       99 "DK; NA"  , modify
label define V3003L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V3095L `n' "Actual age"  , modify
}
label define V3095L       99 "NA"  , modify

label define V3096L  ///
       1 "Male"  ///
       2 "Female"

label define V3401L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V3403L `n' "Actual state (PSID State code)"  , modify
}
label define V3403L       99 "DK; NA"  , modify
label define V3403L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/93 {
    label define V3508L `n' "Actual age"  , modify
}
label define V3508L       99 "NA; DK"  , modify

label define V3509L  ///
       1 "Male"  ///
       2 "Female"

label define V3801L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V3803L `n' "Actual state (PSID State code)"  , modify
}
label define V3803L       99 "DK; NA"  , modify
label define V3803L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 16/97 {
    label define V3921L `n' "Actual age"  , modify
}
label define V3921L       98 "Ninety-eight years of age or older"  , modify
label define V3921L       99 "NA; DK age"  , modify

label define V3922L  ///
       1 "Male"  ///
       2 "Female"

label define V4301L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V4303L `n' "Actual state (PSID State code)"  , modify
}
label define V4303L       99 "DK; NA"  , modify
label define V4303L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V441L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 16/97 {
    label define V4436L `n' "Actual age"  , modify
}
label define V4436L       98 "Ninety-eight years of age or older"  , modify
label define V4436L       99 "NA; DK"  , modify

label define V4437L  ///
       1 "Male"  ///
       2 "Female"

label define V5201L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V5203L `n' "Actual state (PSID State code)"  , modify
}
label define V5203L       99 "DK; NA"  , modify
label define V5203L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/95 {
    label define V5350L `n' "Actual age of Head"  , modify
}
label define V5350L       99 "NA"  , modify

label define V5351L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/51 {
    label define V537L `n' "Actual state (PSID State code)"  , modify
}
label define V537L       99 "DK; NA"  , modify
label define V537L        0 "Inap.:  U.S. territory or foreign country"  , modify

label define V5701L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V5703L `n' "Actual state (PSID State code)"  , modify
}
label define V5703L       99 "DK; NA"  , modify
label define V5703L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 16/96 {
    label define V5850L `n' "Actual age"  , modify
}
label define V5850L       99 "NA"  , modify

label define V5851L  ///
       1 "Male"  ///
       2 "Female"

label define V6301L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V6303L `n' "Actual state (PSID State code)"  , modify
}
label define V6303L       99 "DK; NA"  , modify
label define V6303L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V6462L `n' "Actual age"  , modify
}
label define V6462L       99 "NA"  , modify

label define V6463L  ///
       1 "Male"  ///
       2 "Female"

label define V6901L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V6903L `n' "Actual state (PSID State code)"  , modify
}
label define V6903L       99 "DK; NA"  , modify
label define V6903L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 16/97 {
    label define V7067L `n' "Actual age"  , modify
}
label define V7067L       98 "Ninety-eight years of age or older"  , modify
label define V7067L       99 "NA"  , modify

label define V7068L  ///
       1 "Male"  ///
       2 "Female"

label define V7501L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V7503L `n' "Actual state (PSID State code)"  , modify
}
label define V7503L       99 "DK; NA"  , modify
label define V7503L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V7658L `n' "Actual age"  , modify
}
label define V7658L       98 "98 years of age or older"  , modify
label define V7658L       99 "NA"  , modify

label define V7659L  ///
       1 "Male"  ///
       2 "Female"

label define V8201L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V8203L `n' "Actual state (PSID State code)"  , modify
}
label define V8203L       99 "DK; NA"  , modify
label define V8203L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 17/97 {
    label define V8352L `n' "Actual age"  , modify
}
label define V8352L       98 "Ninety-eight years of age or older"  , modify
label define V8352L       99 "NA"  , modify

label define V8353L  ///
       1 "Male"  ///
       2 "Female"

label define V8801L  ///
       2 "Release number 2 - May 2008"  ///
       3 "Release number 3 - December 2013"

forvalues n = 1/51 {
    label define V8803L `n' "Actual state (PSID State code)"  , modify
}
label define V8803L       99 "DK; NA"  , modify
label define V8803L        0 "Inap.:  U.S. territory or foreign country"  , modify

forvalues n = 14/97 {
    label define V8961L `n' "Actual age"  , modify
}
label define V8961L       98 "Ninety-eight years of age or older"  , modify
label define V8961L       99 "NA"  , modify

label define V8962L  ///
       1 "Male"  ///
       2 "Female"

forvalues n = 1/51 {
    label define V93L `n' "Actual state (PSID state code)"  , modify
}
label define V93L       99 "DK; NA"  , modify
label define V93L        0 "Inap.:  U.S. territory or foreign country"  , modify

label values ER10001    ER10001L
label values ER10004    ER10004L
label values ER10010    ER10010L
label values ER12221    ER12221L
label values ER13001    ER13001L
label values ER13004    ER13004L
label values ER13005    ER13005L
label values ER13011    ER13011L
label values ER17001    ER17001L
label values ER17004    ER17004L
label values ER17005    ER17005L
label values ER17014    ER17014L
label values ER2001     ER2001L
label values ER2007     ER2007L
label values ER2008     ER2008L
label values ER21001    ER21001L
label values ER21003    ER21003L
label values ER21004    ER21004L
label values ER21018    ER21018L
label values ER25001    ER25001L
label values ER25003    ER25003L
label values ER25004    ER25004L
label values ER25018    ER25018L
label values ER30000    ER30000L
label values ER30003    ER30003L
label values ER30010    ER30010L
label values ER30021    ER30021L
label values ER30022    ER30022L
label values ER30044    ER30044L
label values ER30045    ER30045L
label values ER30052    ER30052L
label values ER30068    ER30068L
label values ER30069    ER30069L
label values ER30076    ER30076L
label values ER30092    ER30092L
label values ER30093    ER30093L
label values ER30100    ER30100L
label values ER30118    ER30118L
label values ER30119    ER30119L
label values ER30126    ER30126L
label values ER30139    ER30139L
label values ER30140    ER30140L
label values ER30147    ER30147L
label values ER30161    ER30161L
label values ER30162    ER30162L
label values ER30169    ER30169L
label values ER30189    ER30189L
label values ER30190    ER30190L
label values ER30197    ER30197L
label values ER30218    ER30218L
label values ER30219    ER30219L
label values ER30226    ER30226L
label values ER30247    ER30247L
label values ER30248    ER30248L
label values ER30255    ER30255L
label values ER30284    ER30284L
label values ER30285    ER30285L
label values ER30296    ER30296L
label values ER30314    ER30314L
label values ER30315    ER30315L
label values ER30326    ER30326L
label values ER30344    ER30344L
label values ER30345    ER30345L
label values ER30356    ER30356L
label values ER30374    ER30374L
label values ER30375    ER30375L
label values ER30384    ER30384L
label values ER30400    ER30400L
label values ER30401    ER30401L
label values ER30413    ER30413L
label values ER30430    ER30430L
label values ER30431    ER30431L
label values ER30443    ER30443L
label values ER30464    ER30464L
label values ER30465    ER30465L
label values ER30478    ER30478L
label values ER30499    ER30499L
label values ER30500    ER30500L
label values ER30513    ER30513L
label values ER30536    ER30536L
label values ER30537    ER30537L
label values ER30549    ER30549L
label values ER30571    ER30571L
label values ER30572    ER30572L
label values ER30584    ER30584L
label values ER30607    ER30607L
label values ER30608    ER30608L
label values ER30620    ER30620L
label values ER30643    ER30643L
label values ER30644    ER30644L
label values ER30657    ER30657L
label values ER30690    ER30690L
label values ER30691    ER30691L
label values ER30703    ER30703L
label values ER30734    ER30734L
label values ER30735    ER30735L
label values ER30748    ER30748L
label values ER30807    ER30807L
label values ER30808    ER30808L
label values ER30820    ER30820L
label values ER32000    ER32000L
label values ER32006    ER32006L
label values ER33102    ER33102L
label values ER33103    ER33103L
label values ER33115    ER33115L
label values ER33202    ER33202L
label values ER33203    ER33203L
label values ER33215    ER33215L
label values ER33302    ER33302L
label values ER33303    ER33303L
label values ER33315    ER33315L
label values ER33402    ER33402L
label values ER33403    ER33403L
label values ER33415    ER33415L
label values ER33502    ER33502L
label values ER33503    ER33503L
label values ER33516    ER33516L
label values ER33602    ER33602L
label values ER33603    ER33603L
label values ER33616    ER33616L
label values ER33702    ER33702L
label values ER33703    ER33703L
label values ER33716    ER33716L
label values ER33802    ER33802L
label values ER33803    ER33803L
label values ER33817    ER33817L
label values ER33902    ER33902L
label values ER33903    ER33903L
label values ER33917    ER33917L
label values ER34002    ER34002L
label values ER34003    ER34003L
label values ER34020    ER34020L
label values ER34102    ER34102L
label values ER34103    ER34103L
label values ER34119    ER34119L
label values ER34202    ER34202L
label values ER34203    ER34203L
label values ER34230    ER34230L
label values ER34302    ER34302L
label values ER34303    ER34303L
label values ER34349    ER34349L
label values ER34502    ER34502L
label values ER34503    ER34503L
label values ER34548    ER34548L
label values ER34702    ER34702L
label values ER34703    ER34703L
label values ER34752    ER34752L
label values ER34902    ER34902L
label values ER34903    ER34903L
label values ER34952    ER34952L
label values ER35102    ER35102L
label values ER35103    ER35103L
label values ER35152    ER35152L
label values ER36001    ER36001L
label values ER36003    ER36003L
label values ER36004    ER36004L
label values ER36018    ER36018L
label values ER4156     ER4156L
label values ER4157     ER4157L
label values ER42001    ER42001L
label values ER42003    ER42003L
label values ER42004    ER42004L
label values ER42018    ER42018L
label values ER47301    ER47301L
label values ER47303    ER47303L
label values ER47304    ER47304L
label values ER47318    ER47318L
label values ER5001     ER5001L
label values ER5006     ER5006L
label values ER5007     ER5007L
label values ER53001    ER53001L
label values ER53003    ER53003L
label values ER53004    ER53004L
label values ER53018    ER53018L
label values ER60001    ER60001L
label values ER60003    ER60003L
label values ER60004    ER60004L
label values ER60018    ER60018L
label values ER66001    ER66001L
label values ER66003    ER66003L
label values ER66004    ER66004L
label values ER66018    ER66018L
label values ER6996     ER6996L
label values ER6997     ER6997L
label values ER7001     ER7001L
label values ER7006     ER7006L
label values ER7007     ER7007L
label values ER72001    ER72001L
label values ER72003    ER72003L
label values ER72004    ER72004L
label values ER72018    ER72018L
label values ER78001    ER78001L
label values ER78003    ER78003L
label values ER78004    ER78004L
label values ER78018    ER78018L
label values ER82001    ER82001L
label values ER82003    ER82003L
label values ER82004    ER82004L
label values ER82019    ER82019L
label values ER9247     ER9247L
label values ER9248     ER9248L
label values V1         V1L
label values V10001     V10001L
label values V10003     V10003L
label values V1008      V1008L
label values V1010      V1010L
label values V10419     V10419L
label values V10420     V10420L
label values V1101      V1101L
label values V1103      V1103L
label values V11101     V11101L
label values V11103     V11103L
label values V11606     V11606L
label values V11607     V11607L
label values V117       V117L
label values V119       V119L
label values V12380     V12380L
label values V1239      V1239L
label values V1240      V1240L
label values V12501     V12501L
label values V12503     V12503L
label values V13011     V13011L
label values V13012     V13012L
label values V13632     V13632L
label values V13701     V13701L
label values V13703     V13703L
label values V14114     V14114L
label values V14115     V14115L
label values V14679     V14679L
label values V14801     V14801L
label values V14803     V14803L
label values V15130     V15130L
label values V15131     V15131L
label values V16153     V16153L
label values V16301     V16301L
label values V16303     V16303L
label values V16631     V16631L
label values V16632     V16632L
label values V17539     V17539L
label values V17701     V17701L
label values V17703     V17703L
label values V1801      V1801L
label values V1803      V1803L
label values V18049     V18049L
label values V18050     V18050L
label values V18890     V18890L
label values V19001     V19001L
label values V19003     V19003L
label values V19349     V19349L
label values V19350     V19350L
label values V1942      V1942L
label values V1943      V1943L
label values V20190     V20190L
label values V20301     V20301L
label values V20303     V20303L
label values V20651     V20651L
label values V20652     V20652L
label values V21496     V21496L
label values V21601     V21601L
label values V21603     V21603L
label values V22406     V22406L
label values V22407     V22407L
label values V23328     V23328L
label values V2401      V2401L
label values V2403      V2403L
label values V2542      V2542L
label values V2543      V2543L
label values V3001      V3001L
label values V3003      V3003L
label values V3095      V3095L
label values V3096      V3096L
label values V3401      V3401L
label values V3403      V3403L
label values V3508      V3508L
label values V3509      V3509L
label values V3801      V3801L
label values V3803      V3803L
label values V3921      V3921L
label values V3922      V3922L
label values V4301      V4301L
label values V4303      V4303L
label values V441       V441L
label values V4436      V4436L
label values V4437      V4437L
label values V5201      V5201L
label values V5203      V5203L
label values V5350      V5350L
label values V5351      V5351L
label values V537       V537L
label values V5701      V5701L
label values V5703      V5703L
label values V5850      V5850L
label values V5851      V5851L
label values V6301      V6301L
label values V6303      V6303L
label values V6462      V6462L
label values V6463      V6463L
label values V6901      V6901L
label values V6903      V6903L
label values V7067      V7067L
label values V7068      V7068L
label values V7501      V7501L
label values V7503      V7503L
label values V7658      V7658L
label values V7659      V7659L
label values V8201      V8201L
label values V8203      V8203L
label values V8352      V8352L
label values V8353      V8353L
label values V8801      V8801L
label values V8803      V8803L
label values V8961      V8961L
label values V8962      V8962L
label values V93        V93L
