clear all
set more off
cd "/Users/isabelblalock/Desktop/stata thesis/code"


** TABLE 2
use "../temp/ridoh_panel", clear

gen white_ab = race == 1
gen black_ab = race == 2
gen other_ab = race == 3 | race==4 | race==5

gen education_1to11_ab = education == 1
gen education_diploma_ab = education ==2 
gen education_somecollege_ab = education ==3  
gen education_college_ab = education ==4 | education ==5 

gen unmarried_ab = married ==1 
gen married_ab = married==2 
gen seperateddivorced_ab = married==4 | married==5 

gen ageteen_ab = womanage==1
gen agetwenty_ab = womanage==2
gen agethirty_ab = womanage==3
gen ageforty_ab = womanage==4 //these are categories I was using before

collapse (sum) white_ab black_ab other_ab education_1to11_ab ///
	education_diploma_ab education_somecollege_ab education_college_ab ///
	unmarried_ab married_ab seperateddivorced_ab ageteen_ab ///
	agetwenty_ab agethirty_ab ageforty_ab, by(year)

* Save RIDOH abortion numbers by demo group for percent change p-value  
save ../temp/ridoh_numerator.dta, replace

merge 1:1 year using ../temp/rhode_island_pop.dta, nogen // matching it back to rhode island pop 

foreach var in white black other education_1to11 education_diploma ///
	education_somecollege education_college unmarried married seperateddivorced ///
	ageteen agetwenty agethirty ageforty {
	
	foreach stub in c ll ul {
		gen share_`var'_`stub' = round(`var'_ab/`var'_pop_`stub',.001)*100 // here I am computing shares
	}
}
keep year share*

export excel using ../output/table_2.xlsx, replace firstrow(variables) //output into an excel table


** TABLE 3

/*calculating RI population age 15-44

keep if statefip == 44
keep if sex == 2
keep if age >=15 & age<=44
gen count = 1
collapse (sum) count [fweight=perwt], by(year)
br

*doing the actual abortion rate calculations as number of abortions/RI population
display (3549/210695)*1000 // abortion rate 2012
display (3251/208455)*1000 // abortion rate 2013
display (2990/210045)*1000 // abortion rate 2014
display (2649/211324)*1000 // abortion rate 2015
display (2479/209400)*1000 // abortion rate 2016

*/
