clear

use dataEmpBF_Tutorial6.dta

summarize

// 1.
tab year if ind_deregYear == 1
histogram ind_deregYear, frequency discrete
// 2. Regression 1
// a) Replicate regression 5 from Table II
// ssc install reghdfe
gen di_variable = ind_dereg - ind_deregYear
drop if ind_deregYear == 1
reghdfe GDPgr ind_dereg, absorb(state year) vce(robust)

// d)
// encode state, gen(stateen)
// tsset state year
// gen blas = f1.ind_dereg
sort year
gen lag_ind_dereg = ind_dereg[_n-1]
reghdfe GDPgr lag_ind_dereg, absorb(state year) vce(robust)

// Regression 2
// b)
reghdfe GDPgr ind_dereg, absorb(region year)

// 4.
// ssc install bacondecomp
bacondecomp GDPgr ind_dereg if ind_deregYear == 0, stub(Bacon_) robust



// d)
bysort Bacon_gp: egen mean_GDPgr = mean(GDPgr)
twoway (scatter mean_GDPgr year [aweight = Bacon_S])
// twoway (line GDPgr year by(Bacon_cgroup))
// twoway (line GDPgr year if ind_deregYear == 1 & ind_dereg == 1, xline(1972)) (line GDPgr year if ind_deregYear == 0 & ind_dereg == 0)