# Association between vaccination rates and severe COVID-19 health outcomes in the United States: a population-level statistical analysis 
### The paper can be found here: (https://www.medrxiv.org/content/10.1101/2023.06.14.23291388v1).
## Summary
### Background

Population-level vaccine efficacy is a critical component of understanding COVID-19 risk, informing public health policy, and mitigating disease impacts. Unlike individual-level clinical trials, population-level analysis characterizes how well vaccines worked in the face of real-world challenges like emerging variants, differing mobility patterns, and policy changes.

### Methods
We analyzed the association between vaccination rates and COVID-19 severity for 48 states in the U.S. using Generalized Additive Models (GAMs). We controlled for dynamic factors such as testing, purpose-specific travel behaviors, underlying population immunity, and policy, and critical static factors such as comorbidities, vulnerability, race, and state healthcare expenditures. In addition, We used SARS-CoV-2 genomic surveillance data to model the different COVID-19 variant-driven waves separately and evaluate if there is a changing role of the potential drivers of severity over time and across waves. 
 
### Findings
Our study revealed a strong and statistically significant negative association between vaccine uptake and COVID-19 severity across each variant wave. The effect of vaccination against severe COVID-19 disease does not change across waves. Results also showed that booster shots offered additional protection against severe diseases during the Omicron wave. Additionally, higher underlying population immunity based on previous infection rates are shown to be associated with reduced COVID-19 severity. Full-service restaurant visits are associated with increased COVID-19 severity for the pre-Delta and Delta waves, while office of physician visits are associated with increased COVID-19 severity for the Omicron wave. Moreover, the states with higher government policy index scores have lower COVID-19 severity. Regarding static variables, the social vulnerability index, and the proportion of adults at high risk exhibit positive associations with COVID-19 severity. In contrast, Medicaid spending per person exhibits a negative association with COVID-19 severity.

### Interpretation
Despite the emergence of new variants, vaccines remain highly effective at reducing severe outcomes of COVID-19. Therefore, given the ongoing threat posed by COVID-19, vaccines remain a critical line of defense for protecting the public and preventing burden on the healthcare systems. 


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

## BibTeX
```latex
@article{du2023association,
  title={Association between vaccination rates and severe COVID-19 health outcomes in the United States: a population-level statistical analysis},
  author={Du, Hongru and Saiyed, Samee and Gardner, Lauren Marie},
  journal={medRxiv},
  pages={2023--06},
  year={2023},
  publisher={Cold Spring Harbor Laboratory Press}
}
```
