clear

use "dataEmpBF_Tutorial4.dta"
rename c country
su

// 1. Regression 1
// a)
// twoway (scatter logGDP_future private_credit_past) (lfit logGDP_future private_credit_past)
// graph export logGDP_future_private_credit_past.pdf
ssc install reghdfe
ssc install ftools
reghdfe logGDP_future private_credit_past, absorb(country)

//  b)
tabulate country, gen(countrydummy)
regress logGDP_future private_credit_past countrydummy*
// coeff:  -.1186336

//  c) compute average for each country over time (of the two variables)
//  Not sure(this produces the same mean for a given country irrespective of year)
egen groupByC = group(CountryCode)

egen logGDP_future_mean = mean(logGDP_future), by(groupByC)
egen private_credit_past_mean = mean(private_credit_past), by(groupByC)

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

// Interclass correlation: 0.30826
// evaluated at n: 22.94
loneway logGDP_future CountryCode
// Moulton factor
// v_cluster(beta_hat) / v_standard(beta_hat) = 1 + (n - 1)rho
gen rho = 0.30826
gen n = 22.94
gen moulton = 1 + (n - 1)*rho
display moulton // 7.7632246
// sqrt(7.7632246) * .0166412
regress logGDP_future private_credit_past, cluster(CountryCode)
// By cluster SE .0301066

// 3.
// b)
// Without cluster year: .0143736
// Without cluster coutnry: .0149227
reghdfe logGDP_future private_credit_past, absorb(year)
reghdfe logGDP_future private_credit_past, absorb(CountryCode)
// CLuster year SE: .0212884
// CLuster country SE: .0301066
regress logGDP_future private_credit_past, cluster(year)
regress logGDP_future private_credit_past, cluster(CountryCode)

// 4.
// a)
reghdfe logGDP_future_mc private_credit_past_mc, absorb(CountryCode) vce(cluster CountryCode)

egen household_credit_past_mean = mean(household_credit_past), by(groupByC)
display household_credit_past_mean

twoway (scatter logGDP_future household_credit_past) (lfit logGDP_future household_credit_past)

// Column 2
reghdfe logGDP_future household_credit_past, absorb(CountryCode) vce(cluster CountryCode)
test household_credit_past
// Column 3
reghdfe logGDP_future firm_credit_past, absorb(CountryCode) vce(cluster CountryCode)

// Column 4
reghdfe logGDP_future household_credit_past firm_credit_past, absorb(CountryCode) vce(cluster CountryCode)
// b)
test firm_credit_past == household_credit_past


// c)
reghdfe logGDP_future firm_credit_past, absorb(CountryCode year) vce(cluster CountryCode)
// Coeff country + year: -.0788562
// SE country + year: .0367385 
// Coeff country:  -.0978232
// SE country:  .0362572

// 5.
histogram(logGDP)