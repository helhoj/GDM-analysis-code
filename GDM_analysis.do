********************************************************************************
* Analysis code for the study "Metabolic status in mothers with gestational diabetes mellitus and the effects on fetal and neonatal outcomes – a cohort study"
* This do-file derives selected study variables and reproduces the descriptive, main, and sensitivity analyses reported in the manuscript.
* The workflow is organized into four sections:
* (1) Data preparation
* (2) Derived variables
* (3) Descriptive analyses
* (4) Main analyses
* (5) Sensitivity analyses
* Version: 1.0.0
* Date: 2026-04-12
********************************************************************************

* Set working directory to the repository folder before running this do-file.
// cd "[insert working directory]"

* Load input dataset. The example code below assumes that the synthetic demo dataset is stored in the same folder.
// use "synthetic_demo_data_international.dta", clear

********************************************************************************
* (1) Data preparation
********************************************************************************
* This section harmonizes variable names, recodes categorical variables, and applies variable labels and value labels to create an analysis-ready dataset.
* Recode binary variables should be coded to 0 = No, 1 = Yes

* Variable labels
*****************
label variable age "Maternal age"
label variable parity "Parity"
label variable pre_bmi "Pre-pregnancy BMI"
label variable ethnicity "Ethnicity"
label variable education "Education"
label variable hyperten "Gestational hypertension or preeclampsia"
label variable gwg "Gestational weight gain"
label variable gdm_diag "Gestational age at gestational diabetes mellitus diagnosis"
label variable ogtt_preg_value "Oral glucose tolerance test 2-hour value during pregnancy (GDM-diagnostic)"
label variable insulin_treat "Insulin treatment of gestational diabetes mellitus"
label variable ga_insulin_start "Gestational age at insulin start"
label variable insulindosis_kg "Maximum insulin dose per kg body weight per day"
label variable ga_visit_week_total "Gestational age at pregnancy visit with blood sampling"
label variable cholesterol "Total cholesterol"
label variable triglyceride "Triglyceride"
label variable ldl "Low-density lipoprotein cholesterol"
label variable hba1c "HbA1c"
label variable birth_ga_weeks_total "Gestational age at birth"
label variable bw "Birthweight"
label variable sex "Female sex"
label variable birth_del "Method of delivery"
label variable shoulder_dys "Shoulder dystocia"
label variable bw_z "Birthweight z-score"
label variable apg5 "Apgar score at 5 minutes"
label variable hypogly "Neonatal hypoglycemia"
label variable jaundice "Jaundice requiring phototherapy"
label variable rds "Respiratory distress syndrome"
label variable nicu_hours "Duration of neonatal intensive care unit admission"
label variable nicu_adm "Neonatal intensive care unit admission"

 *Value labels
**************
label define parity_lbl ///
    0 "Primipara" ///
    1 "Multipara", replace
label values parity parity_lbl

label define ethnicity_lbl ///
    0 "Europe" ///
    1 "Asia" ///
    2 "Middle East" ///
    3 "Other", replace
label values ethnicity ethnicity_lbl

label define education_lbl ///
    0 "Elementary school" ///
    1 "Short-term education" ///
    2 "Intermediate higher education" ///
    3 "Long higher education" ///
    4 "Other (including foreign education)", replace
label values education education_lbl

label define hyperten_lbl ///
    0 "No" ///
    1 "Gestational hypertension or PE", replace
label values hyperten hyperten_lbl

label define insulin_lbl ///
    0 "Diet/no insulin" ///
    1 "Insulin", replace
label values insulin_treat insulin_lbl

label define sex_lbl ///
    0 "Male" ///
    1 "Female", replace
label values sex sex_lbl

label define delivery_lbl ///
    0 "Vaginal" ///
    1 "Emergency caesarean section" ///
    2 "Elective caesarean section" ///
    3 "Vacuum", replace
label values birth_del delivery_lbl

label define rds_lbl ///
    0 "No" ///
    1 "RDS", replace
label values rds rds_lbl

label define jaundice_lbl ///
    0 "No" ///
    1 "Jaundice", replace
label values jaundice jaundice_lbl 

label define hypogly_lbl ///
    0 "No" ///
    1 "Neonatal hypoglycemia", replace
label values hypogly hypogly_lbl 

label define nicu_adm_lbl ///
    0 "No" ///
    1 "NICU admission", replace
label values nicu_adm nicu_adm_lbl 

label define shoulder_dys_lbl ///
    0 "No" ///
    1 "Shoulder dystocia", replace
label values shoulder_dys shoulder_dys_lbl

********************************************************************************
* (2) Derived variables
********************************************************************************
* This section defines derived maternal and neonatal variables used in the descriptive, regression, and sensitivity analyses.

* LGA
gen lga = .
replace lga = 1 if bw_z >= 1.282 & bw_z < .
replace lga = 0 if bw_z < 1.282
label define lga_lbl 0 "Not LGA" 1 "LGA"
label values lga lga_lbl
label variable lga "Large for gestational age (birthweight z-score ≥1.282)"

* SGA
gen sga = .
replace sga = 1 if bw_z <= -1.28
replace sga = 0 if bw_z > -1.28 & bw_z < .
label define sga_lbl 0 "Not SGA" 1 "SGA"
label values sga sga_lbl
label variable sga "Small for gestational age (birthweight z-score ≤-1.282)"

* NICU admission > 24 h
generate nicu_24 = .
replace nicu_24 = 1 if nicu_hours >= 24 & nicu_hours < .
replace nicu_24 = 0 if nicu_24 == . & nicu_adm == 1
replace nicu_24 = 0 if nicu_24 == . & nicu_adm == 0
label define nicu24_lbl 0 "No" 1 "NICU>24h admission"
label values nicu_24 nicu24_lbl
label variable nicu_24 "Neonatal intensive care unit admission >24 hours"

* Preterm
generate preterm = .
replace preterm = 0 if birth_ga_weeks_total >= 37 & birth_ga_weeks_total < .
replace preterm = 1 if birth_ga_weeks_total < 37
label define preterm_lbl 0 "Term" 1 "Preterm"
label values preterm preterm_lbl
label variable preterm "Preterm birth (<37 completed weeks)"

* Pre-pregnancy BMI categories
generate prebmistatus = .
replace prebmistatus = 0 if pre_bmi < 18.5
replace prebmistatus = 1 if pre_bmi >= 18.5 & pre_bmi < 25
replace prebmistatus = 2 if pre_bmi >= 25 & pre_bmi < 30
replace prebmistatus = 3 if pre_bmi >= 30 & pre_bmi < .
label define prebmi4_lbl ///
    0 "Underweight (BMI <18.5)" ///
    1 "Normal weight (BMI ≥18.5-<25)" ///
    2 "Overweight (BMI ≥25-<30)" ///
    3 "Obese (BMI ≥30)"
label values prebmistatus prebmi4_lbl
label variable prebmistatus "Pre-pregnancy BMI category (4 groups)"

* Underweight and normal weight were combined due to sparse observations in the
* underweight category.
generate prebmistatus2 = prebmistatus
replace prebmistatus2 = 0 if prebmistatus == 1
replace prebmistatus2 = 1 if prebmistatus == 2
replace prebmistatus2 = 2 if prebmistatus == 3
label define prebmi3_lbl ///
    0 "Underweight/normal weight (BMI <25)" ///
    1 "Overweight (BMI ≥25-<30)" ///
    2 "Obese (BMI ≥30)"
label values prebmistatus2 prebmi3_lbl
label variable prebmistatus2 "Pre-pregnancy BMI category (underweight/normal weight combined)"
* `prebmistatus` is used for IOM classification and `prebmistatus2` is used in regression.

* Gestational weight gain (GWG) category according to Institute of Medicine (IOM) recommendations
generate iom = .
replace iom = 1 if ///
    prebmistatus == 0 & gwg >= 12.5 & gwg <= 18 | ///
    prebmistatus == 1 & gwg >= 11.5 & gwg <= 16 | ///
    prebmistatus == 2 & gwg >= 7 & gwg <= 11.5 | ///
    prebmistatus == 3 & gwg >= 5 & gwg <= 9
replace iom = 2 if ///
    prebmistatus == 0 & gwg > 18 & gwg < . | ///
    prebmistatus == 1 & gwg > 16 & gwg < . | ///
    prebmistatus == 2 & gwg > 11.5 & gwg < . | ///
    prebmistatus == 3 & gwg > 9 & gwg < .
replace iom = 3 if ///
    prebmistatus == 0 & gwg < 12.5 | ///
    prebmistatus == 1 & gwg < 11.5 | ///
    prebmistatus == 2 & gwg < 7 | ///
    prebmistatus == 3 & gwg < 5
label define iom_lbl ///
    1 "Within IOM recommendation" ///
    2 "Above IOM recommendation" ///
    3 "Below IOM recommendation"
label values iom iom_lbl
label variable iom "Gestational weight gain category according to IOM recommendations"

* Apgar value at 5 min <7
generate apg5_7 = .
replace apg5_7 = 0 if apg5 > 7 & apg5 < .
replace apg5_7 = 1 if apg5 <= 7
label define apg5_7_lbl 0 "Apgar score >7 at 5 min" 1 "Apgar score ≤7 at 5 min"
label values apg5_7 apg5_7_lbl
label variable apg5_7 "Apgar score at 5 minutes ≤7"

* LDL group
* Categorized at the cohort median (2.8 mmol/L)
gen ldl_group = .
replace ldl_group = 0 if ldl <= 2.8
replace ldl_group = 1 if ldl > 2.8 & ldl < .
label define ldl_group_lbl 0 "LDL-C ≤2.8 mmol/L" 1 "LDL-C >2.8 mmol/L"
label values ldl_group ldl_group_lbl
label variable ldl_group "LDL cholesterol group (median split at 2.8 mmol/L)"

*Emergency caesarean section catagorical variabel
gen c_sec_emergency=.
replace c_sec_emergency=0 if birth_del == 2 | birth_del == 3 | birth_del == 4
replace c_sec_emergency=1 if birth_del == 1
label define c_sec_emergency_lbl 0 "No" 1 "Emergency caesarean section" 
label values c_sec_emergency c_sec_emergency_lbl
label variable c_sec_emergency "Emergency caesarean section"

********************************************************************************
* (3) Descriptive analysis
********************************************************************************
* This section summarizes maternal, obstetric, and neonatal characteristics and
* compares groups defined by GDM treatment.

* Assessment of continuous variable distributions
* Histograms and Q-Q plots were used to assess whether continuous variables were
* approximately normally distributed.
local contvars "age pre_bmi gdm_diag ogtt_preg_value ga_insulin_start insulindosis_kg ga_visit_week_total cholesterol triglyceride ldl hba1c birth_ga_weeks_total bw bw_z"

foreach var of local contvars {
    qnorm `var', name(`var'_qq, replace)
    histogram `var', normal name(`var'_hist, replace)
}

* Variables considered approximately normally distributed included: age,
* pre_bmi, ga_insulin_start, ga_visit_week_total, cholesterol, triglyceride,
* and hba1c.
* Variables considered non-normally distributed included: gdm_diag,
* ogtt_preg_value, insulindosis_kg, and ldl.

* Assessment of continuous variables stratified by GDM treatment
* Distributions of continuous variables were assessed within each treatment group
* (diet vs insulin) using histograms and Q-Q plots.
local contvars "age pre_bmi gdm_diag ogtt_preg_value ga_visit_week_total cholesterol triglyceride ldl hba1c"

foreach var of local contvars {
    histogram `var' if insulin_treat == 0, normal name(`var'_diet_hist, replace)
    qnorm `var' if insulin_treat == 0, name(`var'_diet_qq, replace)

    histogram `var' if insulin_treat == 1, normal name(`var'_insulin_hist, replace)
    qnorm `var' if insulin_treat == 1, name(`var'_insulin_qq, replace)
}

* Maternal characteristics
dtable, ///
title("Maternal characteristics") ///
continuous(age, statistics(mean sd n)) ///
factor(parity, statistics (fvfrequency fvpercent)) ///
continuous(pre_bmi, statistics(mean sd n)) ///
factor(prebmistatus2, statistics (fvfrequency fvpercent)) ///
factor(ethnicity, statistics (fvfrequency fvpercent)) ///
factor(education, statistics (fvfrequency fvpercent)) ///
factor(hyperten, statistics (fvfrequency fvpercent)) ///
factor(iom, statistics (fvfrequency fvpercent)) ///
continuous(gdm_diag, statistics(median nonparam n)) ///
continuous(ogtt_preg_value, statistics(median nonparam n)) ///
factor(insulin_treat, statistics (fvfrequency fvpercent)) ///
continuous(ga_insulin_start, statistics(mean sd n)) ///
continuous(insulindosis_kg, statistics(median nonparam n)) ///
continuous(ga_visit_week_total, statistics(mean sd n)) ///
define (nonparam= p25 p75, delimiter ("-") replace) ///
continuous(cholesterol, statistics(mean sd n)) ///
continuous(triglyceride, statistics(mean sd n)) ///
continuous(ldl, statistics(median nonparam n)) ///
factor(ldl_group, statistics (fvfrequency fvpercent)) ///
continuous(hba1c, statistics(mean sd n)) ///
sformat(`"(%s)"' nonparam) ///
nformat (%10.5g mean sd median p25 p75) ///
export ("table_Maternal_charac", as(docx) replace)

* Characteristics stratified on GDM treatment
* Continuous variables are presented as mean (SD) when approximately normally
* distributed and as median (IQR) when non-normally distributed. Group
* comparisons were performed using two-sample t-tests, Welch's t-tests, or
* rank-sum tests as appropriate. Categorical variables were compared using
* chi-square tests.
dtable, ///
title("Maternal characteristics stratified on GDM treatment") ///
by(insulin_treat, notest totals) ///
continuous(age, statistics(mean sd n)) ///
continuous(pre_bmi, statistics(mean sd n)) ///
factor(prebmistatus2, statistics (fvfrequency fvpercent)) ///
factor(iom, statistics (fvfrequency fvpercent)) ///
continuous(ga_visit_week_total, statistics(mean sd n)) ///
continuous(gdm_diag, statistics(median nonparam n)) ///
continuous(ogtt_preg_value, statistics(median nonparam n)) ///
factor(parity, statistics (fvfrequency fvpercent)) ///
factor(education, statistics (fvfrequency fvpercent)) ///
factor(ethnicity, statistics (fvfrequency fvpercent)) ///
continuous(hba1c, statistics(mean sd n)) ///
continuous(triglyceride, statistics(mean sd n)) ///
continuous(cholesterol, statistics(mean sd n)) ///
continuous(ldl, statistics(median nonparam n)) ///
factor(ldl_group, statistics (fvfrequency fvpercent)) ///
factor(hyperten, statistics (fvfrequency fvpercent)) ///
define (nonparam= p25 p75, delimiter ("-") replace) ///
sformat(`"(%s)"' nonparam) ///
nformat (%6.2g mean sd median p25 p75) ///
export ("table_charac_stratified_GDM_treatment", as(docx) replace)

* Continuous variables: group comparisons
ttest age, by(insulin_treat)
ttest pre_bmi, by(insulin_treat) unequal
ttest ga_visit_week_total, by(insulin_treat)
ranksum gdm_diag, by(insulin_treat)
ranksum ogtt_preg_value, by(insulin_treat)
ttest hba1c, by(insulin_treat) unequal
ttest triglyceride, by(insulin_treat)
ttest cholesterol, by(insulin_treat)
ranksum ldl, by(insulin_treat)

* Categorical variables: group comparisons
tabulate insulin_treat prebmistatus2 if prebmistatus2 != ., chi2
tabulate insulin_treat iom if iom != ., chi2
tabulate insulin_treat parity if parity != ., chi2
tabulate insulin_treat education if education != ., chi2
tabulate insulin_treat ethnicity if ethnicity != ., chi2
tabulate insulin_treat ldl_group if ldl_group != ., chi2
tabulate insulin_treat hyperten if hyperten != ., chi2

* Missings
tabulate insulin_treat if missing(age)
tabulate insulin_treat if missing(parity)
tabulate insulin_treat if missing(prebmistatus2)
tabulate insulin_treat if missing(ethnicity)
tabulate insulin_treat if missing(education)
tabulate insulin_treat if missing(iom)
tabulate insulin_treat if missing(ga_visit_week_total)
tabulate insulin_treat if missing(gdm_diag)
tabulate insulin_treat if missing(ogtt_preg_value)
tabulate insulin_treat if missing(hba1c)
tabulate insulin_treat if missing(triglyceride)
tabulate insulin_treat if missing(cholesterol)
tabulate insulin_treat if missing(ldl)
tabulate insulin_treat if missing(ldl_group)

* Obstetric and perinatal outcomes
dtable, ///
title("Obstetric and neonatal outcomes") ///
continuous(birth_ga_weeks_total, statistics(median nonparam n)) ///
continuous(bw, statistics(mean sd n)) ///
factor(sex, statistics (fvfrequency fvpercent)) ///
factor(birth_del, statistics (fvfrequency fvpercent)) ///
factor(preterm, statistics (fvfrequency fvpercent)) ///
factor(shoulder_dys, statistics (fvfrequency fvpercent)) ///
continuous(bw_z, statistics(mean sd n)) ///
factor(lga, statistics (fvfrequency fvpercent)) ///
factor(sga, statistics (fvfrequency fvpercent)) ///
factor(apg5_7, statistics (fvfrequency fvpercent)) ///
factor(hypogly, statistics (fvfrequency fvpercent)) ///
factor(jaundice, statistics (fvfrequency fvpercent)) ///
factor(rds, statistics (fvfrequency fvpercent)) ///
factor(nicu_24, statistics (fvfrequency fvpercent)) ///
define (nonparam= p25 p75, delimiter ("-") replace) ///
sformat(`"(%s)"' nonparam) ///
nformat (%8.4g mean sd median p25 p75) ///
export ("table_Obstetric_neonatal_outcome", as(docx) replace)

* Outcomes stratified by GDM treatment
dtable, ///
title("Obstetric and neonatal outcome stratified by GDM treatment") ///
by(insulin_treat, notest totals) ///
factor(lga, statistics (fvfrequency fvpercent)) ///
factor(sga, statistics (fvfrequency fvpercent)) ///
factor(hypogly, statistics (fvfrequency fvpercent)) ///
factor(preterm, statistics (fvfrequency fvpercent)) ///
factor(nicu_24, statistics (fvfrequency fvpercent)) ///
factor(jaundice, statistics (fvfrequency fvpercent)) ///
factor(rds, statistics (fvfrequency fvpercent)) ///
factor(apg5_7, statistics (fvfrequency fvpercent)) ///
factor(hyperten, statistics (fvfrequency fvpercent)) ///
factor(shoulder_dys, statistics (fvfrequency fvpercent)) ///
factor(c_sec_emergency, statistics (fvfrequency fvpercent)) ///
define (nonparam= p25 p75, delimiter ("-") replace) ///
sformat(`"(%s)"' nonparam) ///
nformat (%6.2g mean sd median p25 p75) ///
export ("table_Obstetric_neonatal_outcome_stratified_GDMtreatment", as(docx) replace)

* Risk ratios for the outcomes were estimated using the `cs' command.
* For this analysis, outcome variables were coded 1 = event and 0 = no event.
cs lga insulin_treat
cs sga insulin_treat
cs hypogly insulin_treat
cs preterm insulin_treat
cs nicu_adm insulin_treat
cs nicu_24 insulin_treat
cs jaundice insulin_treat
cs rds insulin_treat
cs apg5_7 insulin_treat
cs hyperten insulin_treat
cs shoulder_dys insulin_treat
cs c_sec_emergency insulin_treat

********************************************************************************
* (4) Main analyses
********************************************************************************
* This section reproduces the main logistic and linear regression analyses.

**********************
* Logistic regression
**********************
* Associations between maternal metabolic variables and adverse obstetric outcomes
* were examined using logistic regression models. Model 1 (aOR1) was adjusted
* for maternal age, ethnicity, and parity. Model 2 (aOR2) was additionally
* adjusted for pre-pregnancy BMI.
* Assessment of linearity: For continuous predictors included in logistic
* regression models, the assumption of linearity on the log-odds scale was
* assessed using spline terms and likelihood-ratio tests comparing models with
* and without spline expansions. When no statistically significant evidence of
* non-linearity was found, variables were retained as continuous terms in the
* final models. The assessment is shown for the first model as an example and
* was applied analogously to the subsequent models.
* Outcome counts: LGA = 114, SGA = 60, hypoglycaemia = 67, preterm = 43,
* admission to NICU >24h = 96.
* Selected exposure variables were categorized when analyses indicated that the
* assumption of linearity between the continuous predictor and the log-odds was
* not adequately met.
* Pre-pregnancy BMI: Due to sparse outcome events in the underweight category,
* underweight and normal-weight women were combined in the revised BMI
* categorization (prebmistatus2).
* Gestational weight gain: GWG was categorized according to the Institute of
* Medicine (IOM) criteria.
* LDL cholesterol: LDL was categorized into two groups based on the cohort
* median (2.8 mmol/L).

* Logistic regression: HbA1c
* HbA1c and NICU>24h
* Crude model (cOR)
logistic nicu_24 c.hba1c, or

* Linearity assessment for HbA1c in model
mkspline spl_hba1c = hba1c, cubic
logit nicu_24 c.hba1c spl_hba1c*
est store spl_hba1c_nicu_24_mod
logit nicu_24 c.hba1c
lrtest spl_hba1c_nicu_24_mod

* Adjusted model 2 (aOR2)
logistic nicu_24 c.hba1c c.age i.ethnicity i.parity c.pre_bmi, or

* Linearity assessment for age, HbA1c and pre-pregnancy BMI in model
mkspline spl_age = age, cubic
logit nicu_24 c.hba1c c.age spl_age* i.ethnicity i.parity c.pre_bmi
est store spl_age_nicu_24_mod
logit nicu_24 c.hba1c c.age i.ethnicity i.parity c.pre_bmi
lrtest spl_age_nicu_24_mod

logit nicu_24 c.hba1c spl_hba1c* c.age i.ethnicity i.parity c.pre_bmi
est store spl_hba1c_nicu_24_mod
logit nicu_24 c.hba1c c.age i.ethnicity i.parity c.pre_bmi
lrtest spl_hba1c_nicu_24_mod

mkspline spl_pre_bmi = pre_bmi, cubic
logit nicu_24 c.hba1c c.age i.ethnicity i.parity c.pre_bmi spl_pre_bmi*
est store spl_pre_bmi_nicu_24_mod
logit nicu_24 c.hba1c c.age i.ethnicity i.parity c.pre_bmi
lrtest spl_pre_bmi_nicu_24_mod

* HbA1c and LGA
logistic lga c.hba1c, or
logistic lga c.hba1c c.age i.ethnicity i.parity c.pre_bmi, or

* HbA1c and SGA
logistic sga c.hba1c, or
logistic sga c.hba1c c.age i.ethnicity i.parity c.pre_bmi, or

* HbA1c and neonatal hypoglycemia
logistic hypogly c.hba1c, or
logistic hypogly c.hba1c c.age i.ethnicity i.parity c.pre_bmi, or

* HbA1c and preterm
logistic preterm c.hba1c, or
logistic preterm c.hba1c c.age i.ethnicity i.parity c.pre_bmi, or

* Logistic regression: oral glucose tolerance test (OGTT) 2 hour value
* OGTT and NICU>24h
logistic nicu_24 c.ogtt_preg_value, or
logistic nicu_24 c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi, or

* OGTT and LGA
logistic lga c.ogtt_preg_value, or
logistic lga c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi, or

* OGTT and SGA
logistic sga c.ogtt_preg_value, or
logistic sga c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi, or

* OGTT and neonatal hypoglycemia
logistic hypogly c.ogtt_preg_value, or
logistic hypogly c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi, or

* OGTT and preterm
logistic preterm c.ogtt_preg_value, or
logistic preterm c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi, or

* Logistic regression: pregestational BMI
logistic nicu_24 i.prebmistatus2, or
logistic nicu_24 i.prebmistatus2 c.age i.ethnicity i.parity, or

logistic lga ib0.prebmistatus2, or
logistic lga i.prebmistatus2 c.age i.ethnicity i.parity, or

logistic sga i.prebmistatus2, or
logistic sga i.prebmistatus2 c.age i.ethnicity i.parity, or

logistic hypogly i.prebmistatus2, or
logistic hypogly i.prebmistatus2 c.age i.ethnicity i.parity, or

logistic preterm i.prebmistatus2, or
logistic preterm i.prebmistatus2 c.age i.ethnicity i.parity, or

* Logistic regression: gestational weight gain (GWG)
logistic nicu_24 i.iom, or
logistic nicu_24 i.iom c.age i.ethnicity i.parity, or

logistic lga i.iom, or
logistic lga i.iom c.age i.ethnicity i.parity, or

logistic sga i.iom, or
logistic sga i.iom c.age i.ethnicity i.parity, or

logistic hypogly i.iom, or
logistic hypogly i.iom c.age i.ethnicity i.parity, or

logistic preterm i.iom, or
logistic preterm i.iom c.age i.ethnicity i.parity, or

* Logistic regression: total cholesterol
logistic nicu_24 c.cholesterol, or
logistic nicu_24 c.cholesterol c.age i.ethnicity i.parity c.pre_bmi, or

logistic lga c.cholesterol, or
logistic lga c.cholesterol c.age i.ethnicity i.parity c.pre_bmi, or

logistic sga c.cholesterol, or
logistic sga c.cholesterol c.age i.ethnicity i.parity c.pre_bmi, or

logistic hypogly c.cholesterol, or
logistic hypogly c.cholesterol c.age i.ethnicity i.parity c.pre_bmi, or

logistic preterm c.cholesterol, or
logistic preterm c.cholesterol c.age i.ethnicity i.parity c.pre_bmi, or

* Logistic regression: triglyceride
logistic nicu_24 c.triglyceride, or
logistic nicu_24 c.triglyceride c.age i.ethnicity i.parity c.pre_bmi, or
logistic nicu_24 c.triglyceride if insulin_treat == 0, or
logistic nicu_24 c.triglyceride if insulin_treat == 1, or

logistic lga c.triglyceride, or
logistic lga c.triglyceride c.age i.ethnicity i.parity c.pre_bmi, or

logistic sga c.triglyceride, or
logistic sga c.triglyceride c.age i.ethnicity i.parity c.pre_bmi, or

logistic hypogly c.triglyceride, or
logistic hypogly c.triglyceride c.age i.ethnicity i.parity c.pre_bmi, or

logistic preterm c.triglyceride, or
logistic preterm c.triglyceride c.age i.ethnicity i.parity c.pre_bmi, or
logistic preterm c.triglyceride if insulin_treat == 0, or
logistic preterm c.triglyceride if insulin_treat == 1, or

* Logistic regression: LDL-cholesterol
logistic nicu_24 i.ldl_group, or
logistic nicu_24 i.ldl_group c.age i.ethnicity i.parity c.pre_bmi, or

logistic lga i.ldl_group, or
logistic lga i.ldl_group c.age i.ethnicity i.parity c.pre_bmi, or

logistic sga i.ldl_group, or
logistic sga i.ldl_group c.age i.ethnicity i.parity c.pre_bmi, or

logistic hypogly i.ldl_group, or
logistic hypogly i.ldl_group c.age i.ethnicity i.parity c.pre_bmi, or

logistic preterm i.ldl_group, or
logistic preterm i.ldl_group c.age i.ethnicity i.parity c.pre_bmi, or

********************
* Linear regression
********************
* Associations between maternal metabolic variables and birthweight z-score were
* examined using linear regression models. Model 1 (aBETA1) was adjusted for
* maternal age, ethnicity, and parity. Model 2 (aBETA2) was additionally
* adjusted for pre-pregnancy BMI. Statistical assumptions were assessed before
* the final models were specified, including linearity of continuous predictors,
* approximate normality of residuals, and homoscedasticity. The assessment is
* shown for the first model as an example and was applied analogously to the
* subsequent models.

* Assessment of the linear relationship between BW z-score and age in the adjusted model.
scatter bw_z age

* Birthweight z-score and HbA1c
gen hba1c_5 = hba1c / 5

regress bw_z c.hba1c_5
scatter bw_z hba1c_5, name(hba1c_5, replace)
twoway (scatter bw_z hba1c_5) (lfit bw_z hba1c_5)

predict residual_hba1c_5, residuals
histogram residual_hba1c_5, normal
qnorm residual_hba1c_5

regress bw_z hba1c_5
predict predict_hba1c_5, xb
scatter residual_hba1c_5 predict_hba1c_5

regress bw_z hba1c_5 age i.ethnicity i.parity c.pre_bmi
predict residual_hba1c_5_2, residuals
histogram residual_hba1c_5_2, normal
qnorm residual_hba1c_5_2
predict predict_hba1c_5_2, xb
scatter residual_hba1c_5_2 predict_hba1c_5_2

* Birthweight z-score and OGTT
regress bw_z ogtt_preg_value
regress bw_z ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi

* Birthweight z-score and pregestational BMI
regress bw_z i.prebmistatus2
regress bw_z i.prebmistatus2 c.age i.ethnicity i.parity

* Birthweight z-score and GWG
regress bw_z i.iom
regress bw_z i.iom age i.ethnicity i.parity

* Birthweight z-score and total cholesterol
regress bw_z cholesterol
regress bw_z cholesterol c.age i.ethnicity i.parity c.pre_bmi

* Birthweight z-score and triglycerides
regress bw_z triglyceride
regress bw_z triglyceride c.age i.ethnicity i.parity c.pre_bmi

* Birthweight z-score and LDL cholesterol
regress bw_z i.ldl_group
regress bw_z i.ldl_group age i.ethnicity i.parity c.pre_bmi

********************************************************************************
* (5) Sensitivity analyses
********************************************************************************
* This section contains correlation analyses and sensitivity models with mutual
* adjustment for selected correlated glycemic and lipid variables.

* Correlation analysis between glycemic and lipid parameters
* Correlations between HbA1c and lipid measures: as HbA1c, triglycerides, total
* cholesterol, and LDL-C were approximately normally distributed, Pearson's
* correlation coefficient was used.
scatter hba1c triglyceride
pwcorr triglyceride hba1c, sig

scatter hba1c cholesterol
pwcorr cholesterol hba1c, sig

scatter hba1c ldl
pwcorr ldl hba1c, sig

* Correlations between diagnostic OGTT 2-hour value and lipid measures: as OGTT
* was not normally distributed, Spearman's rank correlation coefficient was used.
scatter ogtt_preg_value triglyceride
spearman triglyceride ogtt_preg_value

scatter ogtt_preg_value cholesterol
spearman cholesterol ogtt_preg_value

scatter ogtt_preg_value ldl
spearman ldl ogtt_preg_value

* Sensitivity analyses
* As a sensitivity analysis, additional models were fitted with mutual
* adjustment for correlated metabolic variables. The same modelling strategy and
* assumption checks as in the primary analyses were applied.

* HbA1c models additionally adjusted for triglycerides
logistic lga c.hba1c c.age i.ethnicity i.parity c.pre_bmi c.triglyceride, or
logistic sga c.hba1c c.age i.ethnicity i.parity c.pre_bmi c.triglyceride, or
logistic hypogly c.hba1c c.age i.ethnicity i.parity c.pre_bmi c.triglyceride, or
logistic preterm c.hba1c c.age i.ethnicity i.parity c.pre_bmi c.triglyceride, or
logistic nicu_24 c.hba1c c.age i.ethnicity i.parity c.pre_bmi c.triglyceride, or

* Triglyceride models additionally adjusted for HbA1c
logistic lga c.triglyceride c.age i.ethnicity i.parity c.pre_bmi c.hba1c, or
logistic sga c.triglyceride c.age i.ethnicity i.parity c.pre_bmi c.hba1c, or
logistic hypogly c.triglyceride c.age i.ethnicity i.parity c.pre_bmi c.hba1c, or
logistic preterm c.triglyceride c.age i.ethnicity i.parity c.pre_bmi c.hba1c, or
logistic nicu_24 c.triglyceride c.age i.ethnicity i.parity c.pre_bmi c.hba1c, or

* OGTT models additionally adjusted for total cholesterol
logistic lga c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi c.cholesterol, or
logistic sga c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi c.cholesterol, or
logistic hypogly c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi c.cholesterol, or
logistic preterm c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi c.cholesterol, or
logistic nicu_24 c.ogtt_preg_value c.age i.ethnicity i.parity c.pre_bmi c.cholesterol, or

* Total cholesterol models additionally adjusted for OGTT
logistic lga c.cholesterol c.age i.ethnicity i.parity c.pre_bmi c.ogtt_preg_value, or
logistic sga c.cholesterol c.age i.ethnicity i.parity c.pre_bmi c.ogtt_preg_value, or
logistic hypogly c.cholesterol c.age i.ethnicity i.parity c.pre_bmi c.ogtt_preg_value, or
logistic preterm c.cholesterol c.age i.ethnicity i.parity c.pre_bmi c.ogtt_preg_value, or
logistic nicu_24 c.cholesterol c.age i.ethnicity i.parity c.pre_bmi c.ogtt_preg_value, or