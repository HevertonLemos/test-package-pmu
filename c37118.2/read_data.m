%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate the data struct IEEE C37.118-2.
%
% frame_dat = frame of the data received;
% frame_size =  totaly size of the frame;
% cfg = struct of the cfg frame;
%
% Return
% data: struct of the data.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = read_data(frame_data, frame_size, cfg)

  data.("sync") = dec2hex( typecast( fliplr(frame_data(1:2)), "uint16") );
  data.("frame_size") = typecast( fliplr(frame_data(3:4)), "uint16" );
  data.("idcode") = typecast(fliplr(frame_data(5:6)), "uint16");
  data.("soc") = ctime( typecast( fliplr(frame_data(7:10)), "uint32" ));
  data.("fracsec") = typecast( fliplr([frame_data(11) frame_data(12) frame_data(13) uint8(0)]), "single" ) / typecast( cfg.time_base, "single" );
  data.("time_quality") = frame_data(14);
  data.("stat") = typecast( fliplr(frame_data(15:16)), "uint16" );

  x = 1;
  pmu = struct();
  bit = 17;

  while(x <= cfg.num_pmu)
    s = getfield(cfg.pmu, num2str(x));
    if(s.format_ == 15)
      multiple_ph = 8;
      multiple_f = 4;
      multiple_a = 4;
    elseif (s.format_ == 0)
      multiple = 4;
      multiple_f = 2;
      multiple_a = 2;
    endif

    [p.("phasors"), bit] = get_phasor( s.phnmr, frame_data, bit, multiple_ph );
    [p.("freq"), bit] =  get_freq( frame_data, bit, multiple_f);
    [p.("dfreq"), bit] = get_freq( frame_data, bit, multiple_f);
    [p.("analog"), bit] = get_data( s.annmr, frame_data, bit, multiple_a );
    [p.("digital"), bit] = get_data( s.dgnmr, frame_data, bit, 2 );

    pmu.(num2str(x)) = p;
    x++;
  endwhile

  data.("pmu") = pmu;
  data.("chk") = typecast( frame_data( (frame_size-1) : frame_size ), "uint16" );

  % save_data(data, cfg.num_pmu);

endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get module e angle of the phasor.
%
% number = number of the phasors that contain in PMU;
% frame = frame that contain the phasor;
% bit = bit of the frame that start phasor;
% bit_step = how many of the bit to phasor;
%
% Return
% result: vector with all module and angle of the phasors.
% bit: the last bit used.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result,bit] = get_phasor(number, frame, bit, bit_step)

  if(number != 0)
    for i = 1:number
      [module, ang] = convert_phasor( frame( bit : (bit+=bit_step-1) ) );
      result{i} = [module, ang];
      bit++;
    endfor
  else
    result = -1;
  endif
endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Convert the phasor frame in real number.
%
% frame = phasor frame;
%
% Return
% module: module of the phasor as real number.
% ang: angle  of the phasor as real number.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [module, ang] = convert_phasor(frame)

  module = typecast( fliplr( uint8(frame(1:4)) ), "single");
  ang = typecast( fliplr(uint8(frame(5:8))), "single");
  ang = (ang *180)/pi;
endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get frequency the frame PMU.
%
% frame = frame that contain the frequency;
% bit = bit of the frame that start frequency value;
% bit_step = how many of the bit to frequency value;
%
% Return
% result: frequency in real number.
% bit: the last bit used.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result,bit] = get_freq(frame, bit, bit_step)

  f = uint8(frame( bit : (bit+=bit_step-1) ));
  result = typecast( fliplr(f), "single");
  bit++;

endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get analog or digital data.
%
% number = number of the analog or digital measurement that contain in PMU frame;
% frame = frame that contain the data;
% bit = bit of the frame that contain first data value;
% bit_step = how many of the bit to data;
%
% Return
% result: vector with all measurement data.
% bit: the last bit used.
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result,bit] = get_data(number, frame, bit, bit_step)

  if(number != 0)
    for i = 1:number
      f = uint8(frame( bit : (bit+=bit_step-1) ));
      result{i} = typecast( fliplr(f), "single");
      bit++;
    endfor
  else
    result = -1;
  endif
endfunction



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Save data in txt.
%
% data = struct data.
% num_pmu = PMU numbers.
%
% Return
%
%  Heverton de Lemos 16/10/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_data(data, num_pmu)

  filename = "data/data.txt";
  fid = fopen (filename, "a");
  fwrite (fid, strcat("Start: ", asctime( localtime(time()) ), "\n") );
  fwrite (fid, "sync: \n");  fwrite (fid, num2str(data.sync) );
  fwrite (fid, "\nframe_size: \n");  fwrite (fid, num2str(data.frame_size) );
  fwrite (fid, "\nidcode: \n");  fwrite (fid, num2str(data.idcode) );
  fwrite (fid, "\nsoc: \n");  fwrite (fid, num2str(data.soc) );
  fwrite (fid, "\nfracsec: \n");  fwrite (fid, num2str(data.fracsec) );
  fwrite (fid, "\ntime_quality: \n");  fwrite (fid, num2str(data.time_quality) );
  fwrite (fid, "\nstat: \n");  fwrite (fid, num2str(data.stat) );

  x = 1;
  while(x <= num_pmu)
    s = getfield(data.pmu, num2str(x));

    fwrite (fid, strcat("\n\n### PMU: ", num2str(x), " ###") );

    fwrite (fid, strcat("\npmu", num2str(x), ".phasors: \n") );
    for i = 1:length(s.phasors)
      fwrite (fid, strcat( num2str(s.phasors{i}), "\n") );
    endfor

    fwrite (fid, strcat("\npmu", num2str(x), ".freq: \n") );
    fwrite (fid, strcat( num2str(s.freq), "\n") );

    fwrite (fid, strcat("\npmu", num2str(x), ".dfreq: \n") );
    fwrite (fid, strcat( num2str(s.dfreq), "\n") );

    fwrite (fid, strcat("\npmu", num2str(x), ".analog: \n") );
    if(s.analog !=-1)
      for i = 1:length(s.analog)
        fwrite (fid, strcat( num2str(s.analog{i}), "\n") );
      endfor
    else
      fwrite (fid, strcat( num2str( 0, "\n") ) );
    endif

    fwrite (fid, strcat("\npmu", num2str(x), ".digital: \n") );
    if(s.digital != -1)
      for i = 1:length(s.digital)
        fwrite (fid, strcat( num2str(s.digital{i}), "\n") );
      endfor
    else
      fwrite (fid, strcat( num2str( 0, "\n") ) );
    endif
    fwrite (fid, strcat("\n### Finish: ", num2str(x), " ###\n") );
    x++;
  endwhile

  fwrite (fid, "\nchk: \n");  fwrite (fid, num2str(data.chk) );
  fwrite (fid, "\n\n");

  fclose (fid);

endfunction
