#' get sensitivity samples as a list
#'
#' @param pft Plant Functional Type
#' @param env 
#' @param quantiles quantiles at which to obtain samples from parameter for
#'  sensitivity analysis
get_sa_sample_list <- function(pft, env, quantiles) {
  sa_sample_list <- list()
  for (i in seq_along(pft)) {
    sa_sample_list[[i]] <- get_sa_samples(pft[[i]], quantiles)
  }
  sa_sample_list[[length(pft) + 1]] <- get_sa_samples(env, quantiles)
  names(sa_sample_list) <- c(names(pft), "env")

  sa_sample_list
}
