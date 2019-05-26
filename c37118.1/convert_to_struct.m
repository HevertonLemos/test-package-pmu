%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performed the data received to PMU struct for tests.
%
% Usage: phasors = convert_to_struct(struct_received)
%
% struct_received = list of the frames received of the PMU about test;
%
% Return
% phasors: struct of the PMU to tests.
%
%  Heverton de Lemos 13/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phasors = convert_to_struct(struct_received)

  VS1 = VC = VB = VA = [];
  IS1 = IC = IB = IA = [];

  for i=1:length(struct_received)
    pmu = getfield(struct_received(i).pmu, '1');

    VA(1,i) = pmu.phasors{1}(1);
    VA(2,i) = pmu.phasors{1}(2);
    VB(1,i) = pmu.phasors{2}(1);
    VB(2,i) = pmu.phasors{2}(2);
    VC(1,i) = pmu.phasors{3}(1);
    VC(2,i) = pmu.phasors{3}(2);
    % VS1(1,i) = pmu.phasors{4}(1);
    % VS1(2,i) = pmu.phasors{4}(2);

    % IA(1,i) = pmu.phasors{5}(1);
    % IA(2,i) = pmu.phasors{5}(2);
    % IB(1,i) = pmu.phasors{6}(1);
    % IB(2,i) = pmu.phasors{6}(2);
    % IC(1,i) = pmu.phasors{7}(1);
    % IC(2,i) = pmu.phasors{7}(2);
    % IS1(1,i) = pmu.phasors{8}(1);
    % IS1(2,i) = pmu.phasors{8}(2);

    freq(i) = pmu.freq;
    rocof(i) = pmu.dfreq;
  endfor

  phasors = struct();
  phasors.("VA") = VA;
  phasors.("VB") = VB;
  phasors.("VC") = VC;
  % phasors.("VS1") = VS1;
  % phasors.("IA") = IA;
  % phasors.("IB") = IB;
  % phasors.("IC") = IC;
  % phasors.("IS1") = IS1;
  phasors.("frequency") = freq;
  phasors.("rocof") = rocof;

  return;
endfunction
