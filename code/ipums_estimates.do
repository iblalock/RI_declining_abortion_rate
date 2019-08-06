clear all
set more off
cd "/Users/isabelblalock/Desktop/stata thesis/code"


use ../temp/ipums_data.dta, clear

gen RI_female_age12_49 = statefip == 44 & sex == 2 & age >= 12 & age <= 49 // selecting sample - ri, female sex, age between etc 

svyset[pweight=perwt], vce(brr) brrweight(repwtp1-repwtp80) fay(.5)mse //setting the survey//
//using person weight - look up description //

gen white_pop = race == 1 // defining the rhode island variables the same as the abortion data
gen black_pop = race == 2
gen other_pop = race > 2

gen education_1to11_pop = educ <= 5
gen education_diploma_pop = educ == 6 
gen education_somecollege_pop = educ ==7 | educ ==8  
gen education_college_pop = educ == 9 | educ == 10 

gen unmarried_pop = marst == 6
gen married_pop = marst == 1
gen seperateddivorced_pop = marst == 3 | marst== 4 

gen ageteen_pop = age >=12 & age <=19
gen agetwenty_pop = age >=20 & age <=29
gen agethirty_pop = age >=30 & age <=39
gen ageforty_pop = age >=40 & age <=49

keep if RI_female_age12_49 == 1 // keep only the sample i want

save ../temp/ipums_data_processed.dta, replace


use ../temp/ipums_data_processed.dta, clear

foreach var in white_pop black_pop other_pop education_1to11_pop education_diploma_pop ///
	education_somecollege_pop education_college_pop unmarried_pop married_pop seperateddivorced_pop ///
	ageteen_pop agetwenty_pop agethirty_pop ageforty_pop {
	 
	svy: mean `var', over(year)
	matrix table = r(table)
	matrix coef = table[1,1...]'
	matrix ll = table[5,1...]'
	matrix ul = table[6,1...]'
	
	matrix block = (coef, ll, ul)
	matrix colname block = "`var'_c" "`var'_ul" "`var'_ll" // creating the CI because it's survey data / weighting
	
	matrix ipums_est = (nullmat(ipums_est), block)
}
// counting share of people in each categorg -- 

estat size
matrix tot_pop = e(_N_subp)'
matrix colname tot_pop = "tot_pop"
matrix ipums_est = (tot_pop, ipums_est)

clear
svmat ipums_est, names(col)
gen year = 2011+_n

foreach var in white_pop black_pop other_pop education_1to11_pop education_diploma_pop ///
	education_somecollege_pop education_college_pop unmarried_pop married_pop seperateddivorced_pop ///
	ageteen_pop agetwenty_pop agethirty_pop ageforty_pop {
	
	foreach stub in c ll ul {
		replace `var'_`stub' = `var'_`stub'*tot_pop
	}
}
// multiplying the actual populatio number for each category by the "share" (mean) 

save ../temp/rhode_island_pop.dta, replace
