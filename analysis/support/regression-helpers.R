# About ------------------------------------------------------------------------

# Regression helpers 
# ECON 771 Exercise 4
# Author:         Shirley Cai 
# Date created:   03/26/2024 
# Last edited:    04/13/2024 

# Code -------------------------------------------------------------------------

#' Get FEOLS formula
#' 
#' Returns a formula of the form dep ~ ind + covariates | fixed effects 
#'
#' @param dep_var String of the name of the dependent variable to be added to the formula 
#' @param ind_var String of the name of the independent variable to be added to the formula
#' @param vars Vector of strings including names of all covariates 
#' @param felist Vector of strings including all fixed effects 
#'
#' @return A formula to be passed into functions from the fixest package
getFormula <- function(dep_var, ind_var, vars, felist){
  
  varlist <- c(ind_var, vars)
  
  fml_string <- paste(dep_var, 
                      paste(varlist, collapse = " + "), 
                      sep = " ~ ")
  fml_string <- paste(fml_string, 
                      paste(felist, collapse = " + "), 
                      sep = " | ")
  
  return(as.formula(fml_string))
}
