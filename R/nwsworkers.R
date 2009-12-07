#
# Copyright (c) 2009, Stephen B. Weston
#
# This is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
# USA

# this is called by the user to create an nws cluster object
startNWScluster <- function(count=length(nodelist), verbose=FALSE,
                            workdir=getwd(), logdir=workdir, maxcores=1,
                            includemaster=FALSE, timeout=60, nodelist) {
  if (missing(count) && missing(nodelist)) {
    stop('either "count" or "nodelist" must be specified')
  }

  if (! suppressMessages(require(nws))) {
    stop('The nws package is required to create an nws cluster')
  }

  # create a sleigh to implement our cluster
  sl <- if (missing(nodelist)) {
    sleigh(workerCount=count, verbose=verbose, workingDir=workdir,
           logDir=logdir)
  } else {
    sleigh(nodeList=nodelist, launch=sshcmd, workerCount=count,
           verbose=verbose, workingDir=workdir, logDir=logdir)
  }

  # make sure the sleigh is started
  stat <- status(sl, closeGroup=TRUE, timeout=timeout)
  if (stat$numWorkers == 0) {
    stop('unable to successfully start a sleigh')
  }

  workerids <- seq(length=stat$numWorkers)

  # get netWorkSpace object to use for all communications with workers
  ws <- sl@userNws

  # declare all the workspace variables that we need
  nwsDeclare(ws, 'broadcast', 'single')
  nwsDeclare(ws, 'master', 'fifo')
  workerVars <- sprintf('worker_%d', workerids)
  for (varName in workerVars)
    nwsDeclare(ws, varName, 'single')

  # start our dompiWorkerLoop (without waiting for it to finish, of course)
  eo <- list(blocking=FALSE, closure=FALSE)
  runWorkerLoop <- function(verbose, maxcores, includemaster, masternode) {
    require(doMPI)
    require(nws)

    # if maxcores is greater than 1, then attempt to load multicore
    usemc <- if (maxcores > 1)
      suppressWarnings(require(multicore, quietly=TRUE))
    else
      FALSE

    ws <- get('SleighUserNws', pos=globalenv())
    rank <- get('SleighRank', pos=globalenv()) + 1

    # get the number of processes on this node and our position among them
    numprocs <- as.integer(Sys.getenv('RSleighNumProcs'))
    id <- as.integer(Sys.getenv('RSleighLocalID'))

    # possibly adjust the number of cores if we're on the master node
    if (usemc) {
      numcores <- multicore:::detectCores()
      if (numcores > maxcores) {
        if (verbose) {
          cat(sprintf('reducing numcores from %d to %d as per maxcores\n',
                      numcores, maxcores))
        }
        numcores <- maxcores
      }
      nodename <- Sys.info()[['nodename']]
      if (includemaster && nodename == masternode)
        numcores <- numcores - 1

      # compute the number of cores available to us
      # this will determine if we will ever use mclapply
      cores <- numcores %/% numprocs + (id < numcores %% numprocs)
      cat(sprintf('numprocs: %d, id: %d, numcores: %d, cores: %d\n',
                  numprocs, id, numcores, cores))
    } else {
      cores <- 1
      if (verbose) {
        cat('multicore package is not being used\n')
      }
    }

    cl <- doMPI:::openNWScluster(ws, rank)

    dompiWorkerLoop(cl, cores, verbose)
  }
  masternode <- Sys.info()[['nodename']]
  sp <- eachWorker(sl, runWorkerLoop, verbose, maxcores,
                   includemaster, masternode, eo=eo)

  obj <- list(sp=sp, sl=sl, ws=ws, wvars=workerVars)
  class(obj) <- c('nwscluster', 'dompicluster')
  obj
}

clusterSize.nwscluster <- function(cl, ...) {
  workerCount(cl$sl)
}

# nwscluster method for shutting down a cluster object
closeCluster.nwscluster <- function(cl, ...) {
  # I'm being a bit over zealous for now
  for (wvar in cl$wvars) {
    nwsStore(cl$ws, wvar, NULL)
  }
  results <- waitSleigh(cl$sp)
  stopSleigh(cl$sl)
  invisible(results)  # might come in handy
}

# 
bcastSendToCluster.nwscluster <- function(cl, data, ...) {
  nwsStore(cl$ws, 'broadcast', data)
}

sendToWorker.nwscluster <- function(cl, workerid, robj, ...) {
  nwsStore(cl$ws, cl$wvars[workerid], robj)
}

recvFromAnyWorker.nwscluster <- function(cl, ...) {
  nwsFetch(cl$ws, 'master')
}

############################
# worker methods start here
############################

# this is called by the cluster workers to create an nws cluster object
openNWScluster <- function(ws, workerid) {
  wvar <- sprintf('worker_%d', workerid)
  broadcast <- nwsIFind(ws, 'broadcast')
  obj <- list(broadcast=broadcast, ws=ws, workerid=workerid, wvar=wvar)
  class(obj) <- c('nwscluster', 'dompicluster')
  obj
}

bcastRecvFromMaster.nwscluster <- function(cl, datalen, ...) {
  unserialize(cl$broadcast())
}

sendToMaster.nwscluster <- function(cl, robj, ...) {
  nwsStore(cl$ws, 'master', robj)
}

recvFromMaster.nwscluster <- function(cl, ...) {
  nwsFetch(cl$ws, cl$wvar)
}
