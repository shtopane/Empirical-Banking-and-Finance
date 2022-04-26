clear

// log using regressions_tutorial2, text

// 1. Regression 1
// a) load data
use dataEmpBF_Tutorial2.dta

summarize gdpgrowth public_banks_1970 loggdp_1960

pwcorr loggdp_1960 gdpgrowth public_banks_1970
// In the first regression the [La Porta et al., 2002] include only
// gdpgrowth and public_banks_1970 in a regression. Let's check

// regress gdpgrowth public_banks_1970 // beta -9.82502

// b) run this regression
regress gdpgrowth public_banks_1970 loggdp_1960 // beta -11.11978 

// c) compare the coeffictient for public_banks_1970 from the [La Porta et al., 2002]
// paper. Comment briefly
// - Our coefficient is -11.11978, theirs is around -0.024. The sign is the same, suggesting
// that government ownership of banks affects growth negatively, but strangly our coefficient is way bigger.

// 2. Descriptive statistics
// a) compute summary statistics for all variables and comment
summarize
// We have 2 dummies: europe and oecd. schooling is a bit strange, but understandable.
// We have missing values for some variables

// b) create scatterplot gdpgrowth and public_banks_1970
twoway (scatter gdpgrowth public_banks_1970)
// Save graph
// graph export gdpgrowth_public_banks_197.pdf

// c) remove the two outliers. Why can we remove the two outliers?
// - Because we're heartless people not interested in the wellbeing of Fantasia and Wonderland
drop if country_name == "Fantasia" || country_name == "Wonderland"

// d) recreate scatterplot
twoway (scatter gdpgrowth public_banks_1970)
// graph export gdpgrowth_public_banks_197_removed_outliers.pdf

// 3. Regression 2
// a) re-run regression 1
// Now the coefficients for public_banks_1970 are the same.
// The two outliers move the mean by a lot. This causes OLS to overestimate their effect // on the regression.
regress gdpgrowth public_banks_1970 loggdp_1960

// b) Are the coefficients statistically significant?
// Yes, they are. public_banks_1970 p-value: 0.003; loggdp_1960 p-value: 0.015

// c) Interpret the sign of each coefficient.
// public_banks_1970: we get a negative coefficient. It suggests that for every 10% growth // in public bank ownership, GDP growth decreases by around 0.23% per anum.
// loggdp_1960: the coefficient is suggesting that 10% increase in GDP per capita causes // 6.4% decrease in annual GDP growth


// d) For our regression model the Adj R-squared is 10.26%. If we include the variable schooling, Adj R-squared increases to 31.59%. We should consider Adj R-squared as a measure of how good X variables are explaining GDP growth, as Adj R-squared takes into account degrees of freedom.
regress gdpgrowth public_banks_1970 loggdp_1960 schooling 

// e) public_banks_1970 may be correlated with other variables such as government interventions in a given country or protection and prevelence of property rights. Also, many countries were under the Soviet influence, which was affecting things like private property, property of banks included.

// 4. Regression 3: Control variables
// a) add schooling and birth_rate_1970
regress gdpgrowth public_banks_1970 loggdp_1960 schooling birth_rate_1970
// public_banks_1970 -.0263877 Regression 3
// public_banks_1970 -.023484 Regression 2

// Two-step procedure from class
regress public_banks_1970 loggdp_1960 schooling birth_rate_1970
predict public_banks_1970_tilde, resid

regress gdpgrowth public_banks_1970_tilde

// a) ANSWER: We get the same coefficient as with the original regression: -.0263877, suggesting that schooling and birth_rate_1970 are good controls and we should include them if we want to not have the issue of ommited variable bias

// b) public_banks_1970, loggdp_1960 and birth_rate_1970 are statistically significant.
// c) birth_rate_1970: the negative sign here suggests a decrease in GDP growth with increase in birth rate per 1000 inhabitants. This makes sense, since we're measuring GDP growth per capita. In terms of coefficinets we can conclude the economic effect as follows:
// An increase by 10% of public ownership of banks decreases GDP growth by around -0.26% per anum; an increase of ?? of birth_rate_1970 decreases GDP growth by around -0.0016

// d) Test for the joint significance of schooling and birth_rate_1970. Provide H0, HA, the test
// statistic, its distribution and the result of the test
// H0: schooling = birth_rate_1970 = 0
regress public_banks_1970 loggdp_1960 schooling birth_rate_1970
test schooling birth_rate_1970
// we cannot reject the NULL, F (2, 79) = 1.57; Prob > F = 0.2142
// HA: schooling != 0 and birth_rate_1970 != 0

// e) we get Adj. R-squared for this regression of 0.51 compared to just 0.10 for Regression 2.

// 5. Regression 4: Interaction
// a) private_credit_1960 may be related to public_banks_1970. Lower values of private credit can trigger government intervention in the financial market - if the private sector does not provide finance for the economy, then the government can do that through state owned banks.

// b)
regress gdpgrowth public_banks_1970 private_credit_1960 c.public_banks_1970#c.private_credit_1960 loggdp_1960

// c) 
// public_banks_1970: negative sign, coefficient is -.0397587. This means that public ownership of banks has negative effect on GDP growth.
// private_credit_1960: positive sign, coefficient is .0186234. This means that private credit to GDP has positive effect on GDP growth.


// TODO: DO THE OTHER 

// 6. Regression 5: Dummies I
// a) 
regress gdpgrowth public_banks_1970 loggdp_1960
regress gdpgrowth public_banks_1970 loggdp_1960 europe i.europe#c.public_banks_1970 i.europe#c.loggdp_1960

// b) the constant tells us the effect of europe = 1. europe dummy tells us if a country is in Europe.


// d)
regress gdpgrowth public_banks_1970 loggdp_1960 i.europe#c.public_banks_1970 i.europe#c.loggdp_1960
// it means that europe coefficient will be assumed to be 0, stating that there is not effect of being in Europe on GDP growth. This is false interpretation.

// 7. Regression 6: Dummies II
// a)
regress gdpgrowth public_banks_1970 loggdp_1960

ge in_europe = europe == 1
ge not_in_europe = europe == 0

regress gdpgrowth public_banks_1970 loggdp_1960 europe not_in_europe i.europe#c.public_banks_1970 i.europe#c.loggdp_1960 i.not_in_europe#c.public_banks_1970 i.not_in_europe#c.loggdp_1960

// b) not_in_europe has the same information as europe, it is just a negation of the europe dummy.

// c) if we don't exclude the constant, not_in_europe dummy gets ommited by STATA(perfect collinearity). In this case the constant is acting like the dummy.

// d)
regress gdpgrowth public_banks_1970 loggdp_1960 if europe == 1
regress gdpgrowth public_banks_1970 loggdp_1960 if europe == 0

// Regression 5 output
 //public_banks_1970 |  -.0355186   .0086117    -4.12   0.000    -.0526598   -.0183774
  //     loggdp_1960 |  -.0121379   .0029976    -4.05   0.000    -.0181044   -.0061713
  
// Regression 7 a) output
public_banks_1970 |   -.023484   .0075477    -3.11   0.003    -.0384987   -.0084693
      loggdp_1960 |  -.0064537   .0026094    -2.47   0.015    -.0116445   -.0012628

	  
// Compare to results in a): for values of europe = 1, we get coefficient for public_banks_1970  -.0071763 and for loggdp_1960 we get -.0013226. The effects are smaller for countries in Europe. For values of europe = 0 we get coefficients of public_banks_1970 and loggdp_1960 of  -.0355186 and -.0121379 respectively. The effects are larger for countries outside of Europe.

// e) For values of europe = 0, the coefficients are exactly the same. For values of europe = 1, the coefficients are smaller than in Regression 5.
































// log close regressions_tutorial2