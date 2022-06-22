clear

use "dataEmpBF_Tutorial4.dta"
rename c country
su

// 1. Regression 1
// a)
// twoway (scatter logGDP_future private_credit_past) (lfit logGDP_future private_credit_past)
// graph export logGDP_future_private_credit_past.pdf
reghdfe logGDP_future private_credit_past, absorb(c)

//  b)
tabulate country, gen(countrydummy)
regress logGDP_future private_credit_past countrydummy*
// coeff:  -.1186336

//  c) compute average for each country over time (of the two variables)
//  Not sure(this produces the same mean for a given country irrespective of year)
egen logGDP_future_mean = mean(logGDP_future), by(country)
egen private_credit_past_mean = mean(private_credit_past), by(country)

//  _mc: mean centered
gen logGDP_future_mc = logGDP_future - logGDP_future_mean
gen private_credit_past_mc = private_credit_past - private_credit_past_mean

// twoway (scatter logGDP_future_mc private_credit_past_mc) (lfit logGDP_future_mc private_credit_past_mc)
// graph export demeaned_logGDP_future_private_credit_past.pdf
regress logGDP_future_mc private_credit_past_mc

// f)
regress logGDP_future private_credit_past, robust

// 2. 
// a)
regress logGDP_future private_credit_past, robust
predict lp_residuals, residuals

regress logGDP_future private_credit_past, vce(cluster dnum)
// Mounton factor
// v_cluster(beta_hat) / v_standard(beta_hat) = 1 + (n - 1)