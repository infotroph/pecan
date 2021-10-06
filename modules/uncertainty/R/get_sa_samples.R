#' Get sensitivity analysis samples
#'
#' Samples parameters for a model run at specified quantiles.
#'
#' Samples from long (>2000) vectors that represent random samples from a
#'   trait distribution.
#' Samples are either the MCMC chains output from the Bayesian meta-analysis
#'   or are randomly sampled from the closed-form distribution of the
#'   parameter probability distribution function.
#' The list is indexed first by trait, then by quantile.
#'
#' @param samples random samples from trait distribution
#' @param quantiles list of quantiles to at which to sample,
#'   set in settings file
#' @return a list of lists representing quantile values of trait distributions
#' @author David LeBauer
get_sa_samples <- function(samples, quantiles) {
  sa_samples <- data.frame()
  for (trait in names(samples)) {
    for (quantile in quantiles) {
      sa_samples[as.character(round(quantile * 100, 3)), trait] <-
        quantile(samples[[trait]], quantile)
    }
  }

  sa_samples
}