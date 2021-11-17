***********************************
********** EXERCISE 2 *************
**** CROSS TABS & SCATTERPLOTS ****
***********************************

** 2.1 CROSSTABULATIONS 

   tab MARSTAT LONELY				// to see what happens when you switch the order of variables
   tab LONELY  MARSTAT

   tab MARSTAT LONELY				// experimenting with the ,row and ,nofreq options
   tab MARSTAT LONELY, row
   tab MARSTAT LONELY, nof
   tab MARSTAT LONELY, row nof

   
** 2.2 CHI-SQUARE STATISTIC
   tab MARSTAT LONELY, row nof chi 						// the full sample
   tab MARSTAT LONELY if AGE >= 70, row nof chi			// those 70 and over
   tab MARSTAT LONELY if AGE <  22, row nof chi			// those under age 22

   
** 2.3 ROW OR COLUMNS PERCENTAGES

/* left-right political ideation and acceptance of same-sex relationships */
   
   tab LRSCALE2 FREEHMS, row nof						// or tab FREEHMS LRSCALE2, col nof  - ROWS 1 and 4 of table
   tab LRSCALE2 FREEHMS, col nof						// or tab FREEHMS LRSCALE2, row nof  - ROWS 2 and 3 of table

   
** 2.4 SORTING TABULATIONS BY COUNTRY

/* to look at countries separately, including chi-squared statistics */
   bysort COUNTRY: tab FREEHMS LRSCALE2, col nof chi

   
** 2.5 SCATTERPLOTS
   scatter GovSat AGE									// observe the beehive
   
   scatter IMPRICH   IMPCREATE							// in any of these, you can add the option ,mlabel(COUNTRY) to get labels
   scatter IMPRICH   LS
   scatter IMPRICH   GETBY
   scatter IMPCREATE LS
   scatter IMPCREATE GETBY
   scatter GETBY     LS		
   
/* to create graphs in different windows */
   scatter IMPRICH   IMPCREATE, name(scatter1, replace)						
   scatter IMPRICH   LS, 		name(scatter2, replace)
   scatter IMPRICH   GETBY, 	name(scatter3, replace)
   scatter IMPCREATE LS, 		name(scatter4, replace)
   scatter IMPCREATE GETBY, 	name(scatter5, replace)
   scatter GETBY     LS, 		name(scatter6, replace)	
   scatter GETBY     LS, 		name(scatter7, replace)

   
** 2.6 TWOWAY SCATTERPLOTS

   twoway (scatter IMPRICH IMPCREATE, mlabel(country)) (lfit IMPRICH IMPCREATE)		// to include a line of best fit
   twoway (lfit IMPRICH IMPCREATE)													// gives you ONLY the line of best fit
   twoway (qfit IMPRICH IMPCREATE)													// gives you a curved line of best fit (quadratic function)
   
   twoway (lfitci IMPRICH IMPCREATE)												// adds a confidence interval to the line of best fit
   
   twoway (qfitci LS GETBY)(scatter LS GETBY, mlabel(country)) 						// includes the scatter plot and a quadratic line of 
																					// best fit, including confidence intervals
																					// put the qfitci section first, in order to be able to see the labels
																					// try it the other way to see how the labels are obscured by the CI
** finally, let's address that beehive problem
** this is a great example of a curved relationship 
** which would be totally mis-specified by a straight line

   twoway lfitci GovSat AGE															// (straight) line of best fit, withCIs																			
   twoway qfitci GovSat AGE															// (quadratic) line of best fit, with CIs
   twoway (lfitci GovSat AGE) (qfitci GovSat AGE)									// both plotted on the same graph		
   