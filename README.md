# ECON 771 Empirical Exercise 4
This repository contains all code to complete empirical exercise 4 for ECON 771. This exercise examines the effect of market definition on demand hospital demand estimation. For assignment details, see the [class website](https://econ771s24.classes.ianmccarthyecon.com/assignments/exercise4.html). This repository does not contain data or data documentation.

## Data

1. **Hospital Cost Report Information System (HCRIS):** 

2. **Hospital Service Area Files (HSAF):** 

3. **ZIP code to HSA to HRR crosswalk:** Crosswalk available for years 1995-2019. Files from the [Dartmouth Atlas](https://data.dartmouthatlas.org/supplemental/).

4. **ZIP code to county crosswalk:** Crosswalk available for the fourth quarter of years 2010-2019. Files the [US Department of Housing and Urban Development](https://www.huduser.gov/portal/datasets/usps_crosswalk.html). 

## Code 

Coding workflow is broken into two parts: (1) data cleaning and (2) analysis. Running `analysis/_main.R` will run all code, including cleaning and analysis, in the correct order.

### Cleaning

`data-code/_cleaning.R` will run all data cleaning code in the correct order. 

1. Raw HCRIS data is cleaned using code from [Ian McCarthy's HCRIS repo](https://github.com/imccart/HCRIS/). 

2. HCRIS data is merged with [ZIP code to HSA to HRR crosswalk from the Dartmouth Atlas](https://data.dartmouthatlas.org/supplemental/). 

3. HCRIS data is merged with a community detection defined market crosswalk. Community detection defined markets are based on patient flows from the HSAF, as in [John Graves' repo](https://github.com/graveja0/health-care-markets/). Raw HSAF data is used to form markets using code from [Ian's hospital market repo](https://github.com/imccart/hospital-markets/). An extract from the results of this repo is provided in class documents. 

4. 

5. 

### Analysis 

`analysis/_main.R` will run all code in the correct order. 

1. `analysis/1-graph-shares.R` graphs hospital market shares over time. Market share is defined as number of hospital discharges over total market discharges. Markets are defined as ZIP code, HRR, and by the community detection algorithm. 

2. `analysis/2-price-hhi.R` provides descriptive evidence on the relationship between price and HHI. Again, markets are defined as ZIP code, HRR, and by the community detection algorithm. 

3. `analysis/3-logit.R` estimates a logit discrete choice model using market level data via Berry inversion and calculates price elasticities. Again, markets are defined as ZIP code, HRR, and by the community detection algorithm. 
