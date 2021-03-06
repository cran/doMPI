\name{doMPI-package}
\alias{doMPI-package}
\alias{doMPI}
\docType{package}
\title{
The doMPI Package
}
\description{
The \code{doMPI} package provides a parallel backend for the \code{foreach}
package. It is similar to the \code{doSNOW} package, but uses \code{Rmpi}
directly. This allows it to do more, and execute more efficiently.
It can also make use of the \code{multicore} package to execute tasks
across multiple cores on the worker nodes.  This is can give very good
performance on a computer cluster with multicore processors.
}
\details{
There are several backend-specific options that can be specified when using
\code{doMPI}.  They are specified to \code{foreach} as a list using the
\code{.options.mpi} argument.  The currently supported options are:

\tabular{ll}{
\code{chunkSize} \tab Number of tasks to send at a time to the cluster workers\cr
\code{info} \tab Display extra information, particularly about exported variables\cr
\code{initEnvir} \tab A function to be called on each worker before executing any tasks\cr
\code{initArgs} \tab List of extra arguments to pass to the \code{initEnvir} function\cr
\code{initEnvirMaster} \tab A function called on the master at the same time as \code{initEnvir}\cr
\code{initArgsMaster} \tab List of extra arguments to pass to the \code{initEnvirMaster} function\cr
\code{finalEnvir} \tab A function to be called on each worker after executing all tasks\cr
\code{finalArgs} \tab List of extra arguments to pass to the \code{finalEnvir} function\cr
\code{profile} \tab Display profiling information from the master's point of view\cr
\code{bcastThreshold} \tab Used to decide whether to piggy-back or broadcast job data\cr
\code{forcePiggyback} \tab Always piggy-back job environment with first task to each worker\cr
\code{nocompile} \tab Don't compile the R expression\cr
\code{seed} \tab Starting seed for tasks\cr
}

The \code{chunkSize} option is particularly important, since it can be
much more efficient to send more than one task at a time to the workers,
particularly when the tasks execute quickly.  Also, it can allow the
workers to execute those tasks in parallel using the \code{mclapply}
function from the \code{multicore} package.  The default value is
\code{1}.

The \code{info} option is used to print general information that is
specific to the \code{doMPI} backend.  This includes information on what
variables are exported, for example.  The default value is \code{FALSE}.

The \code{initEnvir} option is useful for preparing the workers to
execute the subsequent tasks.  The execution environment is passed as
the first argument to this function.  That allows you to define new
variables in the environment, for example.  If \code{initArgs} is
defined, the contents of the list will be passed as arguments to the
\code{initEnvir} function after the environment object.

The \code{initEnvirMaster} option is useful if you want to send data
from the master to the workers explicitly, perhaps using
\code{mpi.bcast}.  This avoids object serialization, which could improve
performance for large matrices, for example.  The \code{initArgsMaster}
option works like \code{initArgs}, however, it is probably less useful,
since the \code{initEnvirMaster} function runs locally, and can access
variables via lexical scoping.

The \code{finalEnvir} option is useful for \dQuote{finalizing} the execution
environment.  It works pretty much the same as the \code{initEnvir}
function, getting extra arguments from a list specified with the
\code{finalArgs} option.

The \code{profile} option is used to print profiling information at the
end of the \%dopar\% execution.  It basically lists the time spent
sending tasks to the workers and retrieving results from them.  The
default value is \code{FALSE}.

The \code{bcastThreshold} option is used to decide whether to piggy-back
the job data, or broadcast it.  The job data is serialized, and if it is
smaller than \code{bcastThreshold}, it is piggy-backed, otherwise, it is
broadcast.  Note that if you want to force piggy-backing, you should use
the \code{forcePiggyback}, rather than setting \code{bcastThreshold} to
a very large value.  That avoids serializing the job data twice, which
can be time consuming.

The \code{forcePiggyback} option is used to force the job data to be
\dQuote{piggy-backed} with the first task to each of the workers.  If the
value is \code{FALSE}, the data may still be piggy-backed, but it is not
guaranteed.  In general, the job data is only piggy-backed if it is
relatively small.  The default value is \code{FALSE}.

The \code{nocompile} option is used to disable compilation of the
R expression in the body of the foreach loop.  The default value is
\code{FALSE}.

The \code{seed} option is used for achieving reproducible results.  If
set to a single numeric value, such as \code{27}, it is converted to a
value that can be passed to the \code{nextRNGSubStream} function from
the \pkg{parallel} package.  This value is assigned to the global
\code{.Random.seed} variable on some cluster worker when it executes the
first task (or task chunk).  The \code{nextRNGSubStream} function is
used to generate subsequent values that are assigned to
\code{.Random.seed} when executing subsequent tasks.  Thus, RNG
substreams are associated with tasks, rather than workers.
This is necessary for reproducible results, since the \pkg{doMPI}
package uses load balancing techniques that can result in different
tasks being executed by different workers on different runs of the same
\code{foreach} loop.  The default value of the \code{seed} option is
\code{NULL}.

Additional documentation is available on the following functions:

\tabular{ll}{
\code{startMPIcluster} \tab Create and start an MPI cluster object\cr
\code{registerDoMPI} \tab Register a cluster object to be used with \%dopar\%\cr
\code{closeCluster} \tab Shutdown and close a cluster object\cr
\code{clusterSize} \tab Return the number of workers associated with a cluster object\cr
\code{setRngDoMPI} \tab Initialize parallel random number generation on a cluster\cr
}

For a complete list of functions with individual help pages,
use \code{library(help="doMPI")}.
Use the command \code{vignette("doMPI")} to view the vignette entitled
\dQuote{Introduction to doMPI}.
Also, there are a number of \code{doMPI} example scripts in the
examples directory of the \code{doMPI} installation.
}
\keyword{package}
