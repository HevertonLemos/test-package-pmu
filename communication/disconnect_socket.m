%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Disconect socket.
%
% sck= socket number;
%
% Return
% result: 0: disconnect ok
%        -1: disconnect nok
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = disconnect_socket(sck)

  if disconnect(sck) <= 0
    result = 0;
  else
    result = -1;
  endif

endfunction
