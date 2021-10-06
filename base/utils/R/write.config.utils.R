#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------#
### TODO: Generalize this code for all ecosystem models (e.g. ED2.2, SiPNET, etc).
#--------------------------------------------------------------------------------------------------#

##' Get Quantiles
##'
##' Returns a vector of quantiles specified by a given `<quantiles>` xml tag
##'
##' @param quantiles.tag specifies tag used to specify quantiles
##' @return vector of quantiles
##' @export
##' @author David LeBauer
get.quantiles <- function(quantiles.tag) {
  quantiles <- vector()
  if (!is.null(quantiles.tag$quantile)) {
    quantiles <- as.numeric(quantiles.tag[names(quantiles.tag) == "quantile"])
  }
  if (!is.null(quantiles.tag$sigma)) {
    sigmas <- as.numeric(quantiles.tag[names(quantiles.tag) == "sigma"])
    quantiles <- append(quantiles, 1 - stats::pnorm(sigmas))
  }
  if (length(quantiles) == 0) {
    quantiles <- 1 - stats::pnorm(-3:3)  #default
  }
  if (!0.5 %in% quantiles) {
    quantiles <- append(quantiles, 0.5)
  }
  return(sort(quantiles))
} # get.quantiles


##' checks that met2model function exists
##'
##' Checks if `met2model.<model>` exists for a particular model
##'
##' @param model model package name
##' @return logical
met2model.exists <- function(model) {
  load.modelpkg(model)
  return(exists(paste0("met2model.", model)))
} # met2model.exists
