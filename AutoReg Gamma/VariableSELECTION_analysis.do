* Lasso, stepwise regression, ridge

* run both and compare across in both coefficents, selection of variables, and significance  

use "/Users/ethanballou/Documents/Data/Risk/old_gam_data_modified.dta", clear

* Load the example dataset
sysuse auto, clear

* Convert the headroom variable to a categorical variable
egen headroom_cat = cut(headroom), at(1 2 3 4 5)


reg price mpg weight length foreign

*------------------------------------------------------------
* 1. Stepwise Regression
*    Here we use a stepwise selection with a p-value criterion of 0.05.
*    This will start with an empty model and add variables that meet the criterion.
*------------------------------------------------------------
stepwise, pr(.2): regress price mpg weight length foreign i.headroom_cat

*------------------------------------------------------------
* 2. LASSO Regression
*    Stata’s built-in lasso routines can be used for variable selection.
*    Here we run a linear lasso regression with the adaptive selection method.
*------------------------------------------------------------
lasso linear price mpg weight length foreign i.headroom_cat, selection(adaptive) rseed(12345)

* To view the selected model variables after lasso, type:
lasso list


*------------------------------------------------------------
* 3. Ridge Regression
*    Ridge regression is not built into Stata’s base installation but is available 
*    via an SSC package. The following code installs and uses the 'ridgereg' package.
*------------------------------------------------------------

* If not already installed, install the ridgereg package:
ssc install ridgereg

* Run ridge regression with a specified lambda value (here, 0.1):
ridgereg price mpg weight length foreign , model(grr1)


