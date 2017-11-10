%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Usage: socket = connect_socket(local_port, send_ip, send_port)
%
% local_port= local port to open the socket;
% send_ip= addres ip to send data;
% send_port= port to send data;
%
% Return
% socket: socket number to comunication or -1 if connection fail.
%  
% <Description>.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [socket] = connect_socket(local_port, send_ip, send_port)

  socket = open_socket(local_port, 1);
  if socket < 0
    return;
  endif

  server_info = struct("addr", send_ip, "port", send_port);
  if connect(socket, server_info) != 0
    socket = -1;
  endif
  return;

endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% <Description>.
%
% port= local port to open.
% mode= 1-send; 2-receive
%
% Return
% sck: socket that is open.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sck = open_socket(port, mode)

  if mode == 1
    sck = socket(AF_INET, SOCK_DGRAM, 0);
  elseif mode == 2
    sck = socket();
  else
    sck = -1;
  endif

  if(sck != -1)
    bind(sck, port);
  endif

endfunction
