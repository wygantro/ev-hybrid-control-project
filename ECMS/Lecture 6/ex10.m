% ex9 Efficient Engine Operations

load engine_parameters
% Load engine torque (N-m)
% and fuel comsumption (g/sec)
% Both of which is a 21 by 28 matrix
% The row (throttle) index is 0:5:100
% The column (engine speed) index is 600:200:6000 (rpm)

engine_speed = [600:200:6000]*2*pi/60;    % rad/sec
Throttle_grid=[0:5:100];

figure(2)
mesh([600:200:6000], Throttle_grid, fuel_map)
xlabel('Engine speed (rpm)')
ylabel('Throttle')
zlabel('fuel consumption (g/sec)')

for k = 1:21,
    for j = 1:28,
       engine_out_power(k,j) = engine_speed(j)*engine_torque(k,j)/1000;    % engine out power (kW)
       bsfc(k,j) = fuel_map(k,j)/engine_out_power(k,j);                     % BSFC = g/sec/kW
       if (bsfc(k,j) < 0)
           bsfc(k,j) = 0.3;
       elseif (bsfc(k,j) > 0.3)
           bsfc(k,j) = 0.3;
       end
    end
end
figure(3)
contour([600:200:6000], Throttle_grid, bsfc, 50)
xlabel('Engine speed (rpm)')
ylabel('Throttle')
title('BSFC g/sec/kW')
hold on, plot(2350, 43, 'd'), hold off

figure(4)
[CS,H]=contour([600:200:6000], Throttle_grid, engine_out_power);
clabel(CS), xlabel('Engine speed (rpm)')
ylabel('Throttle')
title('Engine power (kW)') 
hold on, plot(2350, 43, 'd'), hold off


