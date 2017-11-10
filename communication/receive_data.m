%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UDP Socket for reception of the data frame.
%
% rcv_sck= number of the socket open.
% cfg= struct cfg
%
% Return
% data: frame received by socket.
% len:
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data,len] = receive_data(rcv_sck, cfg)

  [frame,len] = recv(rcv_sck, 65365, MSG_DONTWAIT);
  if (len != -1)
    data = read_data(frame, len, cfg);
  endif
  break;
  return

endfunction
