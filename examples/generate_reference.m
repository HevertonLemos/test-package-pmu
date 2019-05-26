clc
clear all

source("../start_lib.m");

start_lib("../");

voltage_magnitude = 115;
current_magnitude = 5;
Initial_frequency = 45;
delta_frequency = 1;
time_per_step = 2; % two seconds
number_of_steps = 11;
initial_angle = 0;
frames_per_second = 50;
time = linspace(0, number_of_steps * time_per_step,
                frames_per_second * number_of_steps * time_per_step);
phasor = struct();
tmp_phasor = pmu_reference_1ph_freq_delta_freq(voltage_magnitude,
                                              Initial_frequency,
                                              delta_frequency,
                                              number_of_steps,
                                              time_per_step,
                                              frames_per_second,
                                              initial_angle);
phasor.VA = tmp_phasor.VA;
phasor.frequency = tmp_phasor.frequency;
phasor.rocof = tmp_phasor.rocof;
tmp_phasor = pmu_reference_1ph_freq_delta_freq(voltage_magnitude,
                                              Initial_frequency,
                                              delta_frequency,
                                              number_of_steps,
                                              time_per_step,
                                              frames_per_second,
                                              initial_angle + 120);
phasor.VB = tmp_phasor.VA;
tmp_phasor = pmu_reference_1ph_freq_delta_freq(voltage_magnitude,
                                              Initial_frequency,
                                              delta_frequency,
                                              number_of_steps,
                                              time_per_step,
                                              frames_per_second,
                                              initial_angle - 120);

phasor.VC = tmp_phasor.VA;
tmp_phasor = pmu_reference_1ph_freq_delta_freq(current_magnitude,
                                              Initial_frequency,
                                              delta_frequency,
                                              number_of_steps,
                                              time_per_step,
                                              frames_per_second,
                                              initial_angle);
phasor.IA = tmp_phasor.VA;
tmp_phasor = pmu_reference_1ph_freq_delta_freq(current_magnitude,
                                              Initial_frequency,
                                              delta_frequency,
                                              number_of_steps,
                                              time_per_step,
                                              frames_per_second,
                                              initial_angle + 120);
phasor.IB = tmp_phasor.VA;
tmp_phasor = pmu_reference_1ph_freq_delta_freq(current_magnitude,
                                              Initial_frequency,
                                              delta_frequency,
                                              number_of_steps,
                                              time_per_step,
                                              frames_per_second,
                                              initial_angle - 120);
phasor.IC = tmp_phasor.VA;                                              

plot(time, phasor.VA(1,:));
figure();
plot(time, phasor.VA(2,:));
figure();
plot(time, phasor.frequency);
figure();
plot(time, phasor.rocof);