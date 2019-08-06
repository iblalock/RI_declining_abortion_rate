clear all
cd "/Users/isabelblalock/Desktop/stata thesis/code"
use ../temp/ipums_data_processed.dta, clear

merge m:1 year using ../temp/ridoh_numerator.dta, ///
	assert(3) keep(3) nogen

keep if year == 2012 | year == 2016
gen year2012 = year == 2012	

foreach var in white black other education_1to11 education_diploma ///
	education_somecollege education_college unmarried married seperateddivorced ///
	ageteen agetwenty agethirty ageforty {
	cap matrix drop pop table ab
	
	qui mean `var'_ab, over(year2012)
	matrix table = r(table)
	matrix ab = table[1,1...]
	local ab2016 = ab[1,1]
	local ab2012 = ab[1,2]
	
	svy: mean `var'_pop, over(year2012)
	matrix pop = e(_N_subp)
	local pop2016 = pop[1,1]
	local pop2012 = pop[1,2]
	
	nlcom (`ab2016'/([`var'_pop]0*`pop2016') - `ab2012'/([`var'_pop]1*`pop2012')) / (`ab2012'/([`var'_pop]1*`pop2012'))
}
