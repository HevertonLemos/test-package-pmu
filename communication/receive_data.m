%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Usage: [data, len] = receive_data(rcv_sck, cfg)
%
% UDP Socket for reception of the data frame.
%
% rcv_sck= number of the socket open.
% cfg= struct cfg
%
% Return
% data: frame received by socket.
% len: length of last received data. -1 if not received.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, len] = receive_data(rcv_sck, cfg)
  data = 0; % avoid exceptions in case of len < 0;
  if (isunix())
    [frame,len] = recv(rcv_sck, 65365, MSG_DONTWAIT);
  else
    [frame,len] = recv(rcv_sck, 65365);
  endif
  if (len != -1)
    data = read_data(frame, len, cfg);
  endif
  break;
  return

endfunction
