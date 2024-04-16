# About ------------------------------------------------------------------------

# Association between price and market concentration
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   03/25/2024 
# Last edited:    04/15/2024 

# Run regressions --------------------------------------------------------------

source("analysis/support/regression-helpers.R")

# TODO: Add additional time-varying hospital and market characteristics
vars <- c("beds")
felist <- c("provider_number", "year")

zip_fe <- feols(getFormula("price", "zip_hhi", c(vars, "zip_tot_hosp"), felist), 
                data = df)
hrr_fe <- feols(getFormula("price", "hrr_hhi", c(vars, "hrr_tot_hosp"), felist), 
                data = df)
mkt_fe <- feols(getFormula("price", "mkt_hhi", c(vars, "mkt_tot_hosp"), felist), 
                data = df)

# Format table -----------------------------------------------------------------

models <- list("(1) ZIP" = zip_fe, "(2) HRR" = hrr_fe, "(3) Community" = mkt_fe)

gof_map <- tribble(
  ~raw,          ~clean,          ~fmt,     ~omit,
  "nobs",        "Observations",     0,     FALSE, 
  "r.squared",   "R2",               3,     FALSE
)

tab <- modelsummary(models, 
                    stars = c('*' = .1, '**' = .05, '***' = 0.01),
                    gof_map = gof_map,
                    output = "gt")

# TODO: Rename variables, reorganize 
tab <- tab %>% 
  tab_header(
    title = md("**Hospital Price and Market Concentration Association**")
  ) %>% 
  tab_source_note(
    source_note = "All models include hospital and year FE."
  ) %>% 
  tab_spanner(
    label = "Price", 
    columns = starts_with("(")
  ) %>% 
  opt_horizontal_padding(scale = 3)

# Export table -----------------------------------------------------------------

gtsave(tab, "results/price-hhi-corr.html")
gtsave(tab, "results/price-hhi-corr.tex")

rm(list = setdiff(ls(), "df"))
