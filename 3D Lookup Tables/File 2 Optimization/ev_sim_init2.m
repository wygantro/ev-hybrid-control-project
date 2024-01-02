% Run this file to see the results 

clear all;			% Initialize workspace
% close all;			% Close graphic windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load initialization data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %bolt_ev_sim_data;
tesla_sim_data;
disp('Data loaded sucessfully!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulation initial conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_init_soc=0.6;        %initial battery state of charge (1.0 = 100% charge)

K_factor_in=2;           %K factor for rear transmision one speed operation
K_low=1;                 %K factor for low speed mode transmission
K_high=2;                %K factor for high speed mode transmission

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% All Control related parameters  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% driver controller parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Kf_c = 1/10;
Kp_c = 30;
Ti_c = 60;
Tt_c = 65;
v_max_c = 100;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BATTERY CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SOC boundaries
high_soc=0.95;  % highest desired battery state of charge
low_soc=0.10;   % below this value, the engine must be on and charge
stop_soc=0.10;  % lowest desired battery state of charge, avoid reaching this point
regstop_soc=0.9;  % reach this point, regenerative brake will stop

