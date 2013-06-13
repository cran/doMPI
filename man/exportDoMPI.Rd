\name{exportDoMPI}
\alias{exportDoMPI}
\title{Export variables to doMPI cluster}
\description{
The \code{exportDoMPI} function exports variables to a doMPI cluster.
}
\usage{
exportDoMPI(cl, varlist, envir=.GlobalEnv)
}
\arguments{
  \item{cl}{The doMPI cluster.}
  \item{varlist}{Vector of variable names.}
  \item{envir}{Environment to get variables from.}
}
\examples{
\dontrun{
cl <- startMPIcluster(count=2)
f <- function() 'foo'
g <- function() f()
exportDoMPI(cl, c('f', 'g'))
}
}
\keyword{utilities}
