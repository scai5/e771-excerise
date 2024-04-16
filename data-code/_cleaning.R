# About ------------------------------------------------------------------------

# Data cleaning 
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   02/27/2024 
# Last edited:    04/15/2024 

# Import HCRIS and crosswalks --------------------------------------------------

# From https://github.com/imccart/HCRIS, edited for years 1998 to 2018
source("data-code/imccart-HCRIS/_HCRIS_Data.R")
rm(list = ls())

source("data-code/ziphrr_xw.R")
source("data-code/zipfips_xw.R")

HCRIS.df <- read_tsv("data/output/HCRIS_Data.txt") %>% 
  filter(year >= 2000, year <= 2017) %>% 
  select(!c(fy_start, fy_end, date_processed, date_created))
ziphrr_xw <- read_tsv("data/output/ziphrr_xw.txt")
zipfips_xw <- read_tsv("data/output/zipfips_xw.txt")

# Use Ian's fips to mkt xw
fipsmkt_xw <- readRDS("data/input/hospital_markets.rds")

# ZIP and HRR ------------------------------------------------------------------

message("Missing ZIP ----------")
message(paste0("Unknown ZIP hospital-year obs.: ", sum(is.na(HCRIS.df$zip))))
message(paste0("Unknown ZIP hospitals: ", 
               length(unique(HCRIS.df$provider_number[is.na(HCRIS.df$zip)]))))
HCRIS.df <- HCRIS.df %>% filter(!is.na(zip))
message("Removed observations with missing ZIP")

message("Missing total discharges ----------")
message(paste0("Unknown discharges hospital-year obs.: ", sum(is.na(HCRIS.df$tot_discharges))))
message(paste0("Unknown discharges hospitals: ", 
               length(unique(HCRIS.df$provider_number[is.na(HCRIS.df$tot_discharges)]))))
HCRIS.df <- HCRIS.df %>% filter(!is.na(tot_discharges))
message("Removed observations with missing total discharges")

# Merge with ZIP HSA HRR crosswalk
HCRIS.df <- HCRIS.df %>% 
  mutate(zip = substr(zip, 1, 5)) %>% 
  left_join(ziphrr_xw, by = c('zip' = 'zip', 'year' = 'year'), keep = FALSE) %>% 
  rename(hrr = hrrnum, hsa = hsanum)

message("ZIP to HSA to HRR crosswalk ----------")
message(paste0("Unmatched hospital-year obs.: ", sum(is.na(HCRIS.df$hrr))))
message(paste0("Unmatched hospitals: ", 
             length(unique(HCRIS.df$provider_number[is.na(HCRIS.df$hrr)]))))

# Create zip market shares and HHI
HCRIS.df <- HCRIS.df %>% 
  group_by(year, zip) %>% 
  mutate(zip_tot_discharges = sum(tot_discharges, na.rm = TRUE),
         zip_share = tot_discharges / zip_tot_discharges,
         zip_hhi = sum(zip_share^2, na.rm = TRUE), 
         zip_tot_hosp = n())

# Create HRR market shares and HHI
HCRIS.df <- HCRIS.df %>% 
  group_by(year, hrr) %>% 
  mutate(hrr_tot_discharges = sum(tot_discharges, na.rm = TRUE),
         hrr_share = tot_discharges / hrr_tot_discharges,
         hrr_hhi = sum(hrr_share^2, na.rm = TRUE),
         hrr_tot_hosp = n())

# Community detection algorithm ------------------------------------------------

# Merge with ZIP FIPS mkt crosswalks
HCRIS.df <- HCRIS.df %>% 
  left_join(zipfips_xw, by = c('zip' = 'zip', 'year' = 'year'), keep = FALSE) %>% 
  left_join(fipsmkt_xw, by = c('cty_fips' = 'fips'), keep = FALSE)

message("ZIP to FIPS to mkt crosswalk ----------")
message(paste0("Unmatched hospital-year obs.: ", sum(is.na(HCRIS.df$mkt))))
message(paste0("Unmatched hospitals: ", 
               length(unique(HCRIS.df$provider_number[is.na(HCRIS.df$mkt)]))))

# Create mkt market shares
HCRIS.df <- HCRIS.df %>% 
  group_by(year, mkt) %>% 
  mutate(mkt_tot_discharges = sum(tot_discharges, na.rm = TRUE),
         mkt_share = tot_discharges / mkt_tot_discharges,
         mkt_hhi = sum(mkt_share^2, na.rm = TRUE), 
         mkt_tot_hosp = n())

# Adding price -----------------------------------------------------------------

# Define price as essentially charges / discharges, excluding Medicare
HCRIS.df <- HCRIS.df %>%
  mutate(
    discount_factor = 1 - tot_discounts / tot_charges, 
    price_num = (ip_charges + icu_charges + ancillary_charges) * discount_factor - tot_mcare_payment, 
    price_denom = tot_discharges - mcare_discharges, 
    price = price_num / price_denom
  )

message("Price variable ----------")
message(paste0("Number of observations with missing price: ", sum(is.na(HCRIS.df$price))))
message(paste0("Number of hospitals with missing price in any year: ", 
               length(unique(HCRIS.df$provider_number[is.na(HCRIS.df$price)]))))
message(paste0("Number of observations with negative price: ", sum(HCRIS.df$price < 0, na.rm = TRUE)))
message(paste0("Number of observations with price > 100,000: ", sum(HCRIS.df$price > 100000, na.rm = TRUE)))
HCRIS.df <- HCRIS.df %>% filter(price >=0, price <= 100000)
message("Removed observations with missing, negative, and outlier price")

message("Final dataframe ----------")
message(paste0("Total number of observations: ", nrow(HCRIS.df)))
message(paste0("Total number of unique hospitals: ", length(unique(HCRIS.df$provider_number))))

# Export -----------------------------------------------------------------------

write_tsv(HCRIS.df, "data/output/final_hosp_mkt.txt")
rm(list = ls())
