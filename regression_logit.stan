//
// Logistic regression
//
// Andrew L. Cohen
// May 15, 2020

// The input data. -------------------
data {
  // Total number data observations.
  int<lower=0> N; 
  
  // An array of length N of predictor values.
  vector[N] x1;
  
  // An array of length N of outcomes. 
  int<lower=0, upper=1> y[N]; 
}

// The parameters accepted by the model. -------------------
parameters {
  // The regression constant
  real b0; 
  
  // The regression coefficient on x1
  real b1; 
}

// The model to be estimated. ------------------- 
model {
  // The priors
  b0 ~ normal(0, 2);
  b1 ~ normal(0, 2);

  // The likelihood
  y ~ bernoulli_logit(b0 + b1*x1); 
}

// Generated quantitites. -------------------
generated quantities {
  // Variable declarations
  // A value is generated after each sample.
  real b0_prior;
  real b1_prior;

  // For priors
  b0_prior = normal_rng(0, 2);
  b1_prior = normal_rng(0, 2);
}

// The program must end with a blank line! Comments aren't blank lines.
