//
// Multiple coins from a single mint, free kappa
//
// Notes:
//   Example adapted from Kruschke, 2015
//
// Andrew L. Cohen
// May 6, 2020
// © 2022, Andrew L. Cohen

// data -------------------
data {
  // Number of coins.
  int<lower=0> Nc;
  
  // Total number of coin flips. 
  int<lower=0> Nf[Nc]; 
  
  // Flip outcomes (0=tails, 1=heads). Nc x Nf.
  int y[Nc, max(Nf)]; 
}

// parameters -------------------
parameters {
  // omega is the mint bias. All coins are from the same mint.
  real<lower=0, upper=1> omega; 
  
  // kappa minus two because kappa >= 2, but the prior starts at 0
  // See kappa in transformed parameters.
  real<lower=0> kappa_minus_two;
  
  // theta is the coin bias. Each coin has its own bias. 
  real<lower=0, upper=1> theta[Nc]; // As an array
  // vector<lower=0, upper=1>[Nc] theta; // As a vector
}

// transformed parameters -------------------
transformed parameters {
  // kappa determines the uncertainty in the mint bias.
  // Lower = more uncertainty.
  real<lower=2> kappa;
  kappa = kappa_minus_two + 2;
}

// model ------------------- 
//   All variables must be declared someone prior to use.
//   The order matters.
model {
  // The prior on the mint bias omega.
  omega ~ beta(1, 1);

  // The prior on the mint bias uncertainty kappa.
  // gamma(shape, rate).
  // Mean = shape/rate, sd = sqrt(shape/rate^2)
  kappa_minus_two ~ gamma(.01, .01); // Mean = 1, sd = 10
  // kappa_minus_two ~ gamma(100, 10); // Mean = 10, sd = 1
  // kappa_minus_two ~ gamma(1, 1); // Mean = 1, sd = 1
  // kappa_minus_two ~ gamma(.111, .111); // Mean = 1, sd = 3

  // The prior on coin bias theta. 
  theta ~ beta(omega*(kappa - 2) + 1, (1 - omega)*(kappa - 2) + 1);
  
  // The likelihood is a Bernoulli distribution with parameter theta.
  // y[c] is the outcomes for coin c.
  for (c in 1:Nc) {
    y[c,1:Nf[c]] ~ bernoulli(theta[c]); 
  }
}

// generated quantities -------------------
generated quantities {
  // Variable declarations
  real<lower=0> kappa_minus_two_prior;
  real<lower=2> kappa_prior;
  real<lower=0, upper=1> omega_prior;
  real<lower=0, upper=1> theta_prior[Nc];
  int y_pred[Nc];
  
  // For priors
  omega_prior = beta_rng(1, 1);
  kappa_minus_two_prior = gamma_rng(.01, .01);
  kappa_prior = kappa_minus_two_prior + 2;
  // kappa_prior = pareto_rng(1, 1.5);
  for (c in 1:Nc) {
    theta_prior[c] = beta_rng(omega_prior*(kappa - 2) + 1, (1 - omega_prior)*(kappa - 2) + 1);
  }
  
  // For posterior predictive check
  for (c in 1:Nc) {
    y_pred[c] = bernoulli_rng(theta[c]);
  }
}

// The program must end with a blank line! Comments aren't blank lines.
