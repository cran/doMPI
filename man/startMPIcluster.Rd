\name{startMPIcluster}
\alias{startMPIcluster}
\title{Create and start an MPI cluster}
\description{
The \code{startMPIcluster} function is used to start an MPI cluster.
}
\usage{
startMPIcluster(count, verbose=FALSE, workdir=getwd(), logdir=workdir,
                maxcores=1, includemaster=TRUE, bcast=TRUE,
                comm=if (mpi.comm.size(0) > 1) 0 else 3,
                intercomm=comm + 1, mtag=10, wtag=11)
}
\arguments{
  \item{count}{Number of workers to spawn.  If you start your
  script using mpirun/orterun, then you don't really need to use
  the \code{count} argument, because \code{startMPIcluster} will
  try to do something reasonable.  To be more specific, if
  \code{comm} is \code{0}, then it will set \code{count} to
  \code{mpi.comm.size(0) - 1}.  In fact, it is an error to set
  \code{count} to any other value.  If \code{comm} is greater than
  \code{0}, it will determine the number of processes to spawn by calling
  \code{mpi.universe.size()}.  If that value is greater than one, then
  \code{count} is set to one less.  If that value is equal to one, then
  \code{count} is arbitrarily set to \code{2}.
  Note that if you've started the script without
  mpirun/orterun, than \code{mpi.universe.size()} will always return
  \code{1}, so \code{count} will default to \code{2}.}
  \item{verbose}{Indicates if verbose messages should be enabled.
  Defaults to \code{FALSE}.}
  \item{workdir}{Working directory of the cluster workers.
  Defaults to the master's working directory.}
  \item{logdir}{Directory to put the worker log files.
  Defaults to \code{workdir}.}
  \item{maxcores}{Maximum number of cores for workers to use.
  Defaults to \code{1}.}
  \item{includemaster}{Indicates if the master process should be counted
  as a load on the CPU.
  This will effect how many cores will be used on the local machine by
  mclapply, if a worker process is started on the local machine.
  Defaults to \code{TRUE}.}
  \item{bcast}{Indicates if a true MPI broadcast should be used to send
  shared \dQuote{job} data to the workers.  If \code{FALSE} is specified, the
  data is sent by separate messages to each worker, which is sometimes
  faster than using a broadcast.  So this option really controls whether
  to do a real or an emulated broadcast.  Defaults to \code{TRUE}.}
  \item{comm}{Communicator number to use.  A value of 0 means to use
  non-spawn mode, which means the cluster workers are started using
  mpirun/ortrun with more than one worker.  A value of 1 or more
  forces spawn mode.  Multiple clusters can be started by using different
  values for \code{comm} and \code{intercomm}.  It defaults to \code{0}
  if \code{mpi.comm.size(0) > 1}, otherwise \code{3}.}
  \item{intercomm}{Inter-communicator number.  Defaults to \code{comm + 1}.}
  \item{mtag}{Tag to use for messages sent to the master.
  Do not use this option unless you know what you're doing, or
  your program will very likely hang.
  Defaults to \code{10}.}
  \item{wtag}{Tag to use for messages sent to the workers.
  Do not use this option unless you know what you're doing, or
  your program will very likely hang.
  Defaults to \code{11}.}
}
\note{
The \code{startMPIcluster} function will return an MPI cluster object of
different classes, depending on the \code{bcast} option.  This is
because broadcasting is implemented as a method on the MPI cluster
object, and that method is implemented differently in the different
classes.

Also note that the \code{bcast} option has no effect if the
backend-specific \code{forcePiggyback} option is used with
\code{foreach}, since \dQuote{piggy-backing} is an alternative way to send
the job data to the workers in separate messages.

So there are currently three ways that the job data can be sent to the
workers: piggy-backed with the first task to each worker, broadcast, or
sent in separate messages.  Which method is best will presumably depend
on your hardware and your MPI implementation.
}
\examples{
\dontrun{
# start and register an MPI cluster with two workers in verbose mode:
cl <- startMPIcluster(count=2, verbose=TRUE)
registerDoMPI(cl)
# and shut it down
closeCluster(cl)

# set the working directory to /tmp:
cl <- startMPIcluster(count=2, workdir='/tmp')
registerDoMPI(cl)
# and shut it down
closeCluster(cl)
}
}
\keyword{utilities}
