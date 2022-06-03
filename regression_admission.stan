//
// Predict Chance.of.Admit from LOR, GRE.Score, CGPA, TOEFL.Score, Research, University.Rating, and SOP
//
// Andrew L. Cohen
// May 15, 2020

// The input data. -------------------
data {
  // Total number data observations.
  int<lower=0> N; 
  
  // An array of length N of predictor values.
  vector[N] lor;
  vector[N] gre;
  vector[N] cgpa;
  vector[N] toefl;
  vector[N] research;
  vector[N] univ_rating;
  vector[N] sop;
  
  // An array of length N of outcomes. 
  real<lower=0,upper=1> admit[N];
}

// The parameters accepted by the model. -------------------
parameters {
  // The regression constant
  real b_int; 
  
  // The regression coefficient on x1 and x2
  real b_lor;
  real b_gre;
  real b_cgpa; 
  real b_toefl;
  real b_research;
  real b_univ_rating;
  real b_sop;

  // The standard deviation
  real<lower=0> sigma; 
}

// The model to be estimated. ------------------- 
model {
  // The priors
  b_int ~ normal(0, 2);
  b_lor ~ normal(0, 2);
  b_gre ~ normal(0, 2);
  b_cgpa ~ normal(0, 2);
  b_toefl ~ normal(0, 2);
  b_research ~ normal(0, 2);
  b_univ_rating ~ normal(0, 2);
  b_sop ~ normal(0, 2);
  sigma ~ gamma(3, 1.5);

  // The likelihood
  admit ~ normal(b_int + b_lor*lor + b_gre*gre + b_cgpa*cgpa + b_toefl*toefl + b_research*research + b_univ_rating*univ_rating + b_sop*sop, sigma);
}

// Generated quantitites. -------------------
generated quantities {
  // Variable declarations
  // A value is generated after each sample.
  real mu[N];
  real resid[N];
  
  // Means
  for (i in 1:N) {
    mu[i] = b_int + b_lor*lor[i] + b_gre*gre[i] + b_cgpa*cgpa[i] + b_toefl*toefl[i] + b_research*research[i] + b_univ_rating*univ_rating[i] + b_sop*sop[i];
  }
  
  // Residuals
  for (i in 1:N) {
    resid[i] = admit[i] - mu[i]; 
  }
}

// The program must end with a blank line! Comments aren't blank lines.
