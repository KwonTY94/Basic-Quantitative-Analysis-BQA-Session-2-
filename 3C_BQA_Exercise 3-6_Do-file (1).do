***************************************
************* BQA WEEK 2 **************
************ EXERCISES 3-6 ************
***************************************

 use u:\BQA\BQA_Lab1.dta, clear

**************************************************************************
** 3. CORRELATION COEFFICIENTS
**************************************************************************

/* generating new variables and re-coding missing values*/
 
  gen     ppltrst2 = ppltrst					// generate a new variable
  replace ppltrst2 = . if ppltrst2 >= 11		// recode coded missing values to system missing values
  lab val ppltrst2   ppltrst					// apply value labels
  
  gen     trstprl2 = trstprl
  replace trstprl2 = . if trstprl2 >= 11
  lab val trstprl2   trstprl
  
  gen     trstlgl2 = trstlgl
  replace trstlgl2 = . if trstlgl2 >= 11
  lab val trstlgl2   trstlgl
  
  gen     trstplc2 = trstplc
  replace trstplc2 = . if trstplc2 >= 11
  lab val trstplc2   trstplc
  
  gen     trstplt2 = trstplt
  replace trstplt2 = . if trstplt2 >= 11
  lab val trstplt2   trstplt 
  
  gen     trstprt2 = trstprt
  replace trstprt2 = . if trstprt2 >= 11
  lab val trstprt2   trstprt
  
  gen     trstep2  = trstep
  replace trstep2  = . if trstep2 >= 11
  lab val trstep2    trstep
  
  gen     trstun2  = trstun
  replace trstun2  = . if trstun2 >= 11
  lab val trstun2    trstun
  

/*
** In case you are interested: Stata is also an extremely powerful programming language
** We could have written the above using only five lines of code, via a loop routine
** This whole section is commented out, but feel free to try it out 
  
  foreach j of varlist ppltrst trstprl trstlgl trstplc trstplt trstprt trstep trstun {
     capture drop `j'2									// drops the variable, just in case we created it already and forgot about it
	 gen          `j'2 = `j'
	 replace      `j'2 = . if `j'2 >= 11
	 lab val      `j'2   `j'
	 }
	
*/

** the commands below apply variable labels
** I didn't type the whole thing out - I typed "lookfor trust" and adapted the output

   lab var ppltrst2 "Most people can be trusted or you can't be too careful"
   lab var trstprl2 "Trust in country's parliament"
   lab var trstlgl2 "Trust in the legal system"
   lab var trstplc2 "Trust in the police"
   lab var trstplt2 "Trust in politicians"
   lab var trstprt2 "Trust in political parties"
   lab var trstep2  "Trust in the European Parliament"
   lab var trstun2  "Trust in the United Nations"
 
 
 
******************************************************************
** 3.1 PRODUCING CORRELATION MATRIX
******************************************************************  

      corr ppltrst2 - trstun2          
 	pwcorr ppltrst2 - trstun2, sig 
	

******************************************************************  
** 3.2 FINDING THE SLOPE OF A SCATTERPLOT USING OLS
******************************************************************

  twoway (scatter LS GETBY, mlabel(country)) (lfit LS GETBY)	
  regress LS GETBY
	
******************************************************************
** extension exercise
******************************************************************  	
  gen     ipcrtiv2 = 7 - ipcrtiv if ipcrtiv <= 6			// this reverse-codes all variables
  gen     imprich2 = 7 - imprich if imprich <= 6
  gen     getby    = 5 - hincfel if hincfel <= 4
  
  lab var ipcrtiv2 "Important to think new ideas and being creative"
  lab var imprich2 "Important to be rich, have money and expensive things"
  lab var getby    "Feeling about household income nowadays"
  
    corr ipcrtiv2 imprich2 LifeSat getby
  pwcorr ipcrtiv2 imprich2 LifeSat getby, sig
  
******************************************************************
** 3.3 RELATIONSHIP BETWEEN CORRELATION COEFFICIENT AND EFFECT SIZE
******************************************************************   
  
  egen stdGovSat      = std(GovSat) 			// these are the "naive" standardizations
  egen stdprogressive = std(progressive)
  
  corr    GovSat progressive
  regress GovSat progressive
  
  corr    stdGovSat stdprogressive
  regress stdGovSat stdprogressive
  
  egen stdGovSat2      = std(GovSat) 	  if progressive != .		// omitting observations for which the OTHER variable is missing
  egen stdprogressive2 = std(progressive) if GovSat != .
   
  corr    stdGovSat2 stdprogressive2
  regress stdGovSat2 stdprogressive2
  
  
*******************************************************************
** 4.1 ONE-SAMPLE T-TEST
******************************************************************
 
    ttest LifeSat = 59.5
	
  
******************************************************************
** 4.2 TWO-SAMPLE T-TEST
******************************************************************

	ttest LifeSat if female != ., by(female)
	ttest LifeSat if female != . & cntry == "ES", by(female)
	ttest LifeSat if female != . & cntry == "GB", by(female)
  
  ttest progressive, by(female)
  ttest progressive, by(female)
  bysort country: ttest progressive, by(ed_d)
  bysort country: ttest progressive, by(ed_d)

  
******************************************************************
** 5. ANOVA
******************************************************************  
  
  gen nadults2 = nadults if nadults >= 1 & nadults <= 6  
  
  oneway LifeSat nadults2, tabulate
  pwmean LifeSat, over(nadults2)

  
******************************************************************
** 6. OLS REGRESSION
******************************************************************
 
  regress LifeSat i.nadults2
  test 4.nadults2=5.nadults2
  