% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataone_download.R
\name{dataone_download}
\alias{dataone_download}
\title{DataONE download}
\usage{
dataone_download(
  id,
  filepath = "/fs/data1/pecan.data/dbfiles",
  CNode = "PROD",
  lazyLoad = FALSE,
  quiet = FALSE
)
}
\arguments{
\item{id}{"The identifier of a package, package metadata or other package member" -- dataone r}

\item{filepath}{path to where files will be stored}

\item{CNode}{character, passed to `dataone::CNode`}

\item{lazyLoad}{"A logical value. If TRUE, then only package member system metadata is downloaded and not data. The default is FALSE." -- dataone R}

\item{quiet}{"A 'logical'. If TRUE (the default) then informational messages will not be printed." -- dataone R}
}
\description{
Adapts the dataone::getDataPackage workflow to allow users to download data from the DataONE federation by simply entering the doi or associated package id
}
\examples{
\dontrun{
dataone_download(id = "doi:10.6073/pasta/63ad7159306bc031520f09b2faefcf87", 
filepath = "/fs/data1/pecan.data/dbfiles")
}
}
\author{
Liam P Burke, \email{lpburke@bu.edu}
}
