\name{dompiWorkerLoop}
\alias{dompiWorkerLoop}
\title{Create and start an MPI cluster}
\description{
The \code{dompiWorkerLoop} function is used from a cluster worker to run
the worker loop in order to execute worker tasks.  This is intended
to be used from a \code{doMPI} script that is executed in
\dQuote{non-spawn} mode.
}
\usage{
dompiWorkerLoop(cl, cores=1, verbose=FALSE)
}
\arguments{
  \item{cl}{a \code{dompicluster} object created with \code{startMPIcluster}.}
  \item{cores}{Maximum number of cores for workers to use.
  Defaults to \code{1}.}
  \item{verbose}{Indicates if verbose messages should be enabled.
  Defaults to \code{FALSE}.}
}
\examples{
\dontrun{
cl <- openMPIcluster()
dompiWorkerLoop(cl)
}
}
\keyword{utilities}
