%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the PMU reference to bandwidth test dynamic state.
%
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% t = time of the acquisition of the data (in seconds);
% pmu_class = classe of measurement: 1 (Protection class) or 2 (Measurement class);
% step_mag = magnitude step to bandwidth test (default 0.1);
% step_ang = angle  step to bandwidth test (default 0.1);
%
% Return
% phase: struct of the PMU reference to bandwidth dynamic state.
%
%  Heverton de Lemos 26/09/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phase = pmu_reference_bandwidth_dynamic(V_mag, I_mag, f0, fps, t, pmu_class, step_mag, step_ang)
  convert_radios_to_angle = (180/pi);
  two_pi = (2 * pi);
  w0 = two_pi * f0;
  VC = VB = VA = [];
  IC = IB = IA = [];
  rocof = [];

  max_freq_step = 0;
  if pmu_class == 1
    if (fps/10) < 2
      max_freq_step = (fps/10);
    else
      max_freq_step = 2;
    endif
  elseif pmu_class == 2
    if (fps/5) < 5
      max_freq_step = (fps/5);
    else
      max_freq_step = 5;
    endif
  else
    phase = -1;
    return;
  endif

  step_freq = 0.2;
  number_of_step = ceil(max_freq_step/step_freq);
  freq_tmp = 0.1;

  lenght_frame_step = ceil( ceil(t * fps)/number_of_step );
  lenght_time_step = (t/number_of_step) / lenght_frame_step;

  initial_frame_of_step = 1;
  frame_time = 0;
  finish_frame_of_step = lenght_frame_step;
  for i=1:number_of_step
    for j=initial_frame_of_step:finish_frame_of_step
      w = two_pi * freq_tmp;
      wnT = w * j * frame_time;
      cos_wnT = cos(wnT);
      cos_wnT_minus_pi = cos(wnT-pi);

      freq(j) = (w0/two_pi) - step_ang * (w/two_pi) * sin (wnT - pi);
      rocof(j)= -step_ang * (w^2 / two_pi) * cos_wnT_minus_pi;

      VA(1,j) = V_mag * ( 1.0 + step_mag * cos_wnT );
      IA(1,j) = I_mag * ( 1.0 + step_mag * cos_wnT );

      ang_tmp = convert_radios_to_angle * (step_ang * cos_wnT_minus_pi);
      IA(2,j) = VA(2,j) = wrap_angle( ang_tmp);
      IB(2,j) = VB(2,j) = wrap_angle( -120 + ang_tmp );
      IC(2,j) = VC(2,j) = wrap_angle( 120 + ang_tmp );


      % w = (two_pi * f0 * frame_time);
      % wt = (two_pi * f0 * frame_time);
      % cos_wt = cos(wt);
      % cos_w = cos(wt);
      % w0 = (two_pi * f0);
      % w2 = (two_pi * freq_tmp);
      % cos_wt_minus_pi = cos(wt-pi);
      % %ang_tmp = convert_radios_to_angle *( w + (step_ang * cos_wt_minus_pi) );
      % ang_tmp = convert_radios_to_angle *((step_ang * cos_wt_minus_pi));
      %
      % % freq(j) = (w0/two_pi) - step_ang * (w2/two_pi) * sin (wt - pi);
      % freq(j) = (w0/two_pi) - step_ang * (w0/two_pi) * sin (wt - pi);
      % % rocof(j)= (-step_ang * (w^2 / two_pi)) * cos_wt_minus_pi;
      % rocof(j)= -step_ang * (w0^2 / two_pi) * cos_wt_minus_pi;
      %
      % % VA(1,j) = V_mag * ( 1.0 + ( step_mag * cos_wt ) );
      % VA(1,j) = V_mag * ( 1.0 + ( step_mag * cos_wt ) );
      % IA(1,j) = I_mag * ( 1.0 + ( step_mag * cos_wt ) );
      %
      % IA(2,j) = VA(2,j) = wrap_angle( ang_tmp);
      % IB(2,j) = VB(2,j) = wrap_angle( -120 + ang_tmp );
      % IC(2,j) = VC(2,j) = wrap_angle( 120 + ang_tmp );
      %
      frame_time += lenght_time_step;
    endfor

    freq_tmp += step_freq;
    initial_frame_of_step += lenght_frame_step;
    finish_frame_of_step += lenght_frame_step;
  endfor

  VC(1,:) = VB(1,:) = VA(1,:);
  IC(1,:) = IB(1,:) = IA(1,:);
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
