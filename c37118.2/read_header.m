%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the header struct IEEE C37.118-2.
%
% frame_header = frame of the header received;
% frame_size = totaly size of the frame;
%
% Return
% header: struct of the header
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function header = read_header(frame_header, frame_size)

  header.("sync") = dec2hex( typecast( fliplr(frame_header(1:2)), "uint16") );
  header.("frame_size") = typecast( fliplr(frame_header(3:4)), "uint16" );
  header.("idcode") = typecast(fliplr(frame_header(5:6)), "uint16");
  header.("soc") = ctime( typecast( fliplr(frame_header(7:10)), "uint32" ));
  header.("fracsec") = typecast( fliplr([frame_header(11) frame_header(12) frame_header(13) uint8(1)]), "uint32" );
  header.("time_quality") = frame_header(14);
  header.("data") = char( frame_header( 15:(frame_size-2) ) );
  header.("chk") = typecast( frame_header( frame_size : (frame_size-1) ), "uint16" );

  save_header(header);

endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Save header in txt.
%
% header = struct header;
%
% Return
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_header(header)

  filename = "data/header.txt";
  fid = fopen (filename, "a");
  fwrite (fid, strcat("Start: ", asctime( localtime(time()) ), "\n") );
  fwrite (fid, "sync: \n");  fwrite (fid, num2str(header.sync) );
  fwrite (fid, "\nframe_size: \n");  fwrite (fid, num2str(header.frame_size) );
  fwrite (fid, "\nidcode: \n");  fwrite (fid, num2str(header.idcode) );
  fwrite (fid, "\nsoc: \n");  fwrite (fid, num2str(header.soc) );
  fwrite (fid, "\nfracsec: \n");  fwrite (fid, num2str(header.fracsec) );
  fwrite (fid, "\ntime_quality: \n");  fwrite (fid, num2str(header.time_quality) );
  fwrite (fid, "\ndata: \n");  fwrite (fid, header.data);
  fwrite (fid, "\nchk: \n");  fwrite (fid, num2str(header.chk) );
  fwrite (fid, "\n\n");

  fclose (fid);
endfunction
