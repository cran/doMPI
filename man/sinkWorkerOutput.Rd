\name{sinkWorkerOutput}
\alias{sinkWorkerOutput}
\title{Redirect worker output to a file}
\description{
The \code{sinkWorkerOutput} function is used to redirect worker output
to a file.  It is intended to be used from a \code{doMPI} script
that is executed in \dQuote{non-spawn} mode.
}
\usage{
sinkWorkerOutput(outfile)
}
\arguments{
  \item{outfile}{a character string naming the file to write to.}
}
\examples{
\dontrun{
sinkWorkerOutput(sprintf('worker_%d.log', mpi.comm.rank(0)))
}
}
\keyword{utilities}
