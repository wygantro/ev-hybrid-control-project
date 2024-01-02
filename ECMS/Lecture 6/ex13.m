%Ex13.m
% generate engine power command map using the ECMS concept
% for a parallel HEV
clear all;
close all;

load engine_parameters
Throttle_grid=[0:5:100];
engine_speed = [600:200:6000]*2*pi/60;    % rad/sec
for k = 1:21,
    for j = 1:28,
       engine_out_power(k,j) = engine_speed(j)*engine_torque(k,j)/1000;    % engine out power (kW)
    end
end

opt_eng_speed = [600: 3400/48: 4000];
opt_throttle = [18:1:66];
opt_fuel = interp2([600:200:6000], Throttle_grid, fuel_map, opt_eng_speed, opt_throttle);
opt_power = interp2([600:200:6000]*2*pi/60, Throttle_grid, engine_out_power, ...
                    opt_eng_speed*2*pi/60, opt_throttle);
                
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

Peng = [1:1:120];
fuel_engine = interp1(opt_power, opt_fuel, Peng, 'linear');
 
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

% Showing example at a particular case, where Pd and SOC are specified by
% index1 and index2, respectively
index1 = 60;    % index1 here = Pd (kW)
index2 = 21;    % index2 indicate which SOC level in [0.4:0.01:0.8] is selected 

%figure(2)
%subplot(411), plot(Peng, fuel_engine)
%xlabel('Engine Power (kW)'), ylabel('Fuel_e_n_g')
%title('Pd = 60kW, SOC = 0.6')
%subplot(412), plot(Peng, P_batt(index1,:))
%xlabel('Engine Power (kW)'), ylabel('Battery power (kW)')
%subplot(413), plot(Peng, squeeze(fuel_batt(index2,index1,:)))
%xlabel('Engine Power (kW)'), ylabel('Fuel_b_a_t_t')
%subplot(414), plot(Peng, squeeze(fuel_total(index2,index1,:)))
%xlabel('Engine Power (kW)'), ylabel('Total fuel')
%hold on
%[fuel_min, index] = min(fuel_total(index2,index1,:));
%plot(Peng(index), fuel_min, 'r*'), hold off

figure(3)
for index1 = 1:120                 % Pd from 1 to 120 kW
    for index2 = 1:41               % SOC 0.4:0.01:0.8
        [fuel_min(index2, index1), index] = min(fuel_total(index2,index1,:));
        Peng_optimal(index2, index1) = Peng(index);
    end
end

mesh(Pd, soc, Peng_optimal)
xlabel('Pd (kW)'), ylabel('SOC'), zlabel('Optimal engine power (kW)')

