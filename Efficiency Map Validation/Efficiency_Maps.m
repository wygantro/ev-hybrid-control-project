
clear all
clc
clf
clear

%% IM efficiency map

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
       
mtr_speed=[6 12000/6:12000/6:12000];
mtr_torque=[5 350/7:350/7:350];
mtr_speed_rad=mtr_speed.*(2*pi/60);
mtr_power1=zeros(8,7);
mtr_loss1=zeros(8,7);

for j=1:7
    for i=1:8
        mtr_power1(i,j)=mtr_torque(i)*mtr_speed_rad(j);
        mtr_loss1(i,j)= p00+p10*mtr_speed_rad(j)+p20*mtr_speed_rad(j)^2+p30*mtr_speed_rad(j)^3+...
              p01*mtr_torque(i)+p11*mtr_speed_rad(j)*mtr_torque(i)+p21*mtr_speed_rad(j)^2*mtr_torque(i)+...
              p02*mtr_torque(i)^2+p12*mtr_speed_rad(j)*mtr_torque(i)^2+...
              p03*mtr_torque(i)^3;  
              
    end
end

mtr_loss1(mtr_loss1<0)=100;
mtr_eff_f=min(96,(mtr_power1-mtr_loss1)./mtr_power1.*100);
mtr_eff_f(mtr_eff_f<50)=76;

mtr_eff3=reshape(mtr_eff_f,[8,7]);


K=330/350;
mtr_torque=mtr_torque.*K;

figure(1)
subplot(2,1,1)
[C,h]=contourf(mtr_speed,mtr_torque,mtr_eff3,20);
clabel(C,h)
colorbar
colormap(jet(256));
lim=caxis;
caxis([80 96]);
hold on

% b1=[350 350 350 350 270 210 130 115];
% c1=[0 2000 4000 4500 6000 8000 10000 12000];
b1=[330 330 330 330 330 193e3/(2*pi*8000/60) 193e3/(2*pi*10000/60) 193e3/(2*pi*12000/60)];
c1=[0 2000 4000 4500 6100 8000 10000 12000];

plot(c1,b1,'-k','LineWidth',4);
ylabel('Motor torque [Nm]');xlabel('Motor Speed [rpm]');
ylim([0 360]);
title('IM Efficiency Map');


%% SRM efficiency map
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

mtr_speed=[6 14000/7:14000/7:14000];
mtr_torque=[5 25 50:50:200];

mtr_speed_rad=mtr_speed.*(2*pi/60);

mtr_power1=zeros(6,8);
mtr_loss1=zeros(6,8);

for j=1:8
    for i=1:6
        mtr_power1(i,j)=mtr_torque(i)*mtr_speed_rad(j);
        mtr_loss1(i,j)= ap00+ap10*mtr_speed_rad(j)+ap20*mtr_speed_rad(j)^2+ap30*mtr_speed_rad(j)^3+...
              ap01*mtr_torque(i)+ap11*mtr_speed_rad(j)*mtr_torque(i)+ap21*mtr_speed_rad(j)^2*mtr_torque(i)+...
              ap02*mtr_torque(i)^2+ap12*mtr_speed_rad(j)*mtr_torque(i)^2+...
              ap03*mtr_torque(i)^3;  
       
%        
    end
end

mtr_loss1(mtr_loss1<0)=100;
mtr_eff_f=min(96,(mtr_power1-mtr_loss1)./mtr_power1.*100);
mtr_eff_f(mtr_eff_f<50)=80;

mtr_eff3=reshape(mtr_eff_f,[6,8]);

K=600/200;
mtr_torque=mtr_torque.*K;
subplot(2,1,2)
[C,h]=contourf(mtr_speed,mtr_torque,mtr_eff3,20);
clabel(C,h)
colorbar
colormap(jet(256));
lim=caxis;
caxis([80 97]);
hold on
% b1=[200 200 200 150 65 50 42 36 30];
% c1=[0 2000 3000 4000 6000 8000 10000 12000 14000];
b1=[600 600 600 600 600 375e3/(2*pi*8000/60) 375e3/(2*pi*10000/60) 375e3/(2*pi*12000/60) 375e3/(2*pi*14000/60)];
c1=[0 2000 4000 4500 5950 8000 10000 12000 14000];
plot(c1,b1,'-k','LineWidth',4);
ylabel('Motor torque [Nm]');xlabel('Motor Speed [rpm]');
ylim([0 610]);
title('SRM Efficiency Map');
