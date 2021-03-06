% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_restart.ModelName.R
\name{write_restart.ModelName}
\alias{write_restart.ModelName}
\title{Write restart template for SDA}
\usage{
write_restart.ModelName(
  outdir,
  runid,
  start.time,
  stop.time,
  settings,
  new.state,
  RENAME,
  new.params,
  inputs
)
}
\arguments{
\item{outdir}{outout directory}

\item{runid}{run id}

\item{start.time}{Time of current assimilation step}

\item{stop.time}{Time of next assimilation step}

\item{settings}{pecan settings list}

\item{new.state}{Analysis state matrix returned by \code{sda.enkf}}

\item{RENAME}{flag to either rename output file or not}

\item{new.params}{optional, additionals params to pass write.configs that are deterministically related to the parameters updated by the analysis}

\item{inputs}{new input paths updated by the SDA workflow, will be passed to write.configs}
}
\description{
Write restart files for model
}
\author{
Alexey Shiklomanov
}
