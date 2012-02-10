within HelmholtzFluids.PartialHelmholtzFluid;
function ai_tau_tau "ideal part of dimensionless Helmholtz energy"

  input Real delta;
  input Real tau;
  output Real alpha_ideal_tau_tau
    "ideal part of dimensionless Helmholtz energy";

protected
  Integer nIdeal=size(helmholtzCoefficients.ideal, 1);
  Real[nIdeal, 2] n=helmholtzCoefficients.ideal;

algorithm
  alpha_ideal_tau_tau :=
    - n[1,1]/tau^2
    - sum(n[i,1]*(-n[i,2])^2*exp(n[i,2]*tau)*(1 - exp(n[i,2]*tau))^(-2) for i in 4:nIdeal);
end ai_tau_tau;
