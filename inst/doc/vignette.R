## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## ----eval=TRUE----------------------------------------------------------------
library(OnlineSurr)
head(sim_onlinesurr)

fit <- fit.surr(
  formula   = y ~ 1, # baseline fixed effects; trt*time terms added internally
  id        = id,
  surrogate = ~s, # surrogate structure
  treat     = trt,
  data      = sim_onlinesurr,
  time      = time,
  N.boots   = 2000, # bootstrap draws stored in the fitted object
  verbose   = 0 # hide progress
)

## ----eval=FALSE---------------------------------------------------------------
# library(OnlineSurr)
# 
# fit <- fit.surr(
#   formula   = y ~ 1, # baseline fixed effects; trt*time terms added internally
#   id        = id,
#   surrogate = ~ s(s) + s(lagged(s, 1)) + s(lagged(s, 2)), # surrogate structure
#   treat     = trt,
#   data      = sim_onlinesurr,
#   time      = time,
#   verbose   = 0 # hide progress
# )

## ----eval=TRUE----------------------------------------------------------------
summary(fit, t = 6, cumulative = TRUE)

## ----eval=TRUE----------------------------------------------------------------
plot(fit, type = "LPTE") # Local PTE over time
plot(fit, type = "CPTE") # Cumulative PTE over time
plot(fit, type = "Delta") # Delta and Delta_R over time

## ----eval=TRUE----------------------------------------------------------------
test <- time_homo_test(fit, signif.level = 0.05, N.boots = 50000)
test

## ----eval=TRUE----------------------------------------------------------------
sessionInfo()

