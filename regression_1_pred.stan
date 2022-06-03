//
// Regression with one predictor
//
// Andrew L. Cohen
// May 15, 2020
// Edited May 31, 2022

// The input data. -------------------
data {
  // Total number data observations.
  int<lower=0> N; 
  
  // An array of length N of predictor values.
  vector[N] x1;
  
  // An array of length N of outcomes. 
  vector[N] y; 
}

// The parameters accepted by the model. -------------------
parameters {
  // The regression constant
  real b0; 
  
  // The regression coefficient on x1
  real b1; 

  // The standard deviation
  real<lower=0> sigma; 
}

// The model to be estimated. ------------------- 
model {
  // The priors
  b0 ~ normal(0, 2);
  b1 ~ normal(0, 2);
  sigma ~ gamma(3, 1.5);

  // The likelihood
  y ~ normal(b0 + b1*x1, sigma); 
}

// Generated quantitites. -------------------
generated quantities {
  // Variable declarations
  // A value is generated after each sample.
  real b0_prior;
  real b1_prior;
  real<lower=0> sigma_prior;
  real mu[N];
  real x_pred[N];
  real y_pred[N];
  real resid[N];
  
  // For priors
  b0_prior = normal_rng(0, 2);
  b1_prior = normal_rng(0, 2);
  sigma_prior = gamma_rng(3, 1.5);

  // Means
  for (i in 1:N) {
    mu[i] = b0 + b1*x1[i];
  }
  
  // y predictions
  for (i in 1:N) {
    x_pred[i] = x1[i];
    y_pred[i] = normal_rng(b0 + b1*x1[i], sigma); 
  }
  
  // Residuals
  for (i in 1:N) {
    resid[i] = y[i] - mu[i]; 
  }
  
}

// The program must end with a blank line! Comments aren't blank lines.
