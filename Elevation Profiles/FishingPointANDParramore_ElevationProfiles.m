%%Elevation Profiles
close all; clear all; clc
fileread=csvread('FP_FullProfile.csv');
filereadB=csvread('PI_FullProfile.csv');
Distance=fileread(:,1);
NAVD88=fileread(:,2);
Distance=Distance(170:end);
NAVD88=NAVD88(170:end);
Distance=Distance-170;
NAVD88=NAVD88-0.6;
length=length(Distance);

DistanceB=filereadB(:,1);
NAVD88B=filereadB(:,2);
DistanceB=DistanceB(35:end);
NAVD88B=NAVD88B(35:end);
DistanceB=DistanceB-35;
NAVD88B=NAVD88B-0.6;

%Close a polygon
Distance(1)=0;
yy=0;
NAVD88=[NAVD88; yy];
xx=Distance(end);
Distance=[Distance; xx];
yy=0;
NAVD88=[NAVD88; yy];
xx=0;
Distance=[Distance; xx];

Distance(1)=0;
yy=0;
NAVD88B=[NAVD88B; yy];
xx=DistanceB(end);
DistanceB=[DistanceB; xx];
yy=0;
NAVD88B=[NAVD88B; yy];
xx=0;
DistanceB=[DistanceB; xx];

figure (1)
%%Subplot 1
subplot(2,1,1)
plot(Distance,NAVD88,'k','linewidth',2);
fill(Distance,NAVD88,'y')
title({['Fishing Point Longest Transect Profile']})
ylabel('Elevation (m)')
xlim([0 Distance(length)])
ylim([0 6.5])
box on
grid on
set(gca,'FontSize',12)
set(gca,'Xdir','reverse')
%Generic Axis Conversion
    % Convert y-axis values to percentage values by multiplication
    aa=[cellstr(num2str(get(gca,'xtick')'*0.001))]; 
    % Create a vector of '%' signs
    pct = char(ones(size(aa,1),1)*' '); %Blank if no character (%)
    % Append the '%' signs after the percentage values
    new_yticks = [char(aa),pct];
    % Reflect the changes on the plot
    set(gca,'xticklabel',new_yticks) 

%%Subplot 2
subplot(2,1,2)
plot(DistanceB,NAVD88B,'k','linewidth',2);
fill(DistanceB,NAVD88B,'y')
title({['North Parramore Island Transect Profile']})
ylabel('Elevation (m)')
xlabel('Distance (km)')
xlim([0 Distance(length)]) %Distance(length)
ylim([0 6.5])
box on
grid on
set(gca,'FontSize',12)
set(gca,'Xdir','reverse')
%Generic Axis Conversion
    % Convert y-axis values to percentage values by multiplication
    aa=[cellstr(num2str(get(gca,'xtick')'*0.001))]; 
    % Create a vector of '%' signs
    pct = char(ones(size(aa,1),1)*' '); %Blank if no character (%)
    % Append the '%' signs after the percentage values
    new_yticks = [char(aa),pct];
    % Reflect the changes on the plot
    set(gca,'xticklabel',new_yticks) 
