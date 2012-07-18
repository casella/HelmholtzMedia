within HelmholtzMedia.Examples.Tests.Validation;
model Validate_Derivatives_SaturationBoundary
  "compare analytical derivatives to numerical derivatives"

  package Medium = HelmholtzFluids.Butane;
  // choose subcritical T
  parameter Medium.Temperature T=135;

  Medium.SaturationProperties sat;
  Medium.HelmholtzDerivs fl;
  Medium.HelmholtzDerivs fv;
  Medium.SaturationProperties sat_Tplus;
  Medium.SaturationProperties sat_Tminus;
  Medium.SaturationProperties sat_pplus;
  Medium.SaturationProperties sat_pminus;

  // Enthalpy derivatives
  Medium.Types.DerEnthalpyByTemperature dhT_liq_analytical;
  Medium.Types.DerEnthalpyByTemperature dhT_liq_numerical;
  Medium.Types.DerEnthalpyByPressure dhp_liq_analytical;
  Medium.Types.DerEnthalpyByPressure dhp_liq_numerical;
  Medium.Types.DerEnthalpyByPressure dhp_vap_analytical;
  Medium.Types.DerEnthalpyByPressure dhp_vap_numerical;
  // Entropy derivatives
  Medium.Types.DerEntropyByDensity dsdT;
  Medium.Types.DerEntropyByTemperature dsTd;
  Medium.Types.DerEntropyByTemperature dsTp;
  Medium.Types.DerEntropyByPressure dspT;
  Medium.Types.DerEntropyByTemperature dsT_liq_analytical;
  Medium.Types.DerEntropyByTemperature dsT_liq_numerical;
  // Medium.Types.DerEntropyByTemperature dsT_vap_analytical;
  // Medium.Types.DerEntropyByTemperature dsT_vap_numerical;
  //saturated liquid heat capacity
  Medium.Types.DerEnthalpyByTemperature c_sigma_Span2000;
  Medium.Types.DerEnthalpyByTemperature c_sigma_analytical;
  Medium.Types.DerEnthalpyByTemperature c_sigma_numerical;
  // Energy derivatives
  // Medium.Types.DerEnergyByDensity dudT_analytical;
  // Medium.Types.DerEnergyByDensity dudT_numerical;
  // Medium.Types.DerEnergyByTemperature duTd_analytical;
  // Medium.Types.DerEnergyByTemperature duTd_numerical;
  // Gibbs derivatives
  // Medium.Types.DerEnergyByDensity dgdT_analytical;
  // Medium.Types.DerEnergyByDensity dgdT_numerical;
  // Medium.Types.DerEnergyByTemperature dgTd_analytical;
  // Medium.Types.DerEnergyByTemperature dgTd_numerical;
  // Density derivatives
  Medium.DerDensityByTemperature ddT_liq_analytical;
  Medium.DerDensityByTemperature ddT_liq_numerical;
  Medium.DerDensityByTemperature ddT_vap_analytical;
  Medium.DerDensityByTemperature ddT_vap_numerical;
  Medium.DerDensityByPressure ddp_liq_analytical;
  Medium.DerDensityByPressure ddp_liq_numerical;
  Medium.DerDensityByPressure ddp_vap_analytical;
  Medium.DerDensityByPressure ddp_vap_numerical;

equation
  sat=Medium.setSat_T(T=T);
  fl=Medium.setHelmholtzDerivs(T=T, d=sat.liq.d, phase=1);
  fv=Medium.setHelmholtzDerivs(T=T, d=sat.vap.d, phase=1);
  sat_Tplus = Medium.setSat_T(T=1.0001*T);
  sat_Tminus = Medium.setSat_T(T=0.9999*T);
  sat_pplus = Medium.setSat_p(p=1.0001*sat.psat);
  sat_pminus = Medium.setSat_p(p=0.9999*sat.psat);

  Modelica.Utilities.Streams.print("====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|====|");

  Modelica.Utilities.Streams.print("Density");
  // check (dd/dT)@liq
  ddT_liq_analytical = Medium.density_derT_p(state=sat.liq) +Medium.density_derp_T(state=sat.liq)*Medium.saturationPressure_derT(T=sat.Tsat, sat=sat);
  ddT_liq_numerical = (sat_Tplus.liq.d - sat_Tminus.liq.d)/(sat_Tplus.liq.T - sat_Tminus.liq.T);
  Modelica.Utilities.Streams.print("(dd/dT)@liq analytical= " + String(ddT_liq_analytical));
  Modelica.Utilities.Streams.print("(dd/dT)@liq  numerical= " + String(ddT_liq_numerical));
  // check (dd/dT)@vap
  ddT_vap_analytical = Medium.density_derT_p(state=sat.vap) +Medium.density_derp_T(state=sat.vap)*Medium.saturationPressure_derT(T=sat.Tsat, sat=sat);
  ddT_vap_numerical = (sat_Tplus.vap.d - sat_Tminus.vap.d)/(sat_Tplus.vap.T - sat_Tminus.vap.T);
  Modelica.Utilities.Streams.print("(dd/dT)@vap analytical= " + String(ddT_vap_analytical));
  Modelica.Utilities.Streams.print("(dd/dT)@vap  numerical= " + String(ddT_vap_numerical));
  // check (dd/dp)@liq
  ddp_liq_analytical = Medium.density_derp_T(state=sat.liq) +Medium.density_derT_p(state=sat.liq)*Medium.saturationTemperature_derp(p=sat.psat, sat=sat);
  ddp_liq_numerical = (sat_pplus.liq.d - sat_pminus.liq.d)/(sat_pplus.liq.p - sat_pminus.liq.p);
  Modelica.Utilities.Streams.print("(dd/dp)@liq analytical= " + String(ddp_liq_analytical));
  Modelica.Utilities.Streams.print("(dd/dp)@liq  numerical= " + String(ddp_liq_numerical));
  // check (dd/dp)@vap
  ddp_vap_analytical = Medium.density_derp_T(state=sat.vap) +Medium.density_derT_p(state=sat.vap)*Medium.saturationTemperature_derp(p=sat.psat, sat=sat);
  ddp_vap_numerical = (sat_pplus.vap.d - sat_pminus.vap.d)/(sat_pplus.vap.p - sat_pminus.vap.p);
  Modelica.Utilities.Streams.print("(dd/dp)@vap analytical= " + String(ddp_vap_analytical));
  Modelica.Utilities.Streams.print("(dd/dp)@vap  numerical= " + String(ddp_vap_numerical));

  Modelica.Utilities.Streams.print(" ");
  Modelica.Utilities.Streams.print("Enthalpy");
  // check (dh/dT)@liq
  dhT_liq_analytical = Medium.specificHeatCapacityCp(state=sat.liq) +Medium.isothermalThrottlingCoefficient(state=sat.liq)*Medium.saturationPressure_derT(T=sat.Tsat, sat=sat);
  dhT_liq_numerical = (sat_Tplus.liq.h-sat_Tminus.liq.h)/(sat_Tplus.liq.T-sat_Tminus.liq.T);
  Modelica.Utilities.Streams.print("(dh/dT)@liq analytical= " + String(dhT_liq_analytical));
  Modelica.Utilities.Streams.print("(dh/dT)@liq  numerical= " + String(dhT_liq_numerical));
  // check (dh/dp)@liq
  dhp_liq_analytical = Medium.dBubbleEnthalpy_dPressure(sat=sat);
  dhp_liq_numerical = (sat_pplus.liq.h-sat_pminus.liq.h)/(sat_pplus.liq.p-sat_pminus.liq.p);
  Modelica.Utilities.Streams.print("(dh/dp)@liq analytical= " + String(dhp_liq_analytical));
  Modelica.Utilities.Streams.print("(dh/dp)@liq  numerical= " + String(dhp_liq_numerical));
  // check (dh/dp)@vap
  dhp_vap_analytical = Medium.dDewEnthalpy_dPressure(sat=sat);
  dhp_vap_numerical = (sat_pplus.vap.h-sat_pminus.vap.h)/(sat_pplus.vap.p-sat_pminus.vap.p);
  Modelica.Utilities.Streams.print("(dh/dp)@vap analytical= " + String(dhp_vap_analytical));
  Modelica.Utilities.Streams.print("(dh/dp)@vap  numerical= " + String(dhp_vap_numerical));

  Modelica.Utilities.Streams.print(" ");
  Modelica.Utilities.Streams.print("Entropy");
  // check (ds/dT)@liq
  dsTd = fl.R/T*(-fl.tau^2*(fl.itt+fl.rtt));
  dsdT = fl.R/sat.liq.d*(-(1+fl.delta*fl.rd)+(0+fl.tau*fl.delta*fl.rtd));
  dsTp = dsTd-dsdT*Medium.pressure_derT_d(state=sat.liq)/Medium.pressure_derd_T(state=sat.liq);
  dspT = dsdT/Medium.pressure_derd_T(state=sat.liq);
  dsT_liq_analytical = dsTp+dspT*Medium.saturationPressure_derT(T=T);
  dsT_liq_numerical = (sat_Tplus.liq.s-sat_Tminus.liq.s)/(sat_Tplus.liq.T-sat_Tminus.liq.T);
  Modelica.Utilities.Streams.print("(ds/dT)@liq analytical= " + String(dsT_liq_analytical));
  Modelica.Utilities.Streams.print("(ds/dT)@T=liq  numerical= " + String(dsT_liq_numerical));
  // check (ds/dT)@vap
  /*dsTd = fv.R/T*(-fv.tau^2*(fv.itt+fv.rtt));
  dsdT = fv.R/sat.vap.d*(-(1+fv.delta*fv.rd)+(0+fv.tau*fv.delta*fv.rtd));
  dsTp = dsTd-dsdT*Medium.pressure_derT_d(state=sat.vap)/Medium.pressure_derd_T(state=sat.vap);
  dspT = dsdT/Medium.pressure_derd_T(state=sat.vap);
  dsT_vap_analytical = dsTp+dspT*Medium.saturationPressure_derT(T=T);
  dsT_vap_numerical = (sat_Tplus.vap.s-sat_Tminus.vap.s)/(sat_Tplus.vap.T-sat_Tminus.vap.T);
  Modelica.Utilities.Streams.print("(ds/dT)@vap analytical= " + String(dsT_vap_analytical));
  Modelica.Utilities.Streams.print("(ds/dT)@T=vap  numerical= " + String(dsT_vap_numerical));
  */

  Modelica.Utilities.Streams.print(" ");
   Modelica.Utilities.Streams.print("saturated liquid heat capacity");
  // check (c_sigma)@liq
  c_sigma_Span2000 = Medium.specificHeatCapacityCv(state=sat.liq) - T*Medium.pressure_derT_d(state=sat.liq)/(sat.liq.d^2)*ddT_liq_analytical;
  c_sigma_analytical = T*dsT_liq_analytical;
  c_sigma_numerical = T*dsT_liq_numerical;
  Modelica.Utilities.Streams.print("(c_sigma)@liq Span= " + String(c_sigma_Span2000));
  Modelica.Utilities.Streams.print("(c_sigma)@liq analytical= " + String(c_sigma_analytical));
  Modelica.Utilities.Streams.print("(c_sigma)@liq numerical= " + String(c_sigma_numerical));

  // Modelica.Utilities.Streams.print(" ");
  // Modelica.Utilities.Streams.print("internal Energy");
  // check (du/dd)@T=const
  // dudT_analytical = f.R*T/d*f.tau*f.delta*f.rtd;
  // dudT_numerical = (d_plus.u-d_minus.u)/(d_plus.d-d_minus.d);
  // Modelica.Utilities.Streams.print("(du/dd)@T=const analytical= " + String(dudT_analytical));
  // Modelica.Utilities.Streams.print("(du/dd)@T=const  numerical= " + String(dudT_numerical));
  // check (du/dT)@d=const
  // duTd_analytical = Medium.specificHeatCapacityCv(state=state, f=f);
  // duTd_numerical = (T_plus.u-T_minus.u)/(T_plus.T-T_minus.T);
  // Modelica.Utilities.Streams.print("(du/dT)@d=const analytical= " + String(duTd_analytical));
  // Modelica.Utilities.Streams.print("(du/dT)@d=const  numerical= " + String(duTd_numerical));

  // Modelica.Utilities.Streams.print(" ");
  // Modelica.Utilities.Streams.print("Gibbs energy");
  // check (dg/dd)@T=const
  // dgdT_analytical = f.R*T/d*(1+2*f.delta*f.rd + f.delta^2*f.rdd);
  // dgdT_numerical = ((d_plus.h-d_plus.T*d_plus.s)-(d_minus.h-d_minus.T*d_minus.s))/(d_plus.d-d_minus.d);
  // Modelica.Utilities.Streams.print("(dg/dd)@T=const analytical= " + String(dgdT_analytical));
  // Modelica.Utilities.Streams.print("(dg/dd)@T=const  numerical= " + String(dgdT_numerical));
  // check (dg/dT)@d=const
  // dgTd_analytical = f.R*(f.i+f.r + 1+f.delta*f.rd -f.tau*(f.it+f.rt) - f.tau*f.delta*f.rtd);
  // dgTd_numerical = ((T_plus.h-T_plus.T*T_plus.s)-(T_minus.h-T_minus.T*T_minus.s))/(T_plus.T-T_minus.T);
  // Modelica.Utilities.Streams.print("(dg/dT)@d=const analytical= " + String(dgTd_analytical));
  // Modelica.Utilities.Streams.print("(dg/dT)@d=const  numerical= " + String(dgTd_numerical));

  annotation (experiment(NumberOfIntervals=1), __Dymola_experimentSetupOutput);
end Validate_Derivatives_SaturationBoundary;
