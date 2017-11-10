%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Usage: start_lib(lib_path)
%
% This function start the modules necessary to correct performance the lib_pmu.
% Too charge the all modules (folders).
%
%
% Return
%
%  Heverton de Lemos 24/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function start_lib(lib_path)

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
  
  if (nargin < 1)
    lib_path = pwd;
  endif

  #start folders
  addpath( strcat(lib_path,'/support') );
  addpath( strcat(lib_path,'/communication') );
  addpath( strcat(lib_path,'/c37118.1') );
  addpath( strcat(lib_path,'/c37118.1/steady_state') );
  addpath( strcat(lib_path,'/c37118.1/dynamic_state') );
  addpath( strcat(lib_path,'/c37118.2') );
  addpath( strcat(lib_path,'/data') );


endfunction
