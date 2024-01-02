clear all;
close all;
clc;

% fuel cell efficiency
opt_fc_power = [0:10:100];
opt_hydrogen_rate = [0 0.15 0.18 0.29 0.4 0.55 0.68 0.79 0.9 1.1 1.3];
fc_batt = 0.01; % conversion factor from P_batt to equivalent fuel cell consumption
Eff_elec = 1; % 100% electric efficiency between battery and motor

% SOC weighting factor
soc_L = 0.5;
soc_H = 0.7;
soc = [0.4:0.01:0.8];
x_soc = (soc - (soc_L+soc_H)/2)/(soc_H-soc_L);
f_soc = 1-(1-0.7.*x_soc).*x_soc.^3; % 1 by41

% Sweep power demand range and calculate power combination options
for i = 1:12,
    Pd(i) = i*10; % Pd from 10kw to 120kw
    P_batt(i,:) = Pd(i) - opt_fc_power;
        for k = 1:41,
            hydro_batt(k,i,:) = f_soc(k)*fc_batt*P_batt(i,:)/Eff_elec;
            fuel_total(k,i,:) = reshape(opt_hydrogen_rate,1,1,11) + hydro_batt(k,i,:) ; % calculate equivalent fuel cell consumption
        end
end

% Showing consumption calculation at a Pd = 50kW and SOC = 60% case
% index1 and index2
index1 = 5; % index1 Pd = 50(kW)
index2 = 21; % index2 indicate which SOC level in [0.4:0.01:0.8] is selected

figure(1)
subplot(411), plot(opt_fc_power, opt_hydrogen_rate)
xlabel('FC Power (kW)'), ylabel('H_f_c (g/s)')
title('Pd = 50kW, SOC = 60%')
subplot(412), plot(opt_fc_power, P_batt(index1,:))
xlabel('FC Power (kW)'), ylabel('Battery power (kW)')
subplot(413), plot(opt_fc_power, squeeze(hydro_batt(index2,index1,:)))
xlabel('FC Power (kW)'), ylabel('H_b_a_t_t (g/s)')
subplot(414), plot(opt_fc_power, squeeze(fuel_total(index2,index1,:)))
xlabel('FC Power (kW)'), ylabel('Total hydrogen (g/s)')
hold on
[fuel_min, index] = min(fuel_total(index2,index1,:));
plot(opt_fc_power(index), fuel_min, 'r*'), hold off

figure(2)
for index1 = 1:12, % Pd from 1 to 120 kW
    for index2 = 1:41 % SOC 0.4:0.01:0.8
    [fuel_min(index2, index1), index] = min(fuel_total(index2,index1,:));
    fc_optimal(index2, index1) = opt_fc_power(index);
    end
end

mesh(Pd, soc, fc_optimal)
xlabel('Pd (kW)'), ylabel('SOC'), zlabel('Optimal FC power (kW)')