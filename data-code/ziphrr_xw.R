# About ------------------------------------------------------------------------

# Aggregate ZIP-HRR crosswalk
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   02/28/2024 
# Last edited:    03/17/2024

# Import and merge data --------------------------------------------------------

years <- formatC(0:17, width = 2, flag = "0")
df <- data.frame(zip = integer(),
                 hsanum = integer(), 
                 hrrnum = integer(), 
                 year = integer(),
                 stringsAsFactors = FALSE) 

for(yr in years){
  if(yr == "17"){
    xw <- read_excel(paste0("data/input/zip2hrr_xw/ZipHsaHrr", yr, ".xls")) %>% 
      select(paste0("zipcode20", yr), hsanum, hrrnum) %>% 
      rename(zip = paste0("zipcode20", yr)) %>%
      mutate(year = as.numeric(paste0("20", yr)))
  } else{
    xw <- read_excel(paste0("data/input/zip2hrr_xw/ZipHsaHrr", yr, ".xls")) %>% 
      select(paste0("zipcode", yr), hsanum, hrrnum) %>% 
      rename(zip = paste0("zipcode", yr)) %>%
      mutate(year = as.numeric(paste0("20", yr)))
  }
  
  df <- rbind(df, xw)
  rm(xw)
}

df <- df %>% 
  mutate(zip = str_pad(zip, 5, pad = "0"))

# Export -----------------------------------------------------------------------

write_tsv(df,'data/output/ziphrr_xw.txt')
rm(list = ls())
