%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the PMU reference to frequency test steady state.
%
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% lenght_frame_step = ;
% number_of_step = number of step;
% step_freq = ;
%
% Return
% phase: struct of the PMU reference to frequency steady state.
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phase = pmu_reference_freq_steady(V_mag, I_mag, freq_tmp, fps, lenght_frame_step, number_of_step, step_freq)
  VC = VB = VA = [];
  IC = IB = IA = [];

  initial_frame_of_step = 1;
  finish_frame_of_step = lenght_frame_step;
  for i=1:number_of_step
    freq(initial_frame_of_step:finish_frame_of_step) = freq_tmp;
    rocof(initial_frame_of_step:finish_frame_of_step) = 0.0;

    % Initial angles values
    ang_A = 0.0;
    ang_B = -120.0;
    ang_C = 120.0;
    tmp_VA = ss_generic(V_mag, ang_A, freq_tmp, fps, lenght_frame_step);
    tmp_VB = ss_generic(V_mag, ang_B, freq_tmp, fps, lenght_frame_step);
    tmp_VC = ss_generic(V_mag, ang_C, freq_tmp, fps, lenght_frame_step);

    VA = cat(2, VA, tmp_VA);
    VB = cat(2, VB, tmp_VB);
    VC = cat(2, VC, tmp_VC);

    tmp_IA = ss_generic(I_mag, ang_A, freq_tmp, fps, lenght_frame_step);
    tmp_IB = ss_generic(I_mag, ang_B, freq_tmp, fps, lenght_frame_step);
    tmp_IC = ss_generic(I_mag, ang_C, freq_tmp, fps, lenght_frame_step);

    IA = cat(2, IA, tmp_IA);
    IB = cat(2, IB, tmp_IB);
    IC = cat(2, IC, tmp_IC);

    freq_tmp = freq_tmp + step_freq;
    initial_frame_of_step = initial_frame_of_step + lenght_frame_step;
    finish_frame_of_step = finish_frame_of_step + lenght_frame_step;
  endfor

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
