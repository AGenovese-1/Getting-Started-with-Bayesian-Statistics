//
// Regression with a constant predictor
//
// Andrew L. Cohen
// May 15, 2020
// Edited May 31, 2022

// The input data. -------------------
data {
  // Total number data observations.
  int<lower=0> N; 
  
  // An array of length N of outcomes. 
  vector[N] y; 
}

// The parameters accepted by the model. -------------------
parameters {
  // The mean
  real mu;
  
  // The standard deviation
  real<lower=0> sigma; 
}

// The model to be estimated. ------------------- 
model {
  // The prior on the mean
  mu ~ normal(0, 2);

  // The prior on the standard deviation
  // Other possibilities: uniform, gamma, half-Cauchy, half-normal, half-t
  sigma ~ gamma(3, 1.5);

  // The likelihood
  y ~ normal(mu, sigma); 
}

// Generated quantitites. -------------------
generated quantities {
  // Variable declarations
  // A value is generated after each sample.
  real mu_prior;
  real<lower=0> sigma_prior;
  real y_pred[N];
  real resid[N];
  
  // For priors
  mu_prior = normal_rng(0, 2); 
  sigma_prior = gamma_rng(3, 1.5);
  
  // y posterior predictive
  for (i in 1:N) {
    y_pred[i] = normal_rng(mu, sigma);
  }

  // Residuals
  for (i in 1:N) {
    resid[i] = y[i] - mu; 
  }
}

// The program must end with a blank line! Comments aren't blank lines.
