%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create the graph report witch values of the error.
%
% pmu_name = name of the PMU;
% tve = total vector error;
% fe = frequency error;
% rfe = rate of frequency error;
%
% Return
% File "Voltage TVE ->[pmu_name].png".
% File "Frequency Error (FE) ->[pmu_name].png".
% File "Rate of Change of Frequency Error (RFE) ->[pmu_name].png".
%
%  Heverton de Lemos 20/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_error_tve_fe_rfe(pmu_name, tve, fe, rfe)
  label_x = 'Time (in frames)';

  label_y = 'TVE (%)';
  g_title = strcat('Voltage TVE -> ',pmu_name);
  figure;
  plot(tve(1,:), 'b');
  hold;
  plot(tve(2,:), 'r');
  plot(tve(3,:), 'g');
  grid;
  title(g_title);
  xlabel(label_x);
  ylabel(label_y);
  legend( ['Phase A'; 'Phase B'; 'Phase C'] );
  % print( g_title, "-dpng");

  % g_title = strcat('Current TVE -> ',pmu_name);
  % figure;
  % plot(tve(1,:), 'b');
  % hold;
  % plot(tve(2,:), 'r');
  % plot(tve(3,:), 'g');
  % grid;
  % title(g_title);
  % xlabel(label_x);
  % ylabel(label_y);
  % legend( ['Phase A'; 'Phase B'; 'Phase C'] );
  % print( g_title, "-dpng");

  label_y = 'FE (Hz)';
  g_title = strcat('Frequency Error (FE) -> ',pmu_name);
  figure;
  plot(fe, 'b');
  grid;
  title(g_title);
  xlabel(label_x);
  ylabel(label_y);
  % print( g_title, "-dpng");

  label_y = 'RFE (Hz/s)';
  g_title = strcat('Rate of Change of Frequency Error (RFE) -> ',pmu_name);
  figure;
  plot(rfe, 'b');
  grid;
  title(g_title);
  xlabel(label_x);
  ylabel(label_y);
  % print( g_title, "-dpng");
endfunction
