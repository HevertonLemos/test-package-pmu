%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UDP Socket for reception of the cfg frame.
%
% rcv_sck= number of the socket open.
%
% Return
% data: frame received by socket.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = receive_header(rcv_sck)

  [frame,len] = recv(rcv_sck, 65365);
  data = read_header(frame, len);

endfunction
