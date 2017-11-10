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
% pmu_class = classe of measurement: 1 (Protection class) or 2 (Measurement class);
%
% Return
% files: reports (.txt) and graph (.png) witch erros;
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function frequency_steady(pmu_test, V_mag, I_mag, f0, fps, t, pmu_class)

  data_lenght = ceil(t * fps);
  if pmu_class == 1
    freq_tmp = f0 - 2.0;
    freq_delta = (f0 + 2.0) - freq_tmp;
  elseif (pmu_class == 2)
    if fps < 10
      freq_tmp = f0 - 2.0;
      freq_delta = (f0 + 2.0) - freq_tmp;
    elseif fps >= 10 && fps < 25
      freq_tmp = f0 - (fps/5);
      freq_delta = (f0 + (fps/5)) - freq_tmp;
    elseif fps >= 25
      freq_tmp = f0 - 5.0;
      freq_delta = (f0 + 5.0) - freq_tmp;
    endif
  else
    phase = -1;
    return;
  endif

  step_freq = 0.1;
  number_of_step = ceil(freq_delta/step_freq) + 1;
  lenght_frame_step = ceil(data_lenght/number_of_step);

  reference = pmu_reference_freq_steady(V_mag, I_mag, freq_tmp, fps, lenght_frame_step, number_of_step, step_freq);
  pmu = convert_to_struct(pmu_test);

  [mag_error, ang_error, tve, fe, rfe] = calc_pmu_erros(reference, pmu);


  filter_nsamples = 20;
  filtered_pmu_freq = ss_filter_samples_mono_ph(pmu.frequency, lenght_frame_step, filter_nsamples, number_of_step);
  filtered_ref_freq = ss_filter_samples_mono_ph(reference.frequency, lenght_frame_step, filter_nsamples, number_of_step);
  filtered_tve = ss_filter_samples_three_ph(tve, lenght_frame_step, filter_nsamples, number_of_step);
  filtered_fe = ss_filter_samples_mono_ph(fe, lenght_frame_step, filter_nsamples, number_of_step);
  filtered_rfe = ss_filter_samples_mono_ph(rfe, lenght_frame_step, filter_nsamples, number_of_step);
  filtered_mag = ss_filter_samples_three_ph(mag_error, lenght_frame_step, filter_nsamples, number_of_step);
  filtered_ang = ss_filter_samples_three_ph(ang_error, lenght_frame_step, filter_nsamples, number_of_step);

  do_plot('PMU', filtered_pmu_freq, filtered_ref_freq(1:length(filtered_pmu_freq)), 'PMU Frequency', 'Time (in frames)', 'FREQ (Hz)', ['PMU '; 'Ref.']);
  plot_error_mag_phase('PMU', filtered_mag, filtered_ang);
  plot_error_tve_fe_rfe('PMU', filtered_tve, filtered_fe, filtered_rfe);
  do_report('Frequency', 'PMU', [60], [filtered_tve], [filtered_fe], [filtered_rfe]);

  return;

endfunction
