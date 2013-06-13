\name{registerDoMPI}
\alias{registerDoMPI}
\title{registerDoMPI}
\description{
The \code{registerDoMPI} function is used to register \code{doMPI}
with the foreach package.  Specifically, you register a particular
cluster object which will be used when executing the \%dopar\% operator.
The cluster object is created using \code{startMPIcluster}.
}
\usage{
registerDoMPI(cl)
}
\arguments{
  \item{cl}{The cluster object to use for parallel execution.}
}
\seealso{
  \code{\link{startMPIcluster}}
}
\examples{
\dontrun{
# start and register an MPI cluster with two workers:
cl <- startMPIcluster(2)
registerDoMPI(cl)
}
}

\keyword{utilities}
