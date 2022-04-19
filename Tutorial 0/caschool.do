* My first STATA file. YAY!
clear /* deletes current dataset from memory*/

* Create log-file
log using caschool, replace

* Loading the dataset
use caschool.dta

* Descriptive statistics
su

* Creating a scatterplot with a regression line
twoway (scatter testscr str) (lfit testscr str)

* Regression with robust standard errors
reg testscr str, robust

* Deriving the fit and the residuals
predict testscrfit
predict testscrres, residuals

** Saving the extended file
save caschool2.dta, replace

* Close the log-file
log close