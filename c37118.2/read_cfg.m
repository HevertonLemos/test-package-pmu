%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the cfg struct IEEE C37.118-2.
%
% frame_cfg = frame of the cfg received;
% frame_size = totaly size of the frame;
%
% Return
% cfg: struct of the cfg.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cfg = read_cfg(frame_cfg, frame_size)

  cfg.("sync") = dec2hex( typecast( fliplr(frame_cfg(1:2)), "uint16") );
  cfg.("frame_size") = typecast( fliplr(frame_cfg(3:4)), "uint16" );
  cfg.("idcode") = typecast(fliplr(frame_cfg(5:6)), "uint16");
  cfg.("soc") = ctime( typecast( fliplr(frame_cfg(7:10)), "uint32" ));
  cfg.("time_base") = typecast( fliplr([frame_cfg(15) frame_cfg(16) frame_cfg(17) uint8(0)]), "uint32" );
  cfg.("fracsec") = typecast( fliplr([frame_cfg(11) frame_cfg(12) frame_cfg(13) uint8(0)]), "single" ) / typecast( cfg.time_base, "single" );
  cfg.("time_quality") = frame_cfg(14);
  cfg.("num_pmu") = typecast( fliplr(frame_cfg(19:20)), "uint16" );
  x = 1;
  pmu = struct();
  bit = 21;

  while(x <= cfg.num_pmu)
    p.("stn") = char( frame_cfg(bit:(bit+=15)) );
    p.("idcode_pmu") = typecast( [frame_cfg(bit+=2) frame_cfg(bit+1)], "uint16");
    p.("format_") = typecast( [frame_cfg(bit+=2) frame_cfg(bit+1)], "uint16");
    p.("phnmr") = typecast( [frame_cfg(bit+=2) frame_cfg(bit+1)], "uint16");
    p.("annmr") = typecast( [frame_cfg(bit+=2) frame_cfg(bit+1)], "uint16");
    p.("dgnmr") = typecast( [frame_cfg(bit+1) frame_cfg(bit+=2)], "uint16");
    m = (16*(p.phnmr+p.annmr+16*p.dgnmr))/16;
    [p.("chnam"),bit] = get_unit(m, frame_cfg, bit, 16);

    [p.("phunit"), bit] = get_unit(p.phnmr, frame_cfg, bit, 4);
    [p.("anunit"), bit] = get_unit(p.annmr, frame_cfg, bit, 4);
    [p.("digunit"), bit] = get_unit(p.dgnmr, frame_cfg, bit, 4);

    p.("fnom") = typecast( [frame_cfg(bit+1) frame_cfg(bit+=2)], "uint16" );
    p.("cfgcnt") = typecast( [frame_cfg((bit+=2)) frame_cfg(bit+1)], "uint16" );

    pmu.(num2str(x)) = p;
    x++;
  endwhile

  cfg.("pmu") = pmu;
  cfg.("data_rate") = typecast( frame_cfg((frame_size-3):(frame_size-2)), "uint16" );
  cfg.("chk") = typecast( frame_cfg( (frame_size-1) : frame_size ), "uint16" );

  % save_cfg(cfg);

endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% <Description>.
%
% number = number of the phasors that contain in PMU;
% frame = frame that contain the phasor name;
% bit = bit of the frame that start phasor;
% bit_step = how many of the bit to phasor;
%
% Return
% result: vector with phasor names.
% bit: the last bit used.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result,bit] = get_unit(number, frame, bit, bit_step)

  if(number != 0)
    for i = 1:number
      result{i} = frame( bit+1 : (bit+=bit_step) );
    endfor
  else
    result = 0;
  endif
endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Save cfg in txt.
%
% cfg : struct cfg;
%
% Return
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_cfg(cfg)

  filename = "data/cfg.txt";
  fid = fopen (filename, "a");

  fwrite (fid, strcat("Start: ", asctime( localtime(time()) ), "\n") );
  fwrite (fid, "sync: \n");  fwrite (fid, num2str(cfg.sync) );
  fwrite (fid, "\nframe_size: \n");  fwrite (fid, num2str(cfg.frame_size) );
  fwrite (fid, "\nidcode: \n");  fwrite (fid, num2str(cfg.idcode) );
  fwrite (fid, "\nsoc: \n");  fwrite (fid, num2str(cfg.soc) );
  fwrite (fid, "\nfracsec: \n");  fwrite (fid, num2str(cfg.fracsec) );
  fwrite (fid, "\ntime_quality: \n");  fwrite (fid, num2str(cfg.time_quality) );
  fwrite (fid, "\ntime_base: \n");  fwrite (fid, num2str(cfg.time_base) );
  fwrite (fid, "\nnum_pmu: \n");  fwrite (fid, num2str(cfg.num_pmu) );

  x = 1;
  while(x <= cfg.num_pmu)
    s = getfield(cfg.pmu, num2str(x));
    fwrite (fid, strcat("\n\n### PMU: ", num2str(s.stn), " ###") );
    fwrite (fid, strcat("\npmu", num2str(x), ".stn: \n") );  fwrite (fid, num2str(s.stn) );
    fwrite (fid, strcat("\npmu", num2str(x), ".idcode_pmu: \n") );  fwrite (fid, num2str(s.idcode_pmu) );
    fwrite (fid, strcat("\npmu", num2str(x), ".format_: \n") );  fwrite (fid, num2str(s.format_) );
    fwrite (fid, strcat("\npmu", num2str(x), ".phnmr: \n") );  fwrite (fid, num2str(s.phnmr) );
    fwrite (fid, strcat("\npmu", num2str(x), ".annmr: \n") );  fwrite (fid, num2str(s.annmr) );
    fwrite (fid, strcat("\npmu", num2str(x), ".dgnmr: \n") );  fwrite (fid, num2str(s.dgnmr) );

    fwrite (fid, strcat("\npmu", num2str(x), ".chnam: \n") );
    if(length(s.chnam) >= 1)
      for i = 1:length(s.chnam)
        fwrite (fid, strcat( char(s.chnam{i}), "\n") );
      endfor
    else
      fwrite (fid, strcat( num2str( 0, "\n") ) );
    endif

    fwrite (fid, strcat("\npmu", num2str(x), ".phunit: \n") );
    if(length(s.phunit) != 0)
      for i = 1:length(s.phunit)
        fwrite (fid, strcat( num2str( typecast(s.phunit{i}, "uint32" ), "\n") ) );
      endfor
    else
      fwrite (fid, strcat( num2str( 0, "\n") ) );
    endif

    fwrite (fid, strcat("\npmu", num2str(x), ".anunit: \n") );
    if(s.anunit != 0)
      for i = 1:length(s.anunit)
        fwrite (fid, strcat( num2str( typecast(s.anunit{i}, "uint32" ), "\n") ) );
      endfor
    else
      fwrite (fid, strcat( num2str( 0, "\n") ) );
    endif

    fwrite (fid, strcat("\npmu", num2str(x), ".digunit: \n") );
    if(s.digunit != 0)
        for i = 1:length(s.digunit)
        fwrite (fid, strcat( num2str( typecast(s.digunit{i}, "uint32" ), "\n") ) );
      endfor
    else
      fwrite (fid, strcat( num2str( 0, "\n") ) );
    endif

    fwrite (fid, strcat("\npmu", num2str(x), ".fnom: \n") );  fwrite (fid, num2str(s.fnom) );
    fwrite (fid, strcat("\npmu", num2str(x), ".cfgcnt: \n") );  fwrite (fid, num2str(s.cfgcnt) );
    fwrite (fid, strcat("\n### Finish: ", num2str(s.stn), " ###\n") );
    x++;
  endwhile

  fwrite (fid, "\ndata_rate: \n");  fwrite (fid, num2str(cfg.data_rate) );
  fwrite (fid, "\nchk: \n");  fwrite (fid, num2str(cfg.chk) );
  fwrite (fid, "\n\n");

  fclose (fid);

endfunction
