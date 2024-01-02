
clear all
close all
clc
clf
clear

Rt = 0.406 * 0.96;

GR1=9;
GR2=6;

%IM map

wshift=[150 150 150 125 160 160];
dwshift=0.9.*wshift;
Tshift=330*GR2.*[0.01 0.15 0.25 0.5 0.75 1];
figure(1)
plot(wshift,Tshift,'-r',dwshift,Tshift,'-.b');
title(['IM shift map (GR1 - 9 and GR2 - 6)']);
% ,num2str(GR1)
xlim([0 250]);ylim([0 300*GR2]);
xlabel('Vehicle Speed[km/h]');ylabel('GR2 Max Throttle[Nm]');

%SRM map

wshift=[200 200 300 300 300 300];
dwshift=0.9.*wshift;
Tshift=600*GR2.*[0.01 0.15 0.25 0.5 0.75 1];
figure(2)
plot(wshift,Tshift,'-r',dwshift,Tshift,'-.b');
title(['SRM shift map (GR1 - 9 and GR2 - 6)']);
% ,num2str(GR1)
xlim([0 350]);ylim([0 600*GR2]);
xlabel('Vehicle Speed[km/h]');ylabel('GR2 Max Throttle[Nm]');