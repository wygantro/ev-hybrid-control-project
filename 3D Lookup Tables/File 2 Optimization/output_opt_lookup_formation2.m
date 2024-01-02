clear all;
close all;
clc;

%% Sweeping input TA, speed, and torque

run ev_sim_init2

runtime=3;

d=5;                                                %Sweep dimension length (sim runs=d^3)

mtr_torque_Nm=linspace(0,1000,d);                  %motor torque (Nm)
mtr_speed_rad=linspace(0,6000*2*pi/60,d);          %motor speed (rad/sec)
torque_allocation=linspace(0,1,d);                  %Torque allocation percentage (TR=front motor, 1-TR=rear motor)


for i=1:d
    input_motor_torque=mtr_torque_Nm(i);  
    for j=1:d
        input_motor_speed=mtr_speed_rad(j);
        for k=1:d
            TA=torque_allocation(k);
                   
                   sim('output_opt_lookup_formation_sim2.slx');
                   output_power(i,j,k)=mean(output_veh_power);
                   output_torque(i,j,k)=mean(output_motor_torque);
                   efficiency(i,j,k)=output_efficiency(end);
        end
    end
end

%Vehicle output power
[opt_output_power,A]=max(output_power,[],3);
opt_output_power_location2=A*1/k;
figure(1)
mesh(mtr_speed_rad,mtr_torque_Nm,opt_output_power_location2)
ylabel('Input Torque (Nm)'), xlabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Output Power (kW) Look Up')

%Vehicle output torque
[opt_output_torque,B]=max(output_torque,[],3);
opt_output_torque_location2=B*1/k;
figure(2)
mesh(mtr_speed_rad,mtr_torque_Nm,opt_output_torque_location2)
ylabel('Input Torque (Nm)'), xlabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Output Torque (Nm) Look Up')

%Vehicle output efficiency
[opt_output_efficiency,C]=max(efficiency,[],3);
opt_output_efficiency_location2=C*1/k;
figure(3)
mesh(mtr_speed_rad,mtr_torque_Nm,opt_output_efficiency_location2)
ylabel('Input Torque (Nm)'), xlabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Efficiency (miles/kWh) Look Up')

%sim('lookup_table_test.slx');
save('opt_output_power_location2','opt_output_power_location2')
save('opt_output_torque_location2','opt_output_torque_location2')
save('opt_output_efficiency_location2','opt_output_efficiency_location2')
