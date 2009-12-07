\name{startNWScluster}
\alias{startNWScluster}
\title{Create and start an NWS cluster}
\description{
The \code{startNWScluster} function is used to start an NWS cluster
for use with doMPI.
}
\usage{
startNWScluster(count=length(nodelist), verbose=FALSE, workdir=getwd(),
                logdir=workdir, maxcores=1, includemaster=FALSE,
                timeout=60, nodelist)
}
\arguments{
  \item{count}{Number of workers to spawn.  Defaults to length(nodelist).}
  \item{verbose}{Indicates if verbose messages should be enabled.  Defaults to \code{FALSE}.}
  \item{workdir}{Working directory of the cluster workers.  Defaults to the master's
  working directory.}
  \item{logdir}{Directory to put the worker log files.  Defaults to \code{workdir}.}
  \item{maxcores}{Maximum number of cores for workers to use.  Defaults to \code{1}.}
  \item{includemaster}{Indicates if the master process should be counted as a load o the CPU.
  This will effect how many cores will be used on the local machine by mclapply,
  if a worker process is started on the local machine.  The default value is FALSE,
  since the master process doesn't tend to use much CPU with nws.  Defaults to \code{TRUE}.}
  \item{timeout}{Number of seconds to wait for the sleigh workers to start.}
  \item{nodelist}{List of nodes on which to run workers.}
}
\examples{
\dontrun{
# start and register an NWS cluster with two workers in verbose mode:
cl <- startNWScluster(count=2, verbose=TRUE)
registerDoNWS(cl)
# and shut it down
closeCluster(cl)

# set the log directory to the current directory:
cl <- startNWScluster(count=2, logDir='.', verbose=TRUE)
registerDoNWS(cl)
# and shut it down
closeCluster(cl)
}
}
\keyword{utilities}
