within HelmholtzMedia.Interfaces.PartialHelmholtzMedium.EoS;
function f_rtt "residual part of dimensionless Helmholtz energy"

  input Real delta;
  input Real tau;
  output Real f_residual_tau_tau
    "residual part of dimensionless Helmholtz energy";

protected
  final constant Integer nPoly = size(helmholtzCoefficients.residualPoly,1);
  final constant Integer nBwr = size(helmholtzCoefficients.residualBwr,1);
  final constant Integer nGauss = size(helmholtzCoefficients.residualGauss,1);
  final constant Integer nNonAna = size(helmholtzCoefficients.residualNonAnalytical,1);

  final constant Real[nPoly,3] p = helmholtzCoefficients.residualPoly;
  final constant Real[nBwr,4] b = helmholtzCoefficients.residualBwr;
  final constant Real[nGauss,9] g = helmholtzCoefficients.residualGauss;
  final constant Real[nNonAna,12] a = helmholtzCoefficients.residualNonAnalytical;

  Real[nNonAna] Psi = {exp(-a[i,9]*(delta-1)^2 -a[i,10]*(tau-1)^2) for i in 1:nNonAna} "Psi";
  Real[nNonAna] Theta = {(1-tau) + a[i,8]*((delta-1)^2)^(0.5/a[i,7]) for i in 1:nNonAna} "Theta";
  Real[nNonAna] Dis = {Theta[i]^2 +a[i,11]*((delta-1)^2)^a[i,12] for i in 1:nNonAna} "Distance function";
  Real[nNonAna] Disb = {Dis[i]^a[i,6] for i in 1:nNonAna} "Distance function to the power of b";

  Real[nNonAna] Psi_t = {-a[i,10]*(2*tau-2)*Psi[i] for i in 1:nNonAna};
  Real[nNonAna] Theta_t = {-1 for i in 1:nNonAna};
  Real[nNonAna] Dis_t = {-2*Theta[i] for i in 1:nNonAna};
  Real[nNonAna] Disb_t = {if Dis[i]<>0 then a[i,6]*Dis[i]^(a[i,6]-1)*Dis_t[i] else 0 for i in 1:nNonAna};

  Real[nNonAna] Psi_tt = {2*a[i,10]*(2*a[i,10]*(tau-1)^2-1)*Psi[i] for i in 1:nNonAna};
  //Real[nNonAna] Theta_tt = {0 for i in 1:nNonAna};
  Real[nNonAna] Dis_tt = {2 for i in 1:nNonAna};
  Real[nNonAna] Disb_tt = {if Dis[i]<>0 then a[i,6]*(a[i,6]*Dis_t[i]^2 + Dis[i]*Dis_tt[i] - Dis_t[i]^2)*Dis[i]^(a[i,6]-2)
                                        else a[i,6]*(a[i,6]*Dis_t[i]^2 + Dis[i]*Dis_tt[i] - Dis_t[i]^2)*Modelica.Constants.inf for i in 1:nNonAna};

algorithm
  //Modelica.Utilities.Streams.print(Modelica.Math.Vectors.toString(Disb_tt));
  f_residual_tau_tau :=
      sum(p[i,1]*p[i,2]*(p[i,2] - 1)*delta^p[i,3]*tau^(p[i,2] - 2) for i in 1:nPoly)
    + sum(b[i,1]*b[i,2]*(b[i,2] - 1)*delta^b[i,3]*tau^(b[i,2] - 2)*exp(-delta^b[i,4]) for i in 1:nBwr)
    + sum(g[i,1]*delta^g[i,3]*tau^g[i,2]*exp(g[i,6]*(delta - g[i,9])^2 + g[i,7]*(tau - g[i,8])^2)*((g[i,2]/tau + 2*g[i,7]*(tau - g[i,8]))^2 - g[i,2]/tau^2 + 2*g[i,7]) for i in 1:nGauss)
    + sum(a[i,1]*delta*(Disb[i]*Psi_tt[i] + Psi[i]*Disb_tt[i] + 2*Disb_t[i]*Psi_t[i]) for i in 1:nNonAna);

end f_rtt;
