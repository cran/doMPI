\name{cluster}
\alias{clusterSize}
\alias{closeCluster}
\title{Cluster Management Functions}
\description{
\code{clusterSize} returns the number of workers in a cluster.
\code{closeCluster} shuts down and cleans up a cluster.
}
\usage{
clusterSize(cl, ...)
closeCluster(cl, ...)
}
\arguments{
  \item{cl}{The cluster object.}
  \item{\dots}{Currently unused.}
}
\keyword{utilities}
