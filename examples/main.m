clc
clear all

source("../start_lib.m");

start_lib("../");

local_port = 0;
send_ip = "10.7.77.147";
send_port = 4723;

sock = connect_socket(local_port, send_ip, send_port);

idcode = "0001";
cmd_cfg2 = 5;

send_cfg2_command = generate_command_frame(idcode, cmd_cfg2);

send_command(sock, send_cfg2_command);

cfg2_frame = receive_cfg(sock, 2);

cmd_send_data = 2;
send_data_command = generate_command_frame(idcode, cmd_send_data);

send_command(sock, send_data_command);

printf("Press 's' to stop befeore the test starts...\n");
fflush (stdout);
nominal_voltage = 115; % Voltage in V

while (1)
  if (kbhit (1) == 's')
    break
  endif

  % This test considers that It will start only after the first top of the 
  % second when the magnitude off the first channel is above 10% of nominal
  [data, len] = receive_data(sock, cfg2_frame);
  if (len < 0)
    continue;
  endif
  if (data.pmu.("1").phasors(1){1}(1) < 0.1 * nominal_voltage)
    continue;
  endif
  if (data.fracsec == 0)
    break;
    % only here it is considered that the  test starts;
  endif
endwhile

printf("The test started. Press 's' to stop it before the end.\n");
fflush (stdout);
test_data = data;
while (1)
  if (kbhit (1) == 's')
    break
  endif

  % This test considers that It will start only after the first top of the 
  % second when the magnitude off the first channel is above 10% of nominal
  [data, len] = receive_data(sock, cfg2_frame);
  if (len < 0)
    continue;
  endif
  test_data = [test_data data];
  if (data.pmu.("1").phasors(1){1}(1) < 0.1 * nominal_voltage)
    break;
    % Here it is considered the end of this test
  endif
endwhile

printf("All the data was acquired, please wait the results...\n");
fflush (stdout);

disconnect_socket(sock);