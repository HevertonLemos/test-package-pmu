%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create the text report witch the maximum values of the errors to PMU.
%
% pmu_name = name of the PMU;
% vector_fps = vector witch FPS used in tests;
% vector_tve = vector witch TVE to each FPS test;
% vector_fe = vector witch FE to each FPS test;
% vector_rfe = vector witch RFE to each FPS test;
%
% Return
% File "frequency_report_ss.txt" witch all errors maximums.
%
%  Heverton de Lemos 10/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_report(test_name, pmu_name, vector_fps, vector_tve, vector_fe, vector_rfe)

  nome_arq = strcat(test_name,'_report_ss_', pmu_name, '.txt');
  arq = fopen(nome_arq,'wt');

  % Header
  fprintf(arq,'-----------------------------------------------------\n');
  fprintf(arq,strcat('|            ',test_name,' Test Steady State             |\n'));
  fprintf(arq,'-----------------------------------------------------\n');
  fprintf(arq,'| FPS |    Eqto     | TVE(%%) | FE(mHz) | RFE(mHz/s) |\n');
  fprintf(arq,'-----------------------------------------------------\n');
  % fprintf(arq,'|     Thresholds    |  1.00   |   5.00  |   100.00   |\n');
  % fprintf(arq,'-----------------------------------------------------\n');

  for i_fps = 1:length(vector_fps)
    tve_max = max(max(abs(vector_tve(i_fps,:))));
    fe_max = max(abs(vector_fe(i_fps,:)));
    rfe_max = max(abs(vector_rfe(i_fps,:)));

    fprintf(arq,'|  %d | %s |  %4.2f  |  %5.2f  |    %5.2f   |\n',vector_fps(i_fps), pmu_name, tve_max, fe_max*1000, rfe_max*1000);
  endfor;

  fprintf(arq,'-----------------------------------------------------\n');
  fclose(arq);

endfunction;
