clear all
set more off
// cd "C:\Users\konra\Dropbox\Postdoc\Teaching Empirical Banking\Tutorials\"


use "dataEmpBF_Tutorial3", replace



*--------------------------------------------------
// 1)  Motivating IV 
*--------------------------------------------------


*--------------------------------------------------
// 2)  Regression 1: OLS 
*--------------------------------------------------

twoway (scatter gdpgrowth private_credit_1960 ) (lfit gdpgrowth private_credit_1960 )

* a) 
reg gdpgrowth private_credit_1960 , robust


* b) Beta coefficients to get the economic size
reg gdpgrowth private_credit_1960 , robust beta

est store reg1

*--------------------------------------------------
// 3) The Instrument
*--------------------------------------------------

* d) 
summarize legor_*
graph bar private_credit_1960, over(legor)
graph box private_credit_1960, over(legor)

*--------------------------------------------------
// 4) IV with one instrument 
*--------------------------------------------------

* a) Wald estimator 
su gdpgrowth if legor_fr==1
local m1 = `r(mean)'
su gdpgrowth if legor_fr==0
local m2 = `r(mean)'

* numerator
local d1 = `m1' - `m2'
disp "`d1'"

su private_credit_1960 if legor_fr==1
local m3 = `r(mean)'

su private_credit_1960 if legor_fr==0 
local m4 = `r(mean)'

* denominator
local d2 = `m3' - `m4'
disp "`d2'"

local waldb1 = (`m1' - `m2')/(`m3' - `m4')
disp "`waldb1'"


* b) 2SLS estimator
ivreg2  gdpgrowth  (private_credit_1960 = legor_fr ), robust
est store reg2

* c) compare Wald to 2SLS estimates 

* d)
esttab reg1 reg2 

* e) 95% confidence interval 

* f) under- over or exactly identified model?

* g) first stage to test the first requirement
reg private_credit_1960  legor_fr , robust






*--------------------------------------------------
// 5) IV with several instruments 
*--------------------------------------------------

* a) 
ivreg2  gdpgrowth  (private_credit_1960 = legor_uk legor_fr legor_so legor_ge), robust
est store reg3

*-------------
* Aside 1: 
*-------------

*if a control is added: here "loggdp_1960" is included automatically in the first stage as well, but don't forget to include it, if you run the first stage manually!

ivreg2  gdpgrowth loggdp_1960 (private_credit_1960 = legor_uk legor_fr legor_so legor_ge ), robust


*-----------------------
* Aside 2: 2SLS by hand 
*------------------------

reg private_credit_1960  legor_uk legor_fr legor_so legor_ge , robust
predict yhat, xb
reg gdpgrowth  yhat, robust 

twoway (line private_credit_1960 private_credit_1960) (scatter  yhat private_credit_1960, ytitle("Yhat") mlabel(country_name)) 

* right of 45 degree line: legal origins underpredict  private to credit to GDP
* left of 45 degree line: legal origins overpredict  private to credit to GDP

* This plot shows the difference between endogenous and exogenous component of private credit to GDP, as predicted by a country's legal origin

* example: China in 1960 has a higer private credit to GDP than what its socialist legal origin would predict
* 		   for the IV we only use the predicted value that is, hopefully, exogenous to other factors affecting GDP 



* c) Compare the coefficient on private_credit_1960 to the one in question 4 b). Provid a brief comment.
esttab reg1 reg2 reg3 

* e) Is the model underidentified, exactly identified or overidentified?

* f) Formally test whether the instruments are valid. Provide H0, HA, the test statistic, its distribution and the result of the test.



* FIRST REQUIREMENT: strong first stage
reg  private_credit_1960  legor_uk legor_fr legor_so legor_ge , robust
test (legor_uk=0) (legor_fr=0) (legor_so=0) (legor_ge=0)

* SECOND REQUIREMENT: exclusion restriction
*  H0 : at least one instrument is not exogenous

// with robust s.e.: Hansen J-Statistic 
ivreg2  gdpgrowth  (private_credit_1960 = legor_uk legor_fr legor_so legor_ge ), robust
* ->  "the minimized value of the GMM criterion function"
* we will not do that manually 


// without robust s.e.: Sargan statistic  
ivreg2  gdpgrowth  (private_credit_1960 = legor_uk legor_fr legor_so legor_ge )
* we can do that manually 

* manual version: Sargan statistic
ivregress 2sls  gdpgrowth  (private_credit_1960 = legor_uk legor_fr legor_so legor_ge )
predict residuals, resid
reg residuals legor_uk legor_fr legor_so legor_ge
local teststat = `e(N)'*`e(r2)'
disp "`teststat'"

* Intuition: the residuals include the endogenous part
* the more the supposedly exogenous variables can account for the variation in the endogenous part, the more likely we have to reject H_0 of all instruments being truly exogenous



* h) Test for endogeneity of regressors
//H0 : δ1 = 0: if we can reject, then the variable private credit is endogenous

ivregress 2sls gdpgrowth  (private_credit_1960 = legor_uk legor_fr legor_so legor_ge ) , robust
estat endogenous


*estat endogenous performs tests to determine whether endogenous regressors in the model are in fact exogenous. [...] 

* After 2SLS estimation with an unadjusted VCE, the Durbin (1954) and Wu-Hausman (Wu 1974; Hausman 1978) statistics are reported. 

*After 2SLS with a robust or VCE, Wooldridge's (1995) robust score test and a robust regression-based test are reported.  In all cases, if the test statistic is significant, then the     variables being tested must be treated as endogenous. 

* manual version 
qui: reg  private_credit_1960  legor_uk legor_fr legor_so legor_ge , robust
predict v, resid
qui: reg gdpgrowth  private_credit_1960  v , robust 
test v 


*--------------------------------------------------
// 6) IV with several instruments and several endogenous variables
*--------------------------------------------------

* a) 
*ivregress 2sls gdpgrowth loggdp_1960 (private_credit_1960 public_banks_1970 = legor_* loggdp_1960)
ivreg2 gdpgrowth  (private_credit_1960 public_banks_1970 = legor_* ), robust  
est store reg4

esttab reg*















