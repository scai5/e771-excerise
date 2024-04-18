# About ------------------------------------------------------------------------

# Association between price and market concentration
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   03/25/2024 
# Last edited:    04/18/2024 

# Run regressions --------------------------------------------------------------

source("analysis/support/regression-helpers.R")

vars <- c("beds", "uncomp_care_cost", "bad_debt")
felist <- c("provider_number", "year")

zip.fe <- feols(getFormula("price", "zip_hhi", c(vars, "zip_tot_hosp"), felist), 
                data = df)
hrr.fe <- feols(getFormula("price", "hrr_hhi", c(vars, "hrr_tot_hosp"), felist), 
                data = df)
mkt.fe <- feols(getFormula("price", "mkt_hhi", c(vars, "mkt_tot_hosp"), felist), 
                data = df)

# Format table -----------------------------------------------------------------

models <- list("ZIP" = zip.fe, "HRR" = hrr.fe, "Community" = mkt.fe)

gof_map <- tribble(
  ~raw,          ~clean,          ~fmt,     ~omit,
  "nobs",        "Observations",     0,     FALSE, 
  "r.squared",   "R2",               3,     FALSE
)

## Full table ------------------------------------------------------------------

coef_map <- c("zip_hhi" = "Market HHI", "hrr_hhi" = "Market HHI", "mkt_hhi" = "Market HHI", 
              "zip_tot_hosp" = "Market size", "hrr_tot_hosp" = "Market size", "mkt_tot_hosp" = "Market size", 
              "beds" = "Beds",
              "uncomp_care_cost" = "Uncompensated care",
              "bad_debt" = "Bad debt")

tab <- modelsummary(models, 
                    stars = c('*' = .1, '**' = .05, '***' = 0.01),
                    gof_map = gof_map, coef_map = coef_map,
                    output = "gt")

tab <- tab %>% 
  tab_header(
    title = md("**Hospital Price and Market Concentration Association**")
  ) %>% 
  tab_source_note(
    source_note = "Market size is measured by number of hospitals in the market. 
                   All models include hospital and year FE."
  ) %>% 
  tab_spanner(
    label = "Price", 
    columns = c("ZIP", "HRR", "Community")
  ) %>% 
  opt_horizontal_padding(scale = 3)

## Short table -----------------------------------------------------------------

coef_short_map <- c("zip_hhi" = "Market HHI", "hrr_hhi" = "Market HHI", "mkt_hhi" = "Market HHI")

tab_short <- modelsummary(models, 
                          stars = c('*' = .1, '**' = .05, '***' = 0.01),
                          gof_map = gof_map, coef_map = coef_short_map,
                          output = "gt")

tab_short <- tab_short %>% 
  tab_header(
    title = md("**Hospital Price and Market Concentration Association**")
  ) %>% 
  tab_source_note(
    source_note = "All models include number of beds, cost of uncompensated care, bad debt, and hospital and year FE."
  ) %>% 
  tab_spanner(
    label = "Price", 
    columns = c("ZIP", "HRR", "Community")
  ) %>% 
  opt_horizontal_padding(scale = 3)

# Export tables ----------------------------------------------------------------

gtsave(tab, "results/price-hhi-corr.html")
gtsave(tab, "results/price-hhi-corr.tex")
gtsave(tab_short, "results/price-hhi-corr-short.html")
gtsave(tab_short, "results/price-hhi-corr-short.tex")

rm(list = setdiff(ls(), "df"))
