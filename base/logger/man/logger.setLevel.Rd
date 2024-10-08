% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logger.R
\name{logger.setLevel}
\alias{logger.setLevel}
\title{Configure logging level.}
\usage{
logger.setLevel(level)
}
\arguments{
\item{level}{the level of the message (ALL, DEBUG, INFO, WARN, ERROR, OFF)}
}
\value{
When logger level is set, the previous level is returned invisibly.
This can be passed to \code{logger.setLevel()} to restore the previous level.
}
\description{
This will configure the logger level. This allows to turn DEBUG, INFO,
WARN and ERROR messages on and off.
}
\examples{
\dontrun{
logger.setLevel('DEBUG')
}
}
\author{
Rob Kooper
}
