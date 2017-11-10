%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performed the frequency test in steady state.
%
% pmu_test = data received of the pmu about test;
% V_mag = magnitude of the voltage phasor;
% I_mag = magnitude of the current phasor;
% f0 = nominal frequency to phasor;
% fps = frames per second sended by PMU;
% t = time of the acquisition of the data (in seconds);
%
% Return
% files: reports (.txt) and graph (.png) witch erros;
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out_of_band_steady(pmu_test, V_mag, I_mag, f0, fps, t)

  number_of_step = 3;
  data_lenght = ceil(t * fps) * number_of_step;
  lenght_frame_step = ceil(data_lenght/number_of_step);

  reference = pmu_reference_out_of_band_steady(V_mag, I_mag, f0, fps, data_lenght, lenght_frame_step, number_of_step);
  pmu = convert_to_struct(pmu_test);
  length(reference.frequency)
  length(pmu.frequency)
  [mag_error, ang_error, tve, fe, rfe] = calc_pmu_erros(reference, pmu);

  % filter_nsamples = 20;
  % filtered_tve = ss_filter_samples_three_ph(tve, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_fe = ss_filter_samples_mono_ph(fe, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_rfe = ss_filter_samples_mono_ph(rfe, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_mag = ss_filter_samples_three_ph(mag_error, lenght_frame_step, filter_nsamples, number_of_step);
  % filtered_ang = ss_filter_samples_three_ph(ang_error, lenght_frame_step, filter_nsamples, number_of_step);
  %
  % plot_error_mag_phase('PMU', filtered_mag, filtered_ang);
  % plot_error_tve_fe_rfe('PMU', filtered_tve, filtered_fe, filtered_rfe);
  % do_report('Out of band', 'PMU', [60], [filtered_tve], [filtered_fe], [filtered_rfe]);

  filter_nsamples = 20;
  filtered_tve = tve(1:3, filter_nsamples:length(tve));
  filtered_fe = fe(filter_nsamples:length(fe));
  filtered_rfe = rfe(filter_nsamples:length(rfe));
  filtered_mag = mag_error(1:3, filter_nsamples:length(mag_error));
  filtered_ang = ang_error(1:3, filter_nsamples:length(ang_error));

  plot_error_mag_phase('PMU', filtered_mag, filtered_ang);
  plot_error_tve_fe_rfe('PMU', filtered_tve, filtered_fe, filtered_rfe);
  do_report('Out of band', 'PMU', [60], [filtered_tve], [filtered_fe], [filtered_rfe]);

  return;

endfunction
