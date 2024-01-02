clear all;
close all;
clc;

%% Sweeping input TA, speed, and torque

run ev_sim_init1

runtime=6;

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
                   
                   sim('output_opt_lookup_formation_sim1.slx');
                   output_power(i,j,k)=mean(output_veh_power);
                   output_torque(i,j,k)=mean(output_motor_torque);
                   efficiency(i,j,k)=output_efficiency(end);
        end
    end
end

eff2=max(output_power,[],3);
save('eff2','eff2');

tor2=max(output_power,[],3);
save('tor2','tor2');

pow2=max(output_power,[],3);
save('pow2','pow2');


%Vehicle output power
[opt_output_power,A]=max(output_power,[],3);
opt_output_power_location12=A*1/k;
figure(1)
mesh(mtr_torque_Nm,mtr_speed_rad,opt_output_power_location12)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Output Power (kW) Look Up')

%Vehicle output torque
[opt_output_torque,B]=max(output_torque,[],3);
opt_output_torque_location12=B*1/k;
figure(2)
mesh(mtr_torque_Nm,mtr_speed_rad,opt_output_torque_location12)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Output Torque (Nm) Look Up')

%%Vehicle output efficiency
[opt_output_efficiency,C]=max(efficiency,[],3);
opt_output_efficiency_location12=C*1/k;
figure(3)
mesh(mtr_torque_Nm,mtr_speed_rad,opt_output_efficiency_location12)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output TA (%)')
title('Efficiency (miles/kWh) Look Up')

%sim('lookup_table_test.slx');

save('opt_output_efficiency_location12','opt_output_efficiency_location12')
save('opt_output_power_location12','opt_output_power_location12')
save('opt_output_torque_location12','opt_output_torque_location12')


load('opt_output_efficiency_location11');
load('eff1');

load('opt_output_power_location11');
load('pow1');

load('opt_output_torque_location11');
load('tor1');

K_lookup2=eff1<eff2;
K_lookup1=eff1>eff2;
K_lookup_eff=K_lookup2;
save('K_lookup_eff','K_lookup_eff');
opt_output_efficiency_location112=K_lookup1.*opt_output_efficiency_location11+K_lookup2.*opt_output_efficiency_location12;
save('opt_output_efficiency_location112','opt_output_efficiency_location112');

K_lookup2=tor1<tor2;
K_lookup1=tor1>tor2;
K_lookup_tor=K_lookup2;
save('K_lookup_tor','K_lookup_tor');
opt_output_torque_location112=K_lookup1.*opt_output_torque_location11+K_lookup2.*opt_output_torque_location12;
save('opt_output_torque_location112','opt_output_torque_location112');

K_lookup2=pow1<pow2;
K_lookup1=pow1>pow2;
K_lookup_pow=K_lookup2;
save('K_lookup_pow','K_lookup_pow');
opt_output_power_location112=K_lookup1.*opt_output_power_location11+K_lookup2.*opt_output_power_location12;
save('opt_output_power_location112','opt_output_power_location112');
