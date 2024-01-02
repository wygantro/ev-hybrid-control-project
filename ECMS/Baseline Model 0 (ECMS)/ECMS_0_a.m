clear all;
close all;
clc;

%%

drivingcycle = 1; %1:EPA City cycle %2:EPA Highway cycle

mtr_speed_rad = [600:1350:6000]*2*pi/60;       %motor speed (rad/sec)
torque_allocation=[0:.25:1];                   %Torque allocation percentage (TR=front motor, 1-TR=rear motor)

for i=1:5
    TA=torque_allocation(i);
        for j=1:5
            motor_speed=mtr_speed_rad(j);
                   run ('ev_sim_init0a.m');
                   output_power(i,j)=mean(veh_power);
                   input_power(i,j)=mean(input_power_batt);
        end
end

opt_mtr_speed = [600:340:4000];
opt_TA = [.1:.08:.9];
opt_input_power = interp2([600:1350:6000], torque_allocation, input_power, opt_mtr_speed, opt_TA);
opt_output_power = interp2([600:1350:6000]*2*pi/60, torque_allocation, output_power,opt_mtr_speed*2*pi/60, opt_TA);

SC_eng = 0.07;     % conversion factor from P_batt to equivalent fuel consumption
Eff_elec = 0.92;
soc_L = 0.5;
soc_H = 0.7;
soc = [0.4:0.01:0.8];
x_soc =  (soc - (soc_L+soc_H)/2)/(soc_H-soc_L);
f_soc = 1-(1-0.7.*x_soc).*x_soc.^3;                % 1 by41

figure(1)
plot(soc, f_soc)
xlabel('SOC'), ylabel('f_S_O_C')

veh_power1=[1000:80:8000];
power_motor = interp1(opt_output_power, opt_input_power, veh_power1, 'linear');

for i = 1:120,
  Pd(i) = i*1.0;	% Pd from 1 to 120kw
  P_motor(i,:) = Pd(i)*ones(1,120) - Peng; 
  
  for j = 1:120,
    if P_motor(i,j) > 0
      P_batt(i,j) = P_motor(i,j)/Eff_elec;  % assume a constant battery/power electronics efficiency
    else                                    % Can be modified to be SOC dependent
      P_batt(i,j) = P_motor(i,j)*Eff_elec;  % Charging efficiency does not need to be 
    end                                     % the same as discharging efficiency but here we use the same
  end

  for k = 1:41, 
    fuel_batt(k,i,:) = f_soc(k)*SC_eng*P_batt(i,:)/Eff_elec;
    fuel_total(k,i,:) = reshape(fuel_engine,1,1,120) + fuel_batt(k,i,:) ;  
  end
end
