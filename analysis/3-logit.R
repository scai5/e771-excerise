# About ------------------------------------------------------------------------

# Logit discrete choice models
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   03/26/2024 
# Last edited:    04/13/2024 

# Run regressions --------------------------------------------------------------

source("analysis/support/regression-helpers.R")

# Compute log(market share) - log(outside option share)
df <- df %>% 
  group_by(zip, year) %>% 
  mutate(zip_util = log(zip_share) - log(min(zip_share, na.rm = TRUE))) 
df <- df %>% 
  group_by(hrr, year) %>% 
  mutate(hrr_util = log(hrr_share) - log(min(hrr_share, na.rm = TRUE))) 
df <- df %>% 
  group_by(mkt, year) %>% 
  mutate(mkt_util = log(mkt_share) - log(min(mkt_share, na.rm = TRUE))) 

# TODO: Add additional hospital characteristics
vars <- c("beds")
felist <- c("provider_number", "year")

# Estimate using OLS 
zip_ols <- feols(getFormula("zip_util", "price", vars, felist), data = df)
hrr_ols <- feols(getFormula("hrr_util", "price", vars, felist), data = df)
mkt_ols <- feols(getFormula("mkt_util", "price", vars, felist), data = df)

# Calculate price elasticity ---------------------------------------------------

# Get price parameter from coefs
alpha_zip <- coef(zip_ols)["price"]
alpha_hrr <- coef(hrr_ols)["price"]
alpha_mkt <- coef(mkt_ols)["price"]

# Own-price elasticity = -(price param)(1 - share) price
elas_zip <- mean(-alpha_zip * (1 - df$zip_share) * df$price, na.rm = TRUE)
elas_hrr <- mean(-alpha_hrr * (1 - df$hrr_share) * df$price, na.rm = TRUE)
elas_mkt <- mean(-alpha_mkt * (1 - df$mkt_share) * df$price, na.rm = TRUE)

# Format table -----------------------------------------------------------------

# TODO: Format table 

# Export table -----------------------------------------------------------------

rm(list = setdiff(ls(), "df"))
