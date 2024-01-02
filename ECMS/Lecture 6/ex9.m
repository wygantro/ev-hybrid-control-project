% ex9.m
% Drive cycle and driving power calculation

clear all, close all
load CYC_HWFET.mat              % Load the highway cycle
time_highway = cyc_mph(:,1);
speed_highway = cyc_mph(:,2);
figure(1), subplot(221)
plot(time_highway, speed_highway)
xlabel('Time (Sec)')
ylabel('Speed (mph)')
Title('EPA highway cycle')

clear cyc_mph
load CYC_UDDS.mat              % Load the highway cycle
time_urban = cyc_mph(:,1);
speed_urban = cyc_mph(:,2);
subplot(222)
plot(time_urban, speed_urban)
xlabel('Time (Sec)')
ylabel('Speed (mph)')
Title('EPA Urban cycle')

m = 1800;
g = 9.81;
rolling_resistance_coeff = 0.015;
aero_dynamic_drag_coeff = 0.4;
road_grad = 0;                  % road grade = 0 rad

N = size(time_highway, 1);
speed_highway = speed_highway*1602/3600;  % Change the unit of speed to m/sec
distance_highway = 0;

for i = 1:N-1,
    accel_highway(i) = (speed_highway(i+1) - speed_highway(i))/1.0;  % delta_T = 1 sec
    F_resistant_highway(i) = rolling_resistance_coeff*m*g*cos(road_grad) ...
        +0.5*1.202*aero_dynamic_drag_coeff*speed_highway(i)^2 ...
        + m*g*sin(road_grad);            
    power_highway(i) = (m*accel_highway(i) + F_resistant_highway(i))*speed_highway(i);   % Power = F*V
    distance_highway = distance_highway + speed_highway(i);
end

subplot(223)
plot(time_highway(1:N-1), power_highway)
xlabel('Time (Sec)')
ylabel('Power (Watt)')
Title('EPA highway cycle')

N = size(time_urban, 1);
speed_urban = speed_urban*1602/3600;  % Change the unit of speed to m/sec
distance_urban = 0;

for i = 1:N-1,
    accel_urban(i) = (speed_urban(i+1) - speed_urban(i))/1.0;  % delta_T = 1 sec
    F_resistant_urban(i) = rolling_resistance_coeff*m*g*cos(road_grad) ...
        +0.5*1.202*aero_dynamic_drag_coeff*speed_urban(i)^2 ...
        + m*g*sin(road_grad);            
    power_urban(i) = (m*accel_urban(i) + F_resistant_urban(i))*speed_urban(i);   % Power = F*V (W)
    distance_urban = distance_urban + speed_urban(i);
end

subplot(224)
plot(time_urban(1:N-1), power_urban)
xlabel('Time (Sec)')
ylabel('Power (Watt)')
Title('EPA Urban cycle')

