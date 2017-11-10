%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the command frame (IEEE C37.118-2).
%
% idcode = identifier of the script;
% cmd =
%    •Command 1: Turn off transmition of the data frames;
%    •Command 2: Turn on transmition of the data frames;
%    •Command 3: Send the header frame;
%    •Command 4: Send the CFG1 frame;
%    •Command 5: Send the CFG2 frame;
%    •Command 6: Send the extend frame;
%
% Return
% commands: frame IEEE C37.118-2 to send command to PMU.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function commands = generate_command_frame(idcode, cmd)

  %sync: Synchronization bytes - bytes size: 2.
  message(1) = hex2dec( "AA" );
  message(2) = hex2dec( "41" );

  %frame_size: Frame size - bytes size: 2.
  message(3) = hex2dec( "00" );
  message(4) = hex2dec( "14" );

  %id_code: Equipment code in SPMS - bytes size: 2.
  message(5) = hex2dec( idcode(1:2) );
  message(6) = hex2dec( idcode(3:4) );

  %soc: Timestamp - bytes size: 4.
  tmp = dec2hex(str2num( strftime("%s", localtime(time())) ) );
  message(7) = hex2dec( tmp(1:2) );
  message(8) = hex2dec( tmp(3:4) );
  message(9) = hex2dec( tmp(5:6) );
  message(10) = hex2dec( tmp(7:8) );

  %fracsec: Fração de segundo - bytes size: 4.
  tmp = dec2hex( str2num( strftime("%S", localtime(time())) ), 8 );
  message(11) = hex2dec( tmp(1:2) );
  message(12) = hex2dec( tmp(3:4) );
  message(13) = hex2dec( tmp(5:6) );
  message(14) = hex2dec( tmp(7:8) );

  %cmd: Command will send to PMU/PDC - bytes size: 2.
  if( or( (cmd < 0), (cmd > 6) ) )
    printf("command error");
  else
    message(15) = 0;
    message(16) = cmd;
  endif

  %ext_frame: Dados do frame extendido, palavras de 16 bits máximo de 65518 bytes definidos pelo usuário - bytes size: 0-65518.
  message(17) = hex2dec( "00" );
  message(18) = hex2dec( "00" );

  %chk: Checksun - bytes size: 2.
  crc = crc16( message(1:18) );
  message(19) = hex2dec( crc(1:2) );
  message(20) = hex2dec( crc(3:4) );

  commands = cast( message, "uint8");
endfunction
