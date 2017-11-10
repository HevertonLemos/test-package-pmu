%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the PMU reference to test magnitude steady state.
%
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% data_lenght = ;
% lenght_frame_step = ;
% pmu_class = classe of measurement: 1 (Protection class) or 2 (Measurement class);
% number_of_step = quantity of the steps (integer);
%
% Return
% phase: struct of the PMU reference to magnitude steady state.
%
%  Heverton de Lemos 24/09/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phase = pmu_reference_mag_steady(V_mag, I_mag, f0, fps, data_lenght, lenght_frame_step, pmu_class, number_of_step)
  VC = VB = VA = [];
  IC = IB = IA = [];

  if pmu_class == 1
    percent_step_V = (120.0 - 80.0)/(number_of_step-1);
    V_tmp = V_mag * 0.80;
  elseif pmu_class == 2
    percent_step_V = (120.0 - 10)/(number_of_step-1);
    V_tmp = V_mag * 0.10;
  else
    phase = -1;
    return;
  endif
  percent_step_I = (200.0 - 10)/(number_of_step-1);
  I_tmp = I_mag * 0.10;

  for i=1:number_of_step
    tmp_VA = ss_generic(V_tmp, 0, f0, fps, lenght_frame_step);
    tmp_VB = ss_generic(V_tmp, -120, f0, fps, lenght_frame_step);
    tmp_VC = ss_generic(V_tmp, 120, f0, fps, lenght_frame_step);
    VA = cat(2,VA,tmp_VA);
    VB = cat(2,VB,tmp_VB);
    VC = cat(2,VC,tmp_VC);

    tmp_IA = ss_generic(I_tmp, 0, f0, fps, lenght_frame_step);
    tmp_IB = ss_generic(I_tmp, -120, f0, fps, lenght_frame_step);
    tmp_IC = ss_generic(I_tmp, 120, f0, fps, lenght_frame_step);
    IA = cat(2,IA,tmp_IA);
    IB = cat(2,IB,tmp_IB);
    IC = cat(2,IC,tmp_IC);

    V_tmp = V_tmp + (V_mag * percent_step_V)/100;
    I_tmp = I_tmp + (I_mag * percent_step_I)/100;
  endfor

  freq(1:data_lenght) = f0;
  rocof(1:data_lenght) = 0.0;

  phase = struct();
  phase.("VA") = VA;
  phase.("VB") = VB;
  phase.("VC") = VC;
  phase.("VS1") = VA;
  phase.("IA") = IA;
  phase.("IB") = IB;
  phase.("IC") = IC;
  phase.("IS1") = IA;
  phase.("frequency") = freq;
  phase.("rocof") = rocof;

  return;
endfunction
