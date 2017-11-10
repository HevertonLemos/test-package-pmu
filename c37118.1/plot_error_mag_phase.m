%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create the graph report witch values of the error.
%
% pmu_name = name of the PMU;
% ref = vector witch FPS used in tests;
% data = vector witch TVE to each FPS test;
% g_title = title of the graph;
% label_x = name of the data by axes x;
% label_y = name of the data by axes y;
% g_legend = ;
%
% Return
% File "Voltage Magnitude Error ->[pmu_name].png".
% File "Voltage Phase Error ->[pmu_name].png".
%
%  Heverton de Lemos 20/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_error_mag_phase(pmu_name, magV_error, phaseV_error)
  label_x = 'Time (in frames)';

  label_y = 'EM (%)';
  g_title = strcat('Voltage Magnitude Error -> ',pmu_name);
  figure;
  plot(magV_error(1,:), 'b');
  hold;
  plot(magV_error(2,:), 'r');
  plot(magV_error(3,:), 'g');
  grid;
  title(g_title);
  xlabel(label_x);
  ylabel(label_y);
  legend( ['Phase A'; 'Phase B'; 'Phase C'] );
  % print( g_title, "-dpng");

  % g_title = strcat('Current Magnitude Error -> ',pmu_name);
  % figure;
  % plot(magI_error(1,:), 'b');
  % hold;
  % plot(magI_error(2,:), 'r');
  % plot(magI_error(3,:), 'g');
  % grid;
  % title(g_title);
  % xlabel(label_x);
  % ylabel(label_y);
  % legend( ['Phase A'; 'Phase B'; 'Phase C'] );
  % print( g_title, "-dpng");

  label_y = 'EA (Graus)';
  g_title = strcat('Voltage Phase Error -> ',pmu_name);
  figure;
  plot(phaseV_error(1,:), 'b');
  hold;
  plot(phaseV_error(2,:), 'r');
  plot(phaseV_error(3,:), 'g');
  grid;
  title(g_title);
  xlabel(label_x);
  ylabel(label_y);
  legend( ['Phase A'; 'Phase B'; 'Phase C'] );
  % print( g_title, "-dpng");

  % g_title = strcat('Current Phase Error -> ',pmu_name);
  % figure;
  % plot(phaseI_error(1,:), 'b');
  % hold;
  % plot(phaseI_error(2,:), 'r');
  % plot(phaseI_error(3,:), 'g');
  % grid;
  % title(g_title);
  % xlabel(label_x);
  % ylabel(label_y);
  % legend( ['Phase A'; 'Phase B'; 'Phase C'] );
  % print( g_title, "-dpng");
endfunction
