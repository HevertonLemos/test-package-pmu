%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UDP Socket for reception of the cfg frame.
%
% rcv_sck= number of the socket open.
% type_frame= 1 = CFG1
%             2 = CFG2
%             3 = CFG3
%
% Return
% data: frame received by socket.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = receive_cfg(rcv_sck, type_frame)

  [frame,len] = recv(rcv_sck, 65365);
  switch( type_frame)
  case 1
    data = read_cfg(frame, len);
  case 2
    data = read_cfg(frame, len);
  case 3
    data = read_cfg(frame, len);
  otherwise
    data = -1;
  endswitch

endfunction
