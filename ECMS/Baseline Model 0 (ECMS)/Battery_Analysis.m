%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load initialization data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tesla_sim_data0;
disp('Data loaded sucessfully!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulation initial conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_init_soc=0.9;        %initial battery state of charge (1.0 = 100% charge)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BATTERY CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SOC boundaries
high_soc=0.95;  % highest desired battery state of charge
low_soc=0.10;   % below this value, the engine must be on and charge
stop_soc=0.10;  % lowest desired battery state of charge, avoid reaching this point
regstop_soc=0.9;  % reach this point, regenerative brake will stop

power_step=5;   %Number of simulations between max and min power

power_discharge=linspace(ess_max_kwhr_cap*1000/2,ess_max_kwhr_cap*1000*2,power_step);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation and Results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:power_step
        input_power=power_discharge(i);
        sim ('Battery_Model');
        
        %input_energy_efficiency=energy_input./batt_cap_used;     %battery input energy/used SOC capacity
        %output_energy_efficiency=energy_output./batt_cap_used;   %battery output energy/used SOC capacity

        %input_power_efficiency=power_input./power_batt;          %battery input power/SOC discharge power
        %output_power_efficiency=power_output./power_batt;        %battery output power/SOC discharge power
        power_output=power_eff.*power_input;                     %Discharge power times battery efficiency
        
        figure(1)
        subplot(power_step,1,i)
        plot(fliplr(output_soc), power_eff)
        title('Output Power Efficiency vs SOC')
        
        figure(2)
        subplot(power_step,1,i)
        plot(tout, power_output, tout, power_input)
        title('Input Power vs Time (sec)')
end