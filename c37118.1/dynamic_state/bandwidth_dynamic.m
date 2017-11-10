%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performed the bandwidth test in dynamic state.
%
% pmu_test = data received of the pmu about test;
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% t = time of the acquisition of the data (in seconds);
% pmu_class = classe of measurement: 1 (Protection class) or 2 (Measurement class);
%
% Return
% files: reports (.txt) and graph (.png) witch erros;
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bandwidth_dynamic(pmu_test, V_mag, I_mag, f0, fps, t, pmu_class)

  % data_lenght = ceil(t * fps);
  % number_of_step = ceil(freq_delta/step_freq) + 1;
  % lenght_frame_step = ceil(data_lenght/number_of_step);
  disp(strcat("Start: ", asctime( localtime(time()) ), "\n") );
  reference = pmu_reference_bandwidth_dynamic(V_mag, I_mag, f0, fps, t, pmu_class, 0.1, 0.0);
  pmu = convert_to_struct(pmu_test);

  [mag_error, ang_error, tve, fe, rfe] = calc_pmu_erros(reference, pmu);


  % filter_nsamples = 20;
  % filtered_tve = filter_samples_three_ph(tve, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_fe = filter_samples_mono_ph(fe, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_rfe = filter_samples_mono_ph(rfe, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_mag = filter_samples_three_ph(mag_error, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_ang = filter_samples_three_ph(ang_error, lenght_frame_step, filter_nsamples, number_of_step);

  plot_error_tve_fe_rfe('PMU', tve, fe, rfe);
  plot_error_mag_phase('PMU', mag_error, ang_error);
  do_report('Bandwidth', 'PMU', [60], [tve], [fe], [rfe]);

  disp (strcat("Finish: ", asctime( localtime(time()) ), "\n") );
  return;

endfunction
