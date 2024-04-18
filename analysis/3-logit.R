# About ------------------------------------------------------------------------

# Logit discrete choice models
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   03/26/2024 
# Last edited:    04/18/2024 

# Run regressions --------------------------------------------------------------

source("analysis/support/regression-helpers.R")

vars <- c("beds", "uncomp_care_cost", "bad_debt")
felist <- c("provider_number", "year")

zip.ols <- feols(getFormula("log(zip_share)", "price", vars, felist), data = df)
hrr.ols <- feols(getFormula("log(hrr_share)", "price", vars, felist), data = df)
mkt.ols <- feols(getFormula("log(mkt_share)", "price", vars, felist), data = df)

# Calculate price elasticity ---------------------------------------------------

# Get price parameter from coefs
alpha.zip <- coef(zip.ols)["price"]
alpha.hrr <- coef(hrr.ols)["price"]
alpha.mkt <- coef(mkt.ols)["price"]

sample <- df %>% filter(!is.na(beds), !is.na(uncomp_care_cost), !is.na(bad_debt))

# Own-price elasticity = -(price param)(1 - share) price
elas.zip <- mean(-alpha.zip * (1 - sample$zip_share) * sample$price, na.rm = TRUE)
elas.hrr <- mean(-alpha.hrr * (1 - sample$hrr_share) * sample$price, na.rm = TRUE)
elas.mkt <- mean(-alpha.mkt * (1 - sample$mkt_share) * sample$price, na.rm = TRUE)

# Format tables ----------------------------------------------------------------

models <- list("ZIP" = zip.ols, "HRR" = hrr.ols, "Community" = mkt.ols)

gof_map <- tribble(
  ~raw,          ~clean,          ~fmt,     ~omit,
  "nobs",        "Observations",     0,     FALSE, 
  "r.squared",   "R2",               3,     FALSE
)
rows <- tribble(
  ~term,                ~ZIP,       ~HRR,       ~Community, 
  'Price elasticity',   elas.zip,   elas.hrr,   elas.mkt)

## Full table ------------------------------------------------------------------

coef_map <- c("price" = "Price",
              "beds" = "Beds",
              "uncomp_care_cost" = "Uncompensated care",
              "bad_debt" = "Bad debt")
attr(rows, 'position') <- 9

tab <- modelsummary(models, 
                    stars = c('*' = .1, '**' = .05, '***' = 0.01),
                    gof_map = gof_map, coef_map = coef_map,
                    add_rows = rows, 
                    output = "gt")

tab <- tab %>% 
  tab_header(
    title = md("Multinomial Logit Estimation")
  ) %>% 
  tab_source_note(
    source_note = "All models include hospital and year FE."
  ) %>% 
  tab_spanner(
    label = "ln(Market share)", 
    columns = c("ZIP", "HRR", "Community")
  ) %>% 
  opt_horizontal_padding(scale = 3)

## Short table -----------------------------------------------------------------

coef_short_map <- c("price" = "Price")
attr(rows, 'position') <- 3

tab_short <- modelsummary(models, 
                          stars = c('*' = .1, '**' = .05, '***' = 0.01),
                          gof_map = gof_map, coef_map = coef_short_map,
                          add_rows = rows,
                          output = "gt")

tab_short <- tab_short %>% 
  tab_header(
    title = md("Multinomial Logit Estimation")
  ) %>% 
  tab_source_note(
    source_note = "All models include number of beds, cost of uncompensated care, bad debt, and hospital and year FE."
  ) %>% 
  tab_spanner(
    label = "ln(Market share)", 
    columns = c("ZIP", "HRR", "Community")
  ) %>% 
  opt_horizontal_padding(scale = 3)

# Export table -----------------------------------------------------------------

gtsave(tab, "results/logit-elas.html")
gtsave(tab, "results/logit-elas.tex")
gtsave(tab_short, "results/logit-elas-short.html")
gtsave(tab_short, "results/logit-elas-short.tex")

rm(list = setdiff(ls(), "df"))
