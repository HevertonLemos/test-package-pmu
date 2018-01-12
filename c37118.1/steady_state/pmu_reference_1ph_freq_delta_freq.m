%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate 1ph PMU reference to frequency test steady state.
%
% Usage: 
%
% magnitude = Reference phasor magnitude;
% initial_frequency = Initial frequency in the test (Hz);
% delta_frequency = The increase/decrease of frequency in Hz for each step;
% number_of_steps = The total amount of frequency steps;
% time_per_step = The time, in seconds, per step;
% frames_per_second = Reference Fps (frames per second);
% initial_angle = Refenrece initial angle;
%
% Return
% phasor: Struct of the PMU reference to frequency steady state.
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phasor = pmu_reference_1ph_freq_delta_freq(magnitude,
                                                    initial_frequency,
                                                    delta_frequency,
                                                    number_of_steps,
                                                    time_per_step,
                                                    frames_per_second,
                                                    initial_angle)
  Va = [];
  freq = [];
  rocof = [];
  % implement check of all input values;
  lenght_frame_step = ceil(frames_per_second * time_per_step); 
  for i=1:number_of_steps
    instantaneous_frequency = initial_frequency + (i - 1) * delta_frequency;
    tmp_Va = ss_generic(magnitude,
                        initial_angle,
                        instantaneous_frequency,
                        frames_per_second,
                        lenght_frame_step);

    Va = [Va tmp_Va];
    freq = [freq ones(1, lenght_frame_step) * instantaneous_frequency];
    rocof = [rocof zeros(1, lenght_frame_step)];
  endfor

  phasor = struct();
  phasor.("VA") = Va;
  phasor.("frequency") = freq;
  phasor.("rocof") = rocof;
  return;
endfunction