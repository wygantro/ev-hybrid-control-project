% Tesla Model S 90kWhr assumptions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% electric motor parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_eff=0.9;
m_min_volts=200;	% minimum voltage for motor/controller set, V
% maximum continuous torque corresponding to speeds
m_peak_trq_SR = 660.28; %Nm  % SR motor specs from google
m_peak_trq_IM = 329.46; %Nm  % IM motor specs from google  
m_peak_pwr = 310; %kW  % 
m_map_spd = [0	100	250	500	1000	1500	2000	2500	3000	4000	4500	5500	6000	7000	8000	9000	10000]*(2*pi)/60;
m_max_trq_SR = min(m_peak_trq_SR, m_peak_pwr*1000./m_map_spd); % estimation by published peak torque and power
m_max_trq_IM = min(m_peak_trq_IM, m_peak_pwr*1000./m_map_spd); % estimation by published peak torque and power
m_max_gen_trq=-m_max_trq_SR-m_max_trq_IM; % estimate

% SR efficiency map
       ap00 =      -69.58  ;
       ap10 =      0.5123  ;
       ap01 =       11.22  ;
       ap20 =  -0.0007943 ;
       ap11 =    0.009736 ;
       ap02 =     -0.1665  ;
       ap30 =   3.794e-07  ;
       ap21 =  -4.587e-07  ;
       ap12 =   0.0003316  ;
       ap03 =   0.0006218 ;

% IM efficiency map coefficients
       p00 =      -215.8  ;
       p10 =       4.164  ;
       p01 =       3.368  ;
       p20 =   -0.009417  ;
       p11 =     0.04408 ;
       p02 =     -0.0178  ;
       p30 =   5.161e-06 ;
       p21 =   5.981e-06 ;
       p12 =   9.874e-05  ;
       p03 =   6.515e-05 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% battery parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reference seed ADVISOR data file:  ESS_NIMH6.m     
ess_description='Spiral Wound NiMH Used in Insight & Japanese Prius';
% Assume fix temperature of the model
ess_fixtemp=25;
enable_stop=1;

% SOC RANGE over which data is defined
ess_soc=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];  % (--)
% The following data was obtained at 25 deg C.  Assume all values are the same for all temperatures
ess_tmp=[0 25];  % (C) place holder for now

% LOSS AND EFFICIENCY parameters (from ESS_Prius_pack reference) 
% Parameters vary by SOC horizontally, and temperature vertically
ess_max_kwhr_cap = 90; % kWhr, % Tesla website
ess_max_ah_cap=ess_max_kwhr_cap*1000/350*[1 1];	% (A*h), max. capacity / nominal voltage

% module's resistance to being discharged, indexed by ess_soc and ess_tmp
% The discharge resistance is the average of 4 tests from 10 to 90% soc at the following
%  discharge currents: 6.5, 6.5, 18.5 and 32 Amps
%  The 0 and 100 % soc points were extrapolated
ess_r_dis=[
	0.0377	0.0338	0.0300	0.0280	0.0275	0.0268	0.0269	0.0273	0.0283	0.0298	0.0312
	0.0377	0.0338	0.0300	0.0280	0.0275	0.0268	0.0269	0.0273	0.0283	0.0298	0.0312   ]*0.1; %estimated resistance for energy cell battery

% module's resistance to being charged, indexed by ess_soc and ess_tmp
% The discharge resistance is the average of 4 tests from 10 to 90% soc at the following
%  discharge currents: 5.2, 5.2, 15 and 26 Amps
%  The 0 and 100 % soc points were extrapolated
ess_r_chg=[
   0.0235	0.0220	0.0205	0.0198	0.0198	0.0196	0.0198	0.0197	0.0203	0.0204	0.0204
	0.0235	0.0220	0.0205	0.0198	0.0198	0.0196	0.0198	0.0197	0.0203	0.0204	0.0204   ]*0.1; 
   
% module's open-circuit (a.k.a. no-load) voltage, indexed by ess_soc and ess_tmp
ess_voc=[
	7.2370	7.4047	7.5106	7.5873	7.6459	7.6909	7.7294	7.7666	7.8078	7.9143	8.3645
	7.2370	7.4047	7.5106	7.5873	7.6459	7.6909	7.7294	7.7666	7.8078	7.9143	8.3645
];  

% LIMITS (from ESS_Prius_pack)
ess_min_volts=6; % 1 volt per cell times 6 cells lowest from data was 255V so far 8/26/99
ess_max_volts=9; % 1.5 volts per cell times 6 cells highest from data so far was 361V 8/26/99

% OTHER DATA (from ESS_Prius_pack except where noted)
ess_module_num=40;  %20 modules in INSIGHT pack, 40 modules in Prius Pack

ess_cap_scale=1; % scale factor for module max ah capacity
ess_res_scale_fun=inline('(x(1)*ess_module_num+x(2))/(x(3)*ess_cap_scale+x(4))','x','ess_module_num','ess_cap_scale');
ess_res_scale_coef=[1 0 1 0]; % coefficients in ess_res_scale_fun



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M_total = (4650+300)/2.2046; % kg curb + 300 lbs passengers
g_gravity = 9.81;
R_tire = 0.335; % meter 19 inch tire
A_frontal = 2.8; % m^2 estimated from vehicle specs (56 inch by 77 inch)
rho_air = 1.2;			% Air density % kg/m^3
C_d = 0.24;				% Aerodynamic drag coefficient, web claim
f_rolling = 0.018; % Rolling resistance range on efficient tires

% gear ratios
FR = 9.73;
%% TA Efficiency Lookup
d=5;                                                %Sweep dimension length (sim runs=d^3)

mtr_torque_Nm=linspace(0,1000,d);                  %motor torque (Nm)
mtr_speed_rad=linspace(0,6000*2*pi/60,d);          %motor speed (rad/sec)
torque_allocation=linspace(0,1,d);                  %Torque allocation percentage (TR=front motor, 1-TR=rear motor)

load('K_lookup_eff_g');
K_lookup_real_eff=K_lookup_eff_g.*ones(d,d);

load('K_lookup_tor_g');
K_lookup_real_tor=K_lookup_tor_g.*ones(d,d);

load('K_lookup_pow_g');
K_lookup_real_pow=K_lookup_pow_g.*ones(d,d);