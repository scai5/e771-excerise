# About ------------------------------------------------------------------------

# Master script
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   02/28/2024 
# Last edited:    04/13/2024 
# Last run:       04/13/2024

# Preliminary ------------------------------------------------------------------

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, readxl, hrbrthemes, extrafont, forcats, fixest, modelsummary, gt)
font_import() 
loadfonts(device = 'win')

# Clean data -------------------------------------------------------------------

source("data-code/_cleaning.R")
df <- read_tsv("data/output/final_hosp_mkt.txt")

# Analysis ---------------------------------------------------------------------

source("analysis/1-graph-shares.R")
source("analysis/2-price-hhi.R")
source("analysis/3-logit.R")
