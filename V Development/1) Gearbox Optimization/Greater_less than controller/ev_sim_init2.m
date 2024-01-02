% Run this file to see the results 

clear all;			% Initialize workspace
% close all;			% Close graphic windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load initialization data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %bolt_ev_sim_data;
tesla_sim_data2;
disp('Data loaded sucessfully!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Simulation initial conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ess_init_soc=0.6;        %initial battery state of charge (1.0 = 100% charge)

K_factor_in=2;           %K factor for rear transmision one speed operation
K_low=1;                 %K factor for low speed mode transmission
K_high=2;                %K factor for high speed mode transmission

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% load driving cycle %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drivingcycle = 2; %1:EPA City cycle %2:EPA Highway cycle
switch (drivingcycle)
    case 1
        %load EPA cycle (compare the results of fuel comsuption
        load CYC_UDDS.mat; % Load driving cycle (EPA urban cycle)
        
        time_final = 1*length(cyc_mph(:,2));
        
    case 2
        %load EPA cycle (compare the results of fuel comsuption
        load CYC_HWFET.mat; % Load driving cycle (EPA highway cycle)
        time_final = 1*length(cyc_mph(:,2));
%     case 3
%         %load trapezoid cycle
%         load CYC_trapezoid_higher.mat;
%         time_final = 1*length(cyc_mph(:,2));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% All Control related parameters  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% driver controller parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Kf_c = 1/10;
Kp_c = 30;
Ti_c = 60;
Tt_c = 65;
v_max_c = 100;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BATTERY CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SOC boundaries
high_soc=0.95;  % highest desired battery state of charge
low_soc=0.10;   % below this value, the engine must be on and charge
stop_soc=0.10;  % lowest desired battery state of charge, avoid reaching this point
regstop_soc=0.9;  % reach this point, regenerative brake will stop


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation and Results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simulation_case=1; %1:normal simulation 2:fuel consumption with soc correction
switch simulation_case
    case 1
        time_step = 0.05;
        sim('initial_model2.slx');
        display('Simulation completed!');
%         prius_sim_plot;
        
    case 2
        time_step = 0.02;
        soc_init_index = [0.5 0.6 0.7];
        for simrun=1:length(soc_init_index)
            ess_init_soc=soc_init_index(simrun);
            sim('prius_rulebased_v1.mdl');
            display(['Simulation ',num2str(simrun),' completed!']);
            mpg(simrun)=distance_in_mile(2)/fuel_consum_in_g(2)*1000*3.8*0.75;

            figure;
            plot(timet,demand_spd,...
                'r:',timet,actual_spd,...
                'b-',timet,actual_spd,'g-.','LineWidth',2);
            set(gca,'fontSize',12,'fontWeight','bold')
            xlabel('time (sec)','fontWeight','bold','fontSize',12);
            title(['Main Results:  Total travel ',num2str(distance_in_mile(2)),...
                    ' Miles;  Fuel ',num2str(mpg(simrun)),' MPG.'],'fontWeight','bold','fontSize',12);
            hold on;
            [AX,H1,H2] = plotyy(timet,actual_spd,...
                timet,output_soc,'plot');
            set(get(AX(1),'Ylabel'),'String','Vehicle Speed (MPH)','fontWeight','bold','fontSize',12)
            set(get(AX(2),'Ylabel'),'String','State of Charge','fontWeight','bold','fontSize',12)
            set(H2,'LineStyle','-.')
            set(H2,'LineWidth',2)
            set(AX(2),'fontSize',12,'fontWeight','bold')
            % set(AX(2),'YLim',[0.45 0.9])
            set(gca,'fontSize',12,'fontWeight','bold')
            legend('Reference Speed','Actual Speed','SOC')
            grid;
            
            soc_dif(simrun)=output_soc(length(output_soc))-ess_init_soc;
        end
        mpg_final=interp1(soc_dif,mpg,0);
        figure;
        plot(soc_dif,mpg,'b-',soc_dif,mpg,'r*','LineWidth',2);
        set(gca,'fontSize',12,'fontWeight','bold')
        xlabel('difference of soc (final-initial)','fontSize',12,'fontWeight','bold');
        ylabel('fuel consumption (MPG)','fontSize',12,'fontWeight','bold');
        title(['fuel consumption after soc correction: ',num2str(mpg_final),' MPG'],'fontSize',12,'fontWeight','bold');
end

%% Metrics

Max_Power_hp=max(0.00134102*Max_Power )          %Max power (hp)
Max_Torque_lbft=max(0.7375621493*Max_Torque)     %Max torque (lb*ft)
Max_Speed_mph=max(Max_Speed)                     %Max speed (miles/hr)
Efficiency_miles_kwh=Efficiency(end)             %Efficiency (miles/kWh)
Time=timet(end)                                  %Time (sec)

