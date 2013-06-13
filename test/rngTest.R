suppressMessages(library(doMPI))
library(itertools)

test01 <- function(n=4) {
  RNGkind("L'Ecuyer-CMRG")
  expected <- as.list(iRNGStream(.Random.seed), n=n)

  cl <- startMPIcluster(n, comm=3)
  registerDoMPI(cl)
  on.exit(closeCluster(cl))

  setRngDoMPI(cl)
  actual <- foreach(icount(n)) %dopar% .Random.seed

  identical(actual, expected)
}

test02 <- function(n=4) {
  RNGkind("L'Ecuyer-CMRG")
  set.seed(123)
  expected <- c(list(.Random.seed), as.list(iRNGStream(.Random.seed), n=n-1))

  RNGkind("Mersenne-Twister", "Inversion")
  rm('.Random.seed', pos=globalenv())

  cl <- startMPIcluster(n, comm=3)
  registerDoMPI(cl)
  on.exit(closeCluster(cl))

  setRngDoMPI(cl, seed=123)
  actual <- foreach(icount(n)) %dopar% .Random.seed

  identical(actual, expected)
}

print(test01())
print(test02())
