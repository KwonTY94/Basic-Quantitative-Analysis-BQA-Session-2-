**************************************
***** STATA for BQA - EXERCISE 1 *****
**************************************


** 1.3 LABELS IN STATA (EXTRA)

/* Example recode of variable pplfair 'people try to take advantage...*/

	recode pplfair 0 1 2 3 4=1 5=2 6 7 8 9 10=3 77 88 99=. , gen(pplf)

/* Quotation marks tells stata we will be using text, 
and/or not to consider a space as the end of a command*/

	label variable pplf "People try to take advantage or try to be fair"

/* first we must define the label before assinging it to a variable*/

	label define pplf_fair 1"Try to take advantage" 2"Neither" 3"Try to be fair"

/* We can then assign that label to the variable*/

	label value pplf pplf_fair

/* Existing labels can be modified with the help of options: 'add' can be used
to label values that have no label attached; 'modify' as to be used if existing
 labels are to be changed. It includes add; in other words, you can modify 
 existing labels and at the same time add new ones. */

	label define pplf_fair 1"Take advantage" 2"Neither" 3"Fair", modify

/*Dropping value labels
A value label attached to a particular variable can be removed with the 
help of the dot. Look closely at the end of the following example – it 
terminates with a dot:*/

	label values pplf .

/*On the other hand, you may remove a variable label from the data set 
with the command*/

	label drop pplf_fair

/* It is possible to undertake all of these tasks in one line of code:
(note the command /// instructs Stata to read the second line of code*/

	recode pplfair (min/3=1 "Take advantage") (4/6=2 "Neither") ///
	7/10=3 "Fair") (77 88 99= .), generate (pplf2) label (pplf2_lbl)

	list pplf2 in 1/100, noobs
	list pplf2 in 1/100, noobs nolabel

/* One very important note:  These labels are assigned to the data that 
is currently in memory.  To make these changes permanent, you need to
save the data.  When you save the data, all of the labels (data labels, 
variable labels, value labels) will be saved with the data file.*/	
	
	
*******************************************************************************
	
** 1.4 GENERATING VARIABLES

/* the following will produce the variable dom2 for the domicil exercise in FiAS*/

	recode domicil (1 2=1) (3=2) (4 5=3) (7/9 = .), gen (dom2) 
	
/* or */
	recode domicil 1 2=1 3=2 4 5=3 7 8 9=., gen (dom2)

/* label the variable */
	label variable dom2 "Domicile, respondent's description"

/* define the label before assinging it to a variable*/
	label define dom2 1 "A big city, including suburbs or outskirts of a big city"
	2 "A town or a small city" 3 "A country village, or a farm or home in the countryside"

/* We can then assign that label to the variable*/
	label value dom2 dom2
	

*******************************************************************************

** 1.7 COMBINING VARIABLES TO CREATE A NEW VARIABLE

*Check variables*
tab happy
label list happy
tab chldhm
label list chldhm

*Remove missing values*
gen happy2 = happy
replace happy2 =. if happy2 >=77
gen chldhm2 = chldhm
replace chldhm2 =. if chldhm==9

*Compute happy parent*
capture drop happyparent
gen happyparent = .

** Option one 
replace happyparent =0 if happy2 <=8 
replace happyparent =0 if chldhm2==2
replace happyparent =1 if (happy2==9 | happy==10) & chldhm2==1

*Check happyparent*
tab happyparent chldhm2, m
tab happyparent happy2, m

