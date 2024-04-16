# About ------------------------------------------------------------------------

# Logit discrete choice models
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   03/26/2024 
# Last edited:    04/15/2024 

# Run regressions --------------------------------------------------------------

source("analysis/support/regression-helpers.R")

# TODO: Add additional hospital characteristics
vars <- c("beds")
felist <- c("provider_number", "year")

# Estimate using OLS 
zip_ols <- feols(getFormula("log(zip_share)", "price", vars, felist), data = df)
hrr_ols <- feols(getFormula("log(hrr_share)", "price", vars, felist), data = df)
mkt_ols <- feols(getFormula("log(mkt_share)", "price", vars, felist), data = df)

# Calculate price elasticity ---------------------------------------------------

# Get price parameter from coefs
alpha_zip <- coef(zip_ols)["price"]
alpha_hrr <- coef(hrr_ols)["price"]
alpha_mkt <- coef(mkt_ols)["price"]

# Own-price elasticity = -(price param)(1 - share) price
elas_zip <- mean(-alpha_zip * (1 - df$zip_share) * df$price, na.rm = TRUE)
elas_hrr <- mean(-alpha_hrr * (1 - df$hrr_share) * df$price, na.rm = TRUE)
elas_mkt <- mean(-alpha_mkt * (1 - df$mkt_share) * df$price, na.rm = TRUE)

elas <- c(elas_zip, elas_hrr, elas_mkt)

# Format table -----------------------------------------------------------------

# TODO: Format table 
models <- list("(1) ZIP" = zip_ols, "(2) HRR" = hrr_ols, "(3) Community" = mkt_ols)

gof_map <- tribble(
  ~raw,          ~clean,          ~fmt,     ~omit,
  "nobs",        "Observations",     0,     FALSE, 
  "r.squared",   "R2",               3,     FALSE
)

tab <- modelsummary(models, 
                    stars = c('*' = .1, '**' = .05, '***' = 0.01),
                    gof_map = gof_map,
                    output = "gt")

# TODO: Rename variables, reorganize, add elasticities 
tab <- tab %>% 
  tab_header(
    title = md("**Multinomial Logit Estimation**")
  ) %>% 
  tab_source_note(
    source_note = "All models include hospital and year FE."
  ) %>% 
  tab_spanner(
    label = "ln(Market share)", 
    columns = starts_with("(")
  ) %>% 
  opt_horizontal_padding(scale = 3)

# Export table -----------------------------------------------------------------

gtsave(tab, "results/logit-elas.html")
gtsave(tab, "results/logit-elas.tex")

rm(list = setdiff(ls(), "df"))
