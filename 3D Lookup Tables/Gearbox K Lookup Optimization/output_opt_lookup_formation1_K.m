clear all;
close all;
clc;

%% Sweeping input TA, speed, and torque

run ev_sim_init1

runtime=6;

d=5;                                                %Sweep dimension length (sim runs=d^3)

mtr_torque_Nm=linspace(0,1000,d);                  %motor torque (Nm)
mtr_speed_rad=linspace(0,6000*2*pi/60,d);          %motor speed (rad/sec)
K_input=[1 2];                                                   %Torque allocation percentage (TR=front motor, 1-TR=rear motor)

for i=1:d
    input_motor_torque=mtr_torque_Nm(i);  
    for j=1:d
        input_motor_speed=mtr_speed_rad(j);
        for k=1:2
            K=K_input(k);
            
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
K_lookup_pow_g=A;
figure(1)
mesh(mtr_torque_Nm,mtr_speed_rad,K_lookup_pow_g)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output K (1 or 2)')
title('Output Power (kW) Look Up')

%Vehicle output torque
[opt_output_torque,B]=max(output_torque,[],3);
K_lookup_tor_g=B;
figure(2)
mesh(mtr_torque_Nm,mtr_speed_rad,K_lookup_tor_g)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output K (1 or 2)')
title('Output Torque (Nm) Look Up')

%%Vehicle output efficiency
[opt_output_efficiency,C]=max(efficiency,[],3);
K_lookup_eff_g=C;
figure(3)
mesh(mtr_torque_Nm,mtr_speed_rad,K_lookup_eff_g)
xlabel('Input Torque (Nm)'), ylabel('Input Motor Speed (rad/sec)'), zlabel('Output K (1 or 2)')
title('Efficiency (miles/kWh) Look Up')

save('K_lookup_eff_g','K_lookup_eff_g');
save('K_lookup_tor_g','K_lookup_tor_g');
save('K_lookup_pow_g','K_lookup_pow_g');

