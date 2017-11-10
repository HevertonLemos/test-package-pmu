%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the PMU reference to test hamonic steady state.
%
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% data_lenght = ;
%
% Return
% phase: struct of the PMU reference to magnitude steady state.
%
%  Heverton de Lemos 14/09/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phase = pmu_reference_harmonic_steady(V_mag, I_mag, f0, fps, data_lenght)

  freq(1:data_lenght) = f0;
  rocof(1:data_lenght) = 0.0;

  phase = struct();
  phase.("VA") = ss_generic(V_mag, 0, f0, fps, data_lenght);
  phase.("VB") = ss_generic(V_mag, -120, f0, fps, data_lenght);
  phase.("VC") = ss_generic(V_mag, 120, f0, fps, data_lenght);
  phase.("VS1") = phase.VA;
  phase.("IA") = ss_generic(I_mag, 0, f0, fps, data_lenght);
  phase.("IB") = ss_generic(I_mag, -120, f0, fps, data_lenght);
  phase.("IC") = ss_generic(I_mag, 120, f0, fps, data_lenght);
  phase.("IS1") = phase.IA;
  phase.("frequency") = freq;
  phase.("rocof") = rocof;

  return;
endfunction
