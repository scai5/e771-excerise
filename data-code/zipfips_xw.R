# About ------------------------------------------------------------------------

# Aggregate ZIP-FIPS crosswalk
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   04/13/2024 
# Last edited:    04/13/2024

# Import and merge data --------------------------------------------------------

years <- formatC(0:17, width = 2, flag = "0")
df <- data.frame(zip = character(),
                 county = character(),
                 res_ratio = integer(), 
                 bus_ratio = integer(),
                 oth_ratio = integer(), 
                 tot_ratio = integer(), 
                 stringsAsFactors = FALSE) 

for(yr in years){
  if(yr < "10"){
    xw <- read_excel("data/input/zip2county_xw/ZIP_COUNTY_122010.xlsx") %>% 
      rename_with(tolower) %>%
      mutate(year = as.numeric(paste0("20", yr)))
  } else{
    xw <- read_excel(paste0("data/input/zip2county_xw/ZIP_COUNTY_1220", yr, ".xlsx")) %>% 
      rename_with(tolower) %>%
      mutate(year = as.numeric(paste0("20", yr)))
  }

  df <- rbind(df, xw)
  rm(xw)
}

# Map each ZIP to county with the highest ratio of business addresses 
set.seed(1234)
df <- df %>% 
  group_by(zip, year) %>%
  slice(which.max(rank(bus_ratio, ties.method = "random"))) %>% 
  select(c(zip, county, year)) %>% 
  rename(cty_fips = county)

# Export -----------------------------------------------------------------------

write_tsv(df,'data/output/zipfips_xw.txt')
rm(list = ls())
