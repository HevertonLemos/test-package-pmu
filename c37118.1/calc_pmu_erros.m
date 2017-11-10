%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Calcule the all errors of the PMU.
%
% referenc_pmu = struct witch data of the reference PMU;
% tested_pmu = struct witch data of the PMU about test;
%
% Return
% mag_error:
% ang_error:
% tve: vector witch values about total vector error.
% fe: vector witch values about frequency error.
% rfe: vector witch values about rate of change of frequency error.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mag_error, ang_error, tve, fe, rfe] = calc_pmu_erros(referenc_pmu, tested_pmu)
  convert_radios_to_angle = (180/pi);
  convert_angle_to_radios = (pi/180);

  for i=1:length(tested_pmu.rocof)

    % Frequency Error
    fe(i) = abs(referenc_pmu.frequency(i) - tested_pmu.frequency(i));
    rfe(i) = abs(referenc_pmu.rocof(i) - tested_pmu.rocof(i));

    % Magnitude Error
    mag_error(1,i) = ( referenc_pmu.VA(1,i) - tested_pmu.VA(1,i) ) / ( referenc_pmu.VA(1,i) * 100 );
    mag_error(2,i) = ( referenc_pmu.VB(1,i) - tested_pmu.VB(1,i) ) / ( referenc_pmu.VA(1,i) * 100 );
    mag_error(3,i) = ( referenc_pmu.VC(1,i) - tested_pmu.VC(1,i) ) / ( referenc_pmu.VA(1,i) * 100 );
    % mag_error(4,i) = ( referenc_pmu.VS1(1,i) - tested_pmu.VS1(1,i) ) / ( referenc_pmu.VA(1,i) * 100 );

    % Angle error
    ang_error(1,i) = wrap_angle(referenc_pmu.VA(2,i) - tested_pmu.VA(2,i) );
    ang_error(2,i) = wrap_angle(referenc_pmu.VB(2,i) - tested_pmu.VB(2,i) );
    ang_error(3,i) = wrap_angle(referenc_pmu.VC(2,i) - tested_pmu.VC(2,i) );
    % ang_error(4,i) = wrap_angle(referenc_pmu.VS1(2,i) - tested_pmu.VS1(2,i) );

    % TVE
    realA = tested_pmu.VA(1,i) * cos(tested_pmu.VA(1,i) * convert_angle_to_radios);
    realB = tested_pmu.VB(1,i) * cos(tested_pmu.VB(1,i) * convert_angle_to_radios);
    realC = tested_pmu.VC(1,i) * cos(tested_pmu.VC(1,i) * convert_angle_to_radios);
    % realS1 = tested_pmu.VS1(1,i) * cos(tested_pmu.VS1(1,i) * convert_angle_to_radios);

    imagA = tested_pmu.VA(1,i) * sin(tested_pmu.VA(1,i) * convert_angle_to_radios);
    imagB = tested_pmu.VB(1,i) * sin(tested_pmu.VB(1,i) * convert_angle_to_radios);
    imagC = tested_pmu.VC(1,i) * sin(tested_pmu.VC(1,i) * convert_angle_to_radios);
    % imagS1 = tested_pmu.VS1(1,i) * sin(tested_pmu.VS1(1,i) * convert_angle_to_radios);

    realA_ref = referenc_pmu.VA(1,i) * cos(referenc_pmu.VA(1,i) * convert_angle_to_radios);
    realB_ref = referenc_pmu.VB(1,i) * cos(referenc_pmu.VB(1,i) * convert_angle_to_radios);
    realC_ref = referenc_pmu.VC(1,i) * cos(referenc_pmu.VC(1,i) * convert_angle_to_radios);
    % realS1_ref = referenc_pmu.VS1(1,i) * cos(referenc_pmu.VS1(1,i) * convert_angle_to_radios);

    imagA_ref = referenc_pmu.VA(1,i) * sin(referenc_pmu.VA(1,i) * convert_angle_to_radios);
    imagB_ref = referenc_pmu.VB(1,i) * sin(referenc_pmu.VB(1,i) * convert_angle_to_radios);
    imagC_ref = referenc_pmu.VC(1,i) * sin(referenc_pmu.VC(1,i) * convert_angle_to_radios);
    % imagS1_ref = referenc_pmu.VS1(1,i) * sin(referenc_pmu.VS1(1,i) * convert_angle_to_radios);

    tve(1,i) = (sqrt ( ( (realA - realA_ref)^2 + ( imagA - imagA_ref)^2 ) / (realA_ref^2 + imagA_ref^2) ) ) * 100;
    tve(2,i) = (sqrt ( ( (realB - realB_ref)^2 + ( imagB - imagB_ref)^2 ) / (realB_ref^2 + imagB_ref^2) ) ) * 100;
    tve(3,i) = (sqrt ( ( (realC - realC_ref)^2 + ( imagC - imagC_ref)^2 ) / (realC_ref^2 + imagC_ref^2) ) ) * 100;
    % tve(4,i) = (sqrt ( (realS1 - realS1_ref)^2 + ( imagS1 - imagS1_ref)^2 ) / (realS1_ref^2 + imagS1_ref^2) ) * 100;

  endfor

  return;
endfunction
