%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performed the verification in frame received is the start of the test.
%
% struct_received = frame received of the PMU about test;
% magnitude_nominal = ;
%
% Return
% result: bollean that inform if data is start of the test.
%
%  Heverton de Lemos 20/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = filter_input(struct_received, magnitude_nominal)

  pmu = getfield(struct_received.pmu, '1');

  if pmu.phasors(1){1}(1) >= (0.001 * magnitude_nominal)
    if struct_received.fracsec == 0
      result = true;
      return;
    endif
  endif

  result = false;
  return;

endfunction
