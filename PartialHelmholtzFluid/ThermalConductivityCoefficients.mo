within HelmholtzFluids.PartialHelmholtzFluid;
record ThermalConductivityCoefficients
  Temperature reducingTemperature
    "reducing temperature (very close to critical temperature)";
  Density reducingDensity "reducing density (very close to critical density";
  constant Real[:,2] lambda_0_coeffs "coeffs for dilute contribution";
  constant Real[:,3] lambda_r_coeffs "coeffs for residual contribution";

  Real nu "universal exponent";
  Real gamma "universal exponent";
  Real R0 "universal amplitude";
  Real z "universal exponent, used for viscosity";
  Real c "constant in viscosity, often set to 1";
  Real xi_0 "amplitude";
  Real Gamma_0 "amplitude";
  Real qd_inverse "modified effective cutoff parameter";
  Temperature T_ref "reference temperature";

end ThermalConductivityCoefficients;