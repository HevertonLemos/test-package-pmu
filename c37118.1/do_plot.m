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
% File "[name]_plot.png".
%
%  Heverton de Lemos 19/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_plot(pmu_name, ref, data, g_title, label_x, label_y, g_legend)
  file = strcat(pmu_name, '_', g_title);
  figure;
  plot(ref, 'k');
  hold;
  plot(data, 'r');
  grid;
  title(g_title);
  xlabel(label_x);
  ylabel(label_y);
  legend(g_legend);
  % saveas(gcf,file);
  print( file, "-dpng");
endfunction
