# Association between vaccination rates and severe COVID-19 health outcomes in the United States: a population-level statistical analysis 
## Summary
### Background

Vaccine development and distribution have been at the forefront of efforts to combat the COVID-19 pandemic. As the vaccines have been widely adopted by the population, uncertainties around their effectiveness resulting from the emergence of new variants and other confounding factors make it challenging to determine their real-world impact, which is critical for understanding risk, informing public health policies, and mitigating the impact of COVID-19. 

### Methods
We analyzed the association between vaccination rates and COVID-19 severity for 48 states in the U.S. using Generalized Additive Models (GAMs). We controlled for dynamic factors such as testing, purpose-specific travel behaviors, underlying population immunity, and policy, and critical static factors such as comorbidities, vulnerability, race, and state healthcare expenditures. In addition, We used SARS-CoV-2 genomic surveillance data to model the different COVID-19 variant driven waves separately and evaluate if there is a changing role of the potential drivers of severity over time and across waves. 
 
### Findings
Our study revealed a strong and statistically significant negative association between vaccine uptake and COVID-19 severity across each variant wave. The effect of vaccination against severe COVID-19 disease does not change across waves. Results also showed that booster shots offered additional protection against severe diseases during the Omicron wave. Additionally, higher underlying population immunity based on previous infection rates are shown to be associated with reduced COVID-19 severity. Full-service restaurant visits are associated with increased COVID-19 severity for the pre-Delta and Delta waves, while office of physician visits are associated with increased COVID-19 severity for the Omicron wave. Moreover, the states with higher government policy index scores have lower COVID-19 severity. Regarding static variables, the social vulnerability index, and the proportion of adults at high risk exhibit positive associations with COVID-19 severity. In contrast, Medicaid spending per person exhibits a negative association with COVID-19 severity.

### Interpretation
Despite the emergence of new variants, vaccines remain highly effective at reducing severe outcomes of COVID-19. Therefore, given the ongoing threat posed by COVID-19, vaccines remain a critical line of defense for protecting the public and preventing burden on the healthcare systems. 


## Data  
* `df_hosp.csv`: all data used for model relative hospitalization rate.
* `df_inf.csv`: all data used for model relative infection rate.
* `age_US_state.csv': US state level population by age group, source: https://www.census.gov/data/datasets/time-series/demo/popest/2020s-state-detail.html
