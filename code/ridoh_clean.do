clear all
set more off
cd "/Users/isabelblalock/Desktop/stata thesis/code"

* clean data
import excel "../data/stata data_2012 - 2016 itops.xls", sheet("2012") firstrow clear
save "../temp/2012_itops", replace

foreach year of numlist 2013(1)2016 {
import excel "../data/`year' ITOPs.xlsx", sheet("Sheet1") firstrow clear
save "../temp/`year'_itops", replace
}

foreach year of numlist 2012(1)2015 {
use "../temp/`year'_itops", clear

gen procedure=. 
replace procedure=1 if Procedure=="A" 
replace procedure=2 if Procedure=="B"
replace procedure=3 if Procedure=="C"
replace procedure=4 if Procedure=="E"
replace procedure=5 if Procedure=="G"
replace procedure=. if Procedure=="X"
label define procedurelabel 1 "1.vacuum aspiration" 2 "2.medical" 3 "3.D&E" 4 "4.D&C" 5 "5.other" 
label value procedure procedurelabel 
tab procedure

gen addprocedure=. 
replace addprocedure=1 if AddProcedure=="B" 
replace addprocedure=2 if AddProcedure=="A" 
replace addprocedure=3 if AddProcedure=="C" 
replace addprocedure=4 if AddProcedure=="X"
replace addprocedure=5 if AddProcedure=="Z"
label define addprocedurelabel 1 "1.medical medications" 2 "2.vacuum aspiration" 3 "3.D&E" 4 "4.unkown" 5 "5.none" 
label value addprocedure addprocedurelabel 

gen complications=. 
replace complications=1 if Complications=="Z"
replace complications=2 if Complications=="A"
replace complications=3 if Complications=="B"
replace complications=4 if Complications=="C" 
replace complications=5 if Complications=="D" 
replace complications=6 if Complications=="G"
replace complications=7 if Complications=="H" 
replace complications=8 if Complications=="X" // need to email RIDOH - H is not in the codebook

gen age_n = real(Age) 
gen womanage=.
replace womanage=1 if age_n<=19
replace womanage=2 if age_n>19 & age_n<30
replace womanage=3 if age_n>=30 & age_n<40
replace womanage=4 if age_n>=40 & age_n<49
label define womanagelabel 1 "1.teens" 2 "2.20s" 3 "3.30s" 4 "4.40s" 
label value womanage womanagelabel 

gen race_n = real(Race) 
gen race=.
replace race=1 if race_n==1 
replace race=2 if race_n==2 
replace race=4 if race_n==0 
replace race=3 if race_n==3 
replace race=4 if race_n==4 
replace race=4 if race_n==5
replace race=7 if race_n==7 | race_n==8 | race_n==6 
replace race=. if race_n==9
label define racelabel 1 "1.White" 2 "2.Black" 3 "3.American Indian" 4 "4.Asian" 7 "5.Other" 
label value race racelabel 


gen education_n= real(Education) 
gen education=. 
replace education=1 if education_n<12 
replace education=2 if education_n==12 
replace education=3 if education_n==13 | education_n==14 | education_n==15 
replace education=4 if education_n==16 
replace education=5 if education_n==17 
replace education=. if education_n==99
label define educationlabel 1 "1.<12 yrs" 2 "2.12 yrs" 3 "3.some college" 4 "4. 4 yrs college" 5 "5.5+ yrs college" 
label value education educationlabel 

gen maritalstatus= real(MaritalStatus)
gen married=. 
replace married=1 if maritalstatus==1
replace married=2 if maritalstatus==2 
replace married=3 if maritalstatus==3 
replace married=4 if maritalstatus==4 
replace married=5 if maritalstatus==5
label define marriedlabel 1 "1.never married" 2 "2.married" 3 "3.widowed" 4 "4.divorced" 5 "5.separated" 
label value married marriedlabel

gen gestweek_n= real(GestWeek)
gen gestweek= gestweek_n
replace gestweek=. if gestweek_n==99
gen trimesters=. 
replace trimesters=2 if gestweek<27
replace trimesters=1 if gestweek<13
label define trimesterslabel 1 "1.1st trimester" 2 "2.2nd trimester" 
label value trimesters trimesterslabel 

gen previnducedterm_n= real(PrevInducedTerm)
gen previnducedterm= previnducedterm_n 
replace previnducedterm=. if previnducedterm_n==77 | previnducedterm_n==99
gen previousinducedabortion= previnducedterm_n 
replace previousinducedabortion=3 if previnducedterm_n>2 & previnducedterm_n<23
replace previousinducedabortion=. if previnducedterm_n==77 | previnducedterm_n==99
label define previousinducedabortionlabel 0 "0" 1 "1" 2 "2" 3 "3 or more" 
label value previousinducedabortion previousinducedabortionlabel 

gen pbnl_n= real(PBNL) 
gen pbnl= pbnl_n
replace pbnl=. if pbnl_n==77 | pbnl_n==99 

gen pbnd_n= real(PBND)
gen pbnd= pbnd_n
replace pbnd=. if pbnd_n==77 | pbnd_n==99 

gen lasttermstatus_n= real(LastTerminationStatus) 
gen lastterm= lasttermstatus
replace lastterm=. if lasttermstatus==9 
replace lastterm=3 if lastterm==0 
label define lasttermlabel 1 "1.spontaneous" 2 "2.induced" 3 "3.none" 
label value lastterm lasttermlabel

gen prevsponterm_n= real(PrevSpontaneousTerm) 
gen prevsponterm= prevsponterm_n
replace prevsponterm=. if prevsponterm_n==77 | prevsponterm_n==99
replace prevsponterm=2 if prevsponterm_n>1 & prevsponterm_n<23
label define prevspontermlabel 0 "0" 1 "1" 2 "2 or more" 
label value prevsponterm prevspontermlabel 

keep procedure addprocedure complications womanage race education married gestweek trimesters previnducedterm pbnl pbnd lastterm prevsponterm
save "../temp/`year'_itops_cleaned", replace
}

* clean 2016
use "../temp/2016_itops", clear

gen procedure=. 
replace procedure=1 if Procedure=="A" 
replace procedure=2 if Procedure=="B"
replace procedure=3 if Procedure=="C"
replace procedure=4 if Procedure=="E"
replace procedure=5 if Procedure=="G"
replace procedure=. if Procedure=="X"
label define procedurelabel 1 "1.vacuum aspiration" 2 "2.medical" 3 "3.D&E" 4 "4.D&C" 5 "5.other" 
label value procedure procedurelabel 

gen addprocedure=. 
replace addprocedure=1 if AddProcedure=="B" 
replace addprocedure=2 if AddProcedure=="A" 
replace addprocedure=3 if AddProcedure=="C" 
replace addprocedure=4 if AddProcedure=="X"
replace addprocedure=5 if AddProcedure=="Z"
label define addprocedurelabel 1 "1.medical medications" 2 "2.vacuum aspiration" 3 "3.D&E" 4 "4.unkown" 5 "5.none" 
label value addprocedure addprocedurelabel 

gen complications=. 
replace complications=1 if Complications=="Z"
replace complications=2 if Complications=="A"
replace complications=3 if Complications=="B"
replace complications=4 if Complications=="C" 
replace complications=5 if Complications=="D" 
replace complications=6 if Complications=="G"
replace complications=7 if Complications=="H" 
replace complications=8 if Complications=="X" // need to email RIDOH - H is not in the codebook


gen womanage=.
replace womanage=1 if Age<=19
replace womanage=2 if Age>19 & Age<30
replace womanage=3 if Age>=30 & Age<40
replace womanage=4 if Age>=40 & Age<49
label define womanagelabel 1 "1.teens" 2 "2.20s" 3 "3.30s" 4 "4.40s" 
label value womanage womanagelabel 

gen race_n = Race
gen race=.
replace race=1 if race_n==1 
replace race=2 if race_n==2 
replace race=4 if race_n==0 
replace race=3 if race_n==3 
replace race=4 if race_n==4 
replace race=4 if race_n==5
replace race=7 if race_n==7 | race_n==8 | race_n==6 
replace race=. if race_n==9
label define racelabel 1 "1.White" 2 "2.Black" 3 "3.American Indian" 4 "4.Asian" 7 "5.Other" 
label value race racelabel 

gen education_n = Education
gen education=. 
replace education=1 if education_n<12 
replace education=2 if education_n==12 
replace education=3 if education_n==13 | education_n==14 | education_n==15 
replace education=4 if education_n==16 
replace education=5 if education_n==17 
replace education=. if education_n==99
label define educationlabel 1 "1.<12 yrs" 2 "2.12 yrs" 3 "3.some college" 4 "4. 4 yrs college" 5 "5.5+ yrs college" 
label value education educationlabel 

gen married=MaritalStatus
label define marriedlabel 1 "1.never married" 2 "2.married" 3 "3.widowed" 4 "4.divorced" 5 "5.separated" 
label value married marriedlabel

gen gestweek= GestWeek
replace gestweek=. if GestWeek==99
gen trimesters=. 
replace trimesters=2 if gestweek<27
replace trimesters=1 if gestweek<13
label define trimesterslabel 1 "1.1st trimester" 2 "2.2nd trimester" 
label value trimesters trimesterslabel 

gen previnducedterm_n = PrevInducedTerm
gen previnducedterm= previnducedterm_n 
replace previnducedterm=. if previnducedterm_n==77 | previnducedterm_n==99
gen previousinducedabortion= previnducedterm_n 
replace previousinducedabortion=3 if previnducedterm_n>2 & previnducedterm_n<23
replace previousinducedabortion=. if previnducedterm_n==77 | previnducedterm_n==99
label define previousinducedabortionlabel 0 "0" 1 "1" 2 "2" 3 "3 or more" 
label value previousinducedabortion previousinducedabortionlabel 

gen pbnl_n = PBNL
gen pbnl= pbnl_n
replace pbnl=. if pbnl_n==77 | pbnl_n==99 

gen pbnd_n= PBND
gen pbnd= pbnd_n
replace pbnd=. if pbnd_n==77 | pbnd_n==99 

gen lastterm= LastTerminationStatus
replace lastterm=. if LastTerminationStatus==9 
replace lastterm=3 if lastterm==0 
label define lasttermlabel 1 "1.spontaneous" 2 "2.induced" 3 "3.none" 
label value lastterm lasttermlabel
 
gen prevsponterm_n = PrevSpontaneousTerm
gen prevsponterm = .
replace prevsponterm=. if prevsponterm_n==77 | prevsponterm_n==99
replace prevsponterm=2 if prevsponterm_n>1 & prevsponterm_n<23
label define prevspontermlabel 0 "0" 1 "1" 2 "2 or more" 
label value prevsponterm prevspontermlabel 

keep procedure addprocedure complications womanage race education married gestweek trimesters previnducedterm pbnl pbnd lastterm prevsponterm
save "../temp/2016_itops_cleaned", replace

* append
use "../temp/2012_itops_cleaned", clear
gen year = 2012

foreach year of numlist 2013(1)2016 {
append using "../temp/`year'_itops_cleaned"
replace year = `year' if year == .
}

save "../temp/ridoh_panel", replace
