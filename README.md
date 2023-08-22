# Association between vaccination rates and severe COVID-19 health outcomes in the United States: a population-level statistical analysis 
## Summary
### Background

Population-level vaccine efficacy is a critical component of understanding COVID-19 risk, informing public health policy, and mitigating disease impacts. Unlike individual-level clinical trials, population-level analysis characterizes how well vaccines worked in the face of real-world challenges like emerging variants, differing mobility patterns, and policy changes.

### Methods
In this study, we analyze the association between time-dependent vaccination rates and COVID-19 health outcomes for 48 U.S. states. We primarily focus on case-hospitalization risk (CHR) as the outcome of interest, using it as a population-level proxy for disease burden on healthcare systems. Performing the analysis using Generalized Additive Models (GAMs) allowed us to incorporate real-world nonlinearities and control for critical dynamic (time-changing) and static (temporally constant) factors. Dynamic factors include testing rates, activity-related engagement levels in the population, underlying population immunity, and policy. Static factors incorporate comorbidities, social vulnerability, race, and state healthcare expenditures. We used SARS-CoV-2 genomic surveillance data to model the different COVID-19 variant-driven waves separately, and evaluate if there is a changing role of the potential drivers of health outcomes across waves. 
### Findings
Our study revealed a strong and statistically significant negative association between vaccine uptake and COVID-19 CHR across each variant wave, with boosters providing additional protection during the Omicron wave. Higher underlying population immunity is shown to be associated with reduced COVID-19 CHR. Additionally, more stringent government policies are generally associated with decreased CHR. However, the impact of activity-related engagement levels on COVID-19 health outcomes varied across different waves. Regarding static variables, the social vulnerability index consistently exhibits positive associations with CHR, while Medicaid spending per person consistently shows a negative association. However, the impacts of other static factors vary in magnitude and significance across different waves. 


### Interpretation
This study concludes that despite the emergence of new variants, vaccines remain highly correlated with reduced COVID-19 harm. Therefore, given the ongoing threat posed by COVID-19, vaccines remain a critical line of defense for protecting the public and reducing the burden on healthcare systems.
. 


## Data
### Processed data
* `CHR_input.csv`: all data used for model relative case-hospitalization risk.
* `CIR_input.csv`: all data used for model relative reported case incidence rate.
* `CHR_RP_lag_range.csv`: data used for sensitivity analysis on previous infection variables.

### Raw data
* `State_population.csv`: US state population data, source: https://www.census.gov/data/datasets/time-series/demo/popest/2020s-state-detail.html.
* `static_variable.csv`: all static variables used in the model.
* `weekly_activity_level.pkl`: weekly activity-related engagement levels. This data generates from Safegraph's weekly patterns dataset. The raw data should request from [Safegraph](https://www.safegraph.com/).
* `age_US_state.csv`: US state-level population by age group, source: https://www.census.gov/data/datasets/time-series/demo/popest/2020s-state-detail.html.
* `Weekly_cases.pkl`: US state-level weekly confirmed cases, source: https://github.com/CSSEGISandData/COVID-19.
* `Weekly_genomic.pkl`: generated from COVID-19 sequencing data, the raw data were downloaded from [GISAID](https://gisaid.org/).
* `Weekly_hospitalized.pkl`: US state-level hospitalized cases, source: https://covid.cdc.gov/covid-data-tracker/#datatracker-home.
* `Weekly_policy.pkl`: US state-level government response index, source: https://github.com/OxCGRT/covid-policy-tracker. 
* `Weekly_testing.pkl`: US state-level testing rate: source: https://github.com/govex/COVID-19/tree/master/data_tables/testing_data.
* `Weekly_vaccination.pkl`: US state-level cumulative vaccination data, source: https://covid.cdc.gov/covid-data-tracker/#datatracker-home.
* `Weekly_previous_infection.pkl`: generate from https://github.com/CSSEGISandData/COVID-19.

## Code
* `CHR_model.R`: GAMS fit to case-hospitalization risk.
* `CIR_model.R`: GAMS fit to reported case incidence rate.
* `Create_input_data_CHR.ipynb`: Code for generating `CHR_input.csv`.
* `Create_input_data_CIR.ipynb`: Code for generating `CIR_input.csv`.
* `previous_infection_sensitivity_analysis.R`: Sensitivity analysis on previous infection variables.
* `Previous_infection_sensitivity_analysis.ipynb`: Plotting sensitivity analysis results of previous infection variables.
* `interaction_ALE_CHR.ipynb`: Plotting results from Omicron-Booster-RCHR.
* `interaction_ALE_CIR.ipynb`: Plotting results from Omicron-Booster-RCIR.
* 'plot_dynamic_var_before_after_transformation.ipynb': Plotting dynamic variables before and after variables transformation.
* `visualize_3_model_ALE_CHR.ipynb`: Plotting results from RCHR models.
* `visualize_3_model_ALE_CIR.ipynb`: Plotting results from RCIR models.

## Contributors
Hongru Du, Samee Saiyed, and Lauren M. Gardner

