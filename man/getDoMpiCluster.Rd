\name{getDoMpiCluster}
\alias{getDoMpiCluster}
\title{Get the registered doMPI cluster object}
\description{
The \code{getDoMpiCluster} function is used to get the cluster object
that was registered using the \code{registerDoMPI} function.
This can be useful when you want to get the communicator object
for performing MPI operations in a \code{foreach} program.
}
\usage{
getDoMpiCluster()
}
\keyword{utilities}
