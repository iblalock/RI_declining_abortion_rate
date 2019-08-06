clear all
set more off
cd "/Users/isabelblalock/Desktop/stata thesis/code"

cap: mkdir "../temp/"
cap: mkdir "../output/"

do ridoh_clean.do // puts together rhode island department of health data
do ipums_clean.do // 
do ipums_estimates.do // creates the denominator for table 2
do analysis.do // analysis for table 2 and compute abortion rates for table 3
do pvalues_percent_change.do // compute p-values for relative change from 2012 to 2016 of table 2  
