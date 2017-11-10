%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performed the filter to data.
%
% data = ;
% lenght_frame_step = ;
% filter_nsamples = ;
% number_of_step = ;
%
% Return
% filtered_data: vector witch values filtered.
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [filtered_data] = ss_filter_samples_mono_ph(data, lenght_frame_step, filter_nsamples, number_of_step)

  filtered_data = [];
  initial_frame_of_step = 1;
  finish_frame_of_step = lenght_frame_step;
  for i=1:number_of_step
    tmp_data = data( (initial_frame_of_step+filter_nsamples):(finish_frame_of_step-filter_nsamples) );

    filtered_data = cat(2, filtered_data, tmp_data);

    initial_frame_of_step = initial_frame_of_step + lenght_frame_step;
    finish_frame_of_step = finish_frame_of_step + lenght_frame_step;
  endfor

  return;

endfunction
