%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wrap angle to -180º until 180º.
% ang: initial angle to do wrap.
%
%
% Return
% ang: angle convert to scale -180º to 180º.
%
%  Heverton de Lemos 09/11/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ang = wrap_angle(ang)
 while ang > 180
   ang = ang - 360.00;
 endwhile
 while ang < -180
   ang = ang + 360.00;
 endwhile
endfunction
