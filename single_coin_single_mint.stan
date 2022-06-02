//
// Single coin from a single mint
//
// Notes:
//   This is how you write a comment in Stan.
//   Example adapted from Kruschke, 2015
//
// Andrew L. Cohen
// May 2, 2020
// © 2022, Andrew L. Cohen

// The input data. -------------------
// The data block is for the declaration of variables that are read in as data.
// These must match the variables sent into sampling from R.
data {
  // Total number of coin flips. A single integer > 0.
  // All lines must end with a semi-colon
  int<lower=0> Nf; 
  
  // An integer array of length N of coin flip outcomes (0=tails, 1=heads). 
  // (Integers must be stored in arrays. Vectors and matrices only store reals.)
  int y[Nf]; 
}

// The parameters accepted by the model. -------------------
// The parameters in the program block are the parameters being sampled by Stan.
parameters {
  // theta is the coin bias. A real between 0 and 1.
  real<lower=0, upper=1> theta; 
}

// The model to be estimated. ------------------- 
//   All variables must be declared someone prior to use.
//   The order matters.
model {
  // The prior on theta. For simplicity, distributed as a "flat" beta.
  theta ~ beta(1, 1);
  
  // The likelihood is a Bernoulli distribution with parameter theta.
  // Note that y is a vector. So, EACH of the N y outcomes is Bernoulli.
  y ~ bernoulli(theta); 
}

// Generated quantitites. -------------------
// Nothing in the generated quantities block affects the sampled parameter values. 
// The block is executed only after a sample has been generated.
// Not needed to run the model.
generated quantities {
  // Variable declarations
  // A value is generated after each sample.
  real<lower=0, upper=1> theta_prior;
  int y_pred;
  
  // For prior
  theta_prior = beta_rng(1, 1);

  // For posterior predictive check
  // Samples of y taken from the estimated theta
  //   drawn randomly from a Bernoulli distribution.
  y_pred = bernoulli_rng(theta);  
}

// The program must end with a blank line! Comments aren't blank lines.
