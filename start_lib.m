%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function start the modules necessary to correct performance the lib_pmu.
% Too charge the all modules (folders).
%
%
% Return
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function start_lib()

  warning off;
  #start package sockets
  [desc, flag] = pkg ("describe", "sockets");
  if( strcmp(flag{1},'Not installed') )
    pkg -forge install sockets;
    pkg load sockets;
    errordlg ("Package 'sockets' not installed.", "Package error");
  elseif( strcmp(flag{1},'Not loaded') )
    pkg load sockets;
  endif

  #start folders
  addpath( strcat(pwd,'/support') );
  addpath( strcat(pwd,'/communication') );
  addpath( strcat(pwd,'/c37118.1') );
  addpath( strcat(pwd,'/c37118.1/steady_state') );
  addpath( strcat(pwd,'/c37118.1/dynamic_state') );
  addpath( strcat(pwd,'/c37118.2') );
  addpath( strcat(pwd,'/data') );


endfunction
