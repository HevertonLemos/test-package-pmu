%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the PMU reference to Out-of-band test steady state.
%
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% data_lenght = ;
% lenght_frame_step = ;
% number_of_step = number of step;
%
%
% Return
% phase: struct of the PMU reference to magnitude steady state.
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phase = pmu_reference_out_of_band_steady(V_mag, I_mag, f0, fps, data_lenght, lenght_frame_step, number_of_step)

  VC = VB = VA = [];
  IC = IB = IA = [];

  f_delta = (f0 + (0.1*(fps/2))) - (f0 - (0.1*(fps/2)));
  step_f = (f_delta)/(number_of_step-1);
  f_tmp = f0 - (0.1*(fps/2));

  ini = 1;
  finish = lenght_frame_step;
  for i=1:number_of_step
    freq(ini:finish) = f_tmp;

    % Initial angles values
    ang_A = 0.0;
    ang_B = -120.0;
    ang_C = 120.0;
    tmp_VA = ss_generic(V_mag, ang_A, f_tmp, fps, lenght_frame_step);
    tmp_VB = ss_generic(V_mag, ang_B, f_tmp, fps, lenght_frame_step);
    tmp_VC = ss_generic(V_mag, ang_C, f_tmp, fps, lenght_frame_step);

    VA = cat(2, VA, tmp_VA);
    VB = cat(2, VB, tmp_VB);
    VC = cat(2, VC, tmp_VC);

    tmp_IA = ss_generic(I_mag, ang_A, f_tmp, fps, lenght_frame_step);
    tmp_IB = ss_generic(I_mag, ang_B, f_tmp, fps, lenght_frame_step);
    tmp_IC = ss_generic(I_mag, ang_C, f_tmp, fps, lenght_frame_step);

    IA = cat(2, IA, tmp_IA);
    IB = cat(2, IB, tmp_IB);
    IC = cat(2, IC, tmp_IC);

    f_tmp = f_tmp + step_f;
    ini = ini + lenght_frame_step;
    finish = finish + lenght_frame_step;
  endfor

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
