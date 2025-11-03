
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



*/











