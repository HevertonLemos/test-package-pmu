# Package to test PMU#

## Author ##
* Heverton de Lemos
* Adriano de Oliveira Pires

## Description: ##
xxxx

## General Structure: ##
* Initial Folder: Lib
 * Sub-folder: Module [Class]
   * Files .m: public functions
     * functions in files: private functions

## Lib Structure: ##
* Lib:
  - start_lib()

  * communication:
   - connect_socket()
   - disconnect_socket()
   - receive_cfg()
   - receive_data()
   - receive_header()
   - send_command()

 * support:
   - crc16()
   - wrap_angle()

 * c37118.1:
   - convert_to_struct()
   - calc_pmu_errors()
   - do_report()
   - do_plot()
   - plot_error_mag_phase()
   - plot_error_tve_fe_rfe()
   - filter_input()

   * dynamic_state:
     - bandwidth_dynamic()
     - ramp_freq_dynamic()
     - step_change_dynamic()
     - pmu_reference_bandwidth_dynamic()
     - pmu_reference_ramp_freq_dynamic()
     - pmu_reference_step_change_dynamic()

   * steady_state;
     - frequency_steady()
     - harmonic_steady()
     - magnitude_steady()
     - out_of_band_steady()
     - pmu_reference_freq_steady()
     - pmu_reference_harmonic_steady()
     - pmu_reference_mag_steady()
     - pmu_reference_out_of_band_steady()
     - ss_filter_samples_mono_ph()
     - ss_filter_samples_three_ph()
     - ss_generic();

 * c37118.2;
   - generate_command_frame()
   - read_cfg()
   - read_data()
   - read_header()

 * data;

### Description: ###
* communication: Module that contain all functions about communication, the module abstract the socket functions to user.
* support: Module that contain functions of other libs.
* c37118.1: Contain the functions related to the performance tests of C37118.1-2011 (Communication functions).
* c37118.2: Contain the functions related to the performance tests of C37118.2-2011 (Measurement functions).
* data: Folder to save frames received of the PMU in test.


## Instruction: ##
* Is need started the library with function `start_lib()` to initialize all dependences.
* To all tests is need that PMU in test send the phasors: VA, VB, VC and S1.
