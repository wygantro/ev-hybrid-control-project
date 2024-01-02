% Vehicle parameters
% SimModels

% Parameters
grav=9.81;              % gravity constant

% Unit Conversion factors
rs_rpm=30/pi;           % rad/sec to rpm
rpm_rps=pi/30;
mps_mph=3600/1609;          % m/s to mph
mph_mps=1609/3600;

% Engine
Je_engine=0.25;        % engine + impeller inertia (kg-m^2)
load('engine_parameters.mat');

% Driveline + Vehicle
Mv=2000;                % Vehicle mass [kg]
Iw=2.5;                 % Wheel + axle inertia
dens=1.225;             % density of air [kg/m^3]
Cd=0.40;                % drag coefficient
Af=1.808*1.400;         % Frontal area [m^2]
Rw=0.371;               % Tire radius [m]
K1=0.015;               % Rolling resistance
FR=3.02;                % Final drive ratio
Brake_c=3000;           % Max. brake force [N]

% TC
SR_map_spline;

% Transmission ratio
gear_level=[1 2 3 4];
gear_TR=[104/34 182/112 1.000 78/112];
efficiency=[0.987 0.987 1.00 0.994];

