## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## -----------------------------------------------------------------------------
set.seed(1)

# Dimensions
N <- 100 # subjects
T <- 6 # time points
times <- seq_len(T) # numeric, equally spaced

# Subject IDs and treatment assignment (two levels)
id <- rep(seq_len(N), each = T)
trt <- rep(rbinom(N, 1, 0.5), each = T) # 0/1

time <- rep(times, times = N)

# Simulate surrogate(s) and outcome
# Surrogate is affected by treatment and time
s <-
  0.2 * time + # Trend
  (0.2 + 0.4 * time) * trt + # Treatment effect
  rnorm(N * T, sd = 0.1) # Noise


# Outcome depends on treatment effect, time trend, surrogate, and noise
y <-
  0.2 + # intercept
  0.1 * time + # Trend
  (0.2 + 0.1 * time) * trt + # (direct) treatment effect
  0.6 * s + # Surrogate effect
  rnorm(N * T, sd = 0.1) # Noise

dat <- data.frame(
  id = id,
  trt = trt,
  time = time,
  s = s,
  y = y
)

# Ensure the data are ordered by (id, time) (recommended)
dat <- dat[order(dat$id, dat$time), ]
head(dat)

## ----eval=TRUE----------------------------------------------------------------
library(OnlineSurr)

fit <- fit.surr(
  formula   = y ~ 1, # baseline fixed effects; trt*time terms added internally
  id        = id,
  surrogate = ~s, # surrogate structure
  treat     = trt,
  data      = dat,
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
#   data      = dat,
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

