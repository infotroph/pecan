% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{get.quantiles.from.density}
\alias{get.quantiles.from.density}
\title{Get the quantiles from prior density}
\usage{
get.quantiles.from.density(density.df, quantiles = c(0.025, 0.5, 0.975))
}
\arguments{
\item{density.df}{density dataframe generated by \code{\link{create.density.df}}}

\item{quantiles}{default is the median and 95\% CI;}
}
\description{
Finds quantiles on a density data frame
}
\examples{
prior.df <- create.density.df(distribution = list('norm',0,1))
get.quantiles.from.density(prior.df)
samp.df <- create.density.df(samps = rnorm(100))
get.quantiles.from.density(samp.df)
}
\author{
David LeBauer
}
