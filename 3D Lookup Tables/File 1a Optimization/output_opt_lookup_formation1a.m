clear all;
close all;
clc;

%% Sweeping input TA, speed, and torque

run ev_sim_init1a

runtime=30;

d=4;                                                %Sweep dimension length (sim runs=d^3)

mtr_torque_Nm=linspace(10,1600,d);                  %motor torque (Nm)
mtr_speed_rad=linspace(10,6000*2*pi/60,d);          %motor speed (rad/sec)
torque_allocation=linspace(0,1,d);                  %Torque allocation percentage (TR=front motor, 1-TR=rear motor)


  

for i=1:d
    input_motor_torque=mtr_torque_Nm(i);  
    for j=1:d
        input_motor_speed=mtr_speed_rad(j);
        for k=1:d
            TA=torque_allocation(k);
                   
                   sim('output_opt_lookup_formation_sim1a.slx');
                   output_power(i,j,k)=mean(output_veh_power);
                   output_torque(i,j,k)=mean(output_motor_torque);
                   efficiency(i,j,k)=output_efficiency(end);
        end
    end
end

%Vehicle output power
[opt_output_power,A]=max(output_power,[],3);
opt_output_power_location1a=A*1/k;
figure(1)
mesh(mtr_torque_Nm,mtr_speed_rad,opt_output_power_location1a)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Output Power (kW) Look Up')

%Vehicle output torque
[opt_output_torque,B]=max(output_torque,[],3);
opt_output_torque_location1a=B*1/k;
figure(2)
mesh(mtr_torque_Nm,mtr_speed_rad,opt_output_torque_location1a)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Output Torque (Nm) Look Up')

%Vehicle output efficiency
[opt_output_efficiency,C]=max(efficiency,[],3);
opt_output_efficiency_location1a=C*1/k;
figure(3)
mesh(mtr_torque_Nm,mtr_speed_rad,opt_output_efficiency_location1a)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Efficiency (miles/kWh) Look Up')

%sim('lookup_table_test.slx');

save('opt_output_power_location1a')
save('opt_output_torque_location1a')
save('opt_output_efficiency_location1a')
