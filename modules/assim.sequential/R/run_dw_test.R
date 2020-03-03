# Just for testing:
# Modified from example in inst/sda.tobit.simulation.R
# Added by CKB to avoid setting up a full SDA when checking that his changes
# kept dwtmnorm usable inside the assim.sequential package namespace
#
# Usage:
# library(nimble)
# library(PEcAn.assim.sequential)
# PEcAn.assim.sequential:::run_dw_test(10)
#
# This function isn't exported and should be deleted after testing is done
#
run_dw_test <- function(niter) {

  dw_test <- nimbleCode({
    y[1:2] ~ dwtmnorm(mean = muf[1:2], prec = pf[1:2,1:2], wt = 1)
  })
  dw_test_pred <- nimbleModel(dw_test,
                                  data = list(muf = c(10, 20),
                                              pf = diag(2) * 1/5),
                                  name = 'dw')
  conf_dw_test <- configureMCMC(dw_test_pred, print=TRUE)
  Rmcmc_dw_test <- buildMCMC(conf_dw_test)
  Cmodel_dw_test <- compileNimble(dw_test_pred, showCompilerOutput = TRUE)
  Cmcmc_dw_test <- compileNimble(Rmcmc_dw_test, project = dw_test_pred)

  list(
    runMCMC(Rmcmc_dw_test, niter = niter, progressBar=TRUE),
    runMCMC(Cmcmc_dw_test, niter = niter, progressBar=TRUE))

}
