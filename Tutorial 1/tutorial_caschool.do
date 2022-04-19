clear

* Load data
use caschool.dta

* Show data
su

/** OLS Recap Exercises
**# Bookmark #1
1. Run Regression with testscr on the LHS and avginc in the RHS (left-hand-side and right-hand-side??)
a) plot the regression line along with the data
**/
* reg testscr avginc

* b) what do you notice? :- the data is not linear
graph twoway (lfit testscr avginc) (scatter testscr avginc)
* Save graph
*graph export testscr_avginc_raw.pdf

ge testscr_log = log(testscr)
ge avginc_log = log(avginc)
regress testscr_log avginc_log

predict testscr_logfit
predict testscr_logres, residuals

* take logs!
twoway (scatter testscr_log avginc_log) (lfit testscr_log avginc_log)
* Save graph
*graph export testscr_avginc_log.pdf


* 2. Standard errors: Run Regression with testscr on the LHS and avginc in the RHS (left-hand-side and right-hand-side??)
* a) Without any adjustment to standard errors
regress testscr avginc /* sd .0905044*/
* b) Robust
regress testscr avginc, robust /* robust sd .1136349 */
* c) Using the vce(h2) option
regress testscr avginc, vce(hc2) /* robust hc2 sd .1160015 */

* d) It seems that without robustness the standard error is not accurate. We are experiencing heteroscedasticity. Also, it seems that hc2 is getting the highest standard error and hence the most correct one

* 3. Verify beta_hat1 without reg command
* aa not sure how...


* 4. Some testing with different regression formulas
* a) include avginc*2 along avginc
ge avginc2 = avginc*2
regress testscr avginc avginc2
* ^ I get note: avginc omitted because of collinearity.

* b) regress on both avginc and avginc*2
regress testscr avginc /* beta_hat_1 1.87855*/
regress testscr avginc2 /*beta_hat_1 .9392748*/

ge avginc3 = avginc*3
ge avginc4 = avginc*4

regress testscr avginc3 /* beta_hat_1 .6261832 */
regress testscr avginc4 /* beta_hat_1 .4696374 */

* ^ Coefficient goes down with increasing degree of avginc

* c) scale testscr by 2,3,4 and leave avginc untouched

* Some error handling: If we don't have the var - define it. If we have the var - replace it
capture replace testscr_scaled = testscr*4

if _rc == 111 {
	ge testscr_scaled = testscr*4
}
else replace testscr_scaled = testscr*4 /* testscr*3, testscr*2*/
* End error handling

regress testscr_scaled avginc

/* beta_hat_1 3.757099, for testscr*2 */
/* beta_hat_1 5.635649, for testscr*3 */
/* beta_hat_1 7.514198, for testscr*3 */
* ^ beta_hat_1 increases with increase of the scaling of testscr

* 5. Replication of the two-step procedure to estimate the coefficient of avginc shown in class
* a)
regress testscr avginc teachers computer

* b) obtain the coeff for avginc
* Step 1: Regress avginc LHS and teachers and computer on RHS
regress avginc teachers computer

* Step 2: 
predict avginc_new, residuals
summarize avginc_new

* rvfplot, yline(0)
regress testscr avginc_new

* 6. Anatomy of the OLS coefficient
* a)
regress testscr computer_discrete
twoway (scatter testscr computer_discrete) (lfit testscr computer_discrete)
* Save graph
* graph export testscr_computer_discrete_raw.pdf
* b)
generate obs = 1
collapse testscr (sum) obs, by(computer_discrete)
summarize
* c)
regress testscr computer_discrete
rvfplot, yline(0)
* Save graph
* graph export testscr_computer_discrete_residuals_fitted.pdf
twoway (scatter testscr computer_discrete) (lfit testscr computer_discrete)
* Save graph
* graph export testscr_avg_computer_discrete_new.pdf
regress testscr computer_discrete [aw=obs]
twoway (scatter testscr computer_discrete) (lfit testscr computer_discrete)
