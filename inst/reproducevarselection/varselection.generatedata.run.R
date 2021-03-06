library(unbiasedmcmc)
rm(list = ls())
set.seed(1)
# registerDoParallel(cores = detectCores())

# simulate data
n <- 1000
p <- 5000
for (SNR in c(0.5, 1, 2)){
  s_star <- 10
  s0 <- 100
  sigma0 <- 1
  beta_star <- SNR * sqrt(sigma0^2 * log(p) / n) * c(2,-3,2,2,-3,3,-2,3,-2,3, rep(0, p-10))
  # independent design
  X <- matrix(rnorm(n * p), nrow = n, ncol = p) # fast_rmvnorm_chol(n, rep(0, p), diag(1, p, p))
  X <- scale(X)
  Y <- X %*% matrix(beta_star, ncol = 1) + rnorm(n, 0, sigma0)
  Y <- scale(Y)

  save(X, Y, beta_star, file = paste0("varselection.dataSNR", SNR, ".RData"))
}
# correlated design
n <- 1000
p <- 5000
for (SNR in c(0.5, 1, 2)){
  s_star <- 10
  s0 <- 100
  sigma0 <- 1
  beta_star <- SNR * sqrt(sigma0^2 * log(p) / n) * c(2,-3,2,2,-3,3,-2,3,-2,3, rep(0, p-10))
  covariance <- matrix(0, nrow = p, ncol = p)
  for (i in 1:p){
    for (j in 1:p){
      covariance[i,j] <- exp(-abs(i-j))
    }
  }

  X <- fast_rmvnorm(n, mean = rep(0, p), covariance)
  # X <- matrix(rnorm(n * p), nrow = n, ncol = p) # fast_rmvnorm_chol(n, rep(0, p), diag(1, p, p))
  X <- scale(X)
  Y <- X %*% matrix(beta_star, ncol = 1) + rnorm(n, 0, sigma0)
  Y <- scale(Y)

  save(X, Y, beta_star, file = paste0("varselection.data.correlatedSNR", SNR, ".RData"))
}
