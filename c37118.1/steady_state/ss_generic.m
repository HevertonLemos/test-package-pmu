%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% <Description>.
%
% mag = ;
% ang = ;
% f0 = ;
% fps = ;
% t = ;
%
% Return
% filtered_data: vector witch values filtered.
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phasor = ss_generic(mag, ang, f0, fps, t)
  delta_ang = f0/fps;
  ang_aux = ang;

  phasor(1,1:t) = mag;
  phasor(2,1) = wrap_angle(ang_aux);
  for i=2:t
    %ang_aux = ang_aux + ( (2*pi) * ( freq(i) - f0 ) * (1.0/fps) ) / (2*pi/360);
    ang_aux = ang_aux + ( 360 * (delta_ang) );
    phasor(2,i) = wrap_angle(ang_aux);
  endfor

  return;
endfunction
