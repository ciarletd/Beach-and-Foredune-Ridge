clear all; close all; clc
a=csvread('FP_Profile.csv');
Distance=a(:,1);
NAVD88=a(:,2);
Breaks=[91,511,787,836,909,933,971,1061,1095,1118,1213,1238,1272,1386,1469,1627,1670,1727,1798,1873,1920,2119,2271];
Years=[1934,1958,1970,1977,1980,1981,1988,1989,1990,1991,1992,1996,1997,1998,1999,2001,2003,2004,2007,2008,2009,2011,2013];
Depth=4.4;

figure(1)
hold on
plot(Distance,NAVD88,'linewidth',2)

n=length(Years);
refdist=0;
refindex=1;
refyr=1919;

BinProgradation=NaN(1,n);
BinInterval=NaN(1,n);
BinVolume=NaN(1,n);
BinFlux=NaN(1,n);
for i=1:n
yr=Years(i);
plot([Breaks(i),Breaks(i)],[0,3.5]); h=text(Breaks(i),3.5,['' num2str(yr) '']);  set(h,'Rotation',90);
[m,index] = min(abs(Distance-Breaks(i)));
L=Distance(index)-refdist;
BinProgradation(i)=L;
bin=sum(NAVD88(refindex:index))+Depth*L;
BinVolume(i)=bin;
refindex=index;
refdist=Distance(index);
yrs=yr-refyr;
BinInterval(i)=yrs;
refyr=yr;
flux=bin/yrs;
BinFlux(i)=flux;
bin=round(bin);
flux=round(flux);
    if mod(i,2) == 0 %number is even
    gg=2;
    else %number is odd 
    gg=0.5;
    end
plot([Breaks(i),Breaks(i)],[0,3.5]); h=text(Breaks(i),gg,['' num2str(bin) ' m^3/m -- ' num2str(flux) ' m^3/m/yr']);  set(h,'Rotation',90);
set(h,'BackgroundColor','w');
end
h=text(110,3.3,'Shoreline Advances to Right \rightarrow');
title({'Bulk Sediment Additions Through Time: Shoreface Depth Relative to MHHW (+0.6 NAVD88)=5 m',' ',' ',' '})
xlabel('Distance (m)')
ylabel('Elevation (m) NAVD88')
xlim([0 2300])

FluxVector=0;
nn=length(BinInterval);
for j=1:nn
yrs=BinInterval(j);
for jj=1:yrs
    yy=BinFlux(j);
    FluxVector=[FluxVector yy];
end
end
nfluxvector=length(FluxVector)-1;
AverageFlux=(sum(FluxVector(2:end))/nfluxvector);
AverageFlux=round(AverageFlux);

figure (2)
plot(FluxVector,'linewidth',2);
title({['Calculated Shoreface Fluxes to System, Based on Historic Mapping'],['Average Flux =' num2str(AverageFlux) ' m^3/m/yr']})
xlabel('Time (yrs)')
ylabel('Flux (m^3/m/yr)')
xlim([1 95])

Dates=linspace(1919,2013,95);
figure (3)
plot(Dates,FluxVector,'k','linewidth',2);
title({['Fishing Point Shoreface Flux Q_S'],['Average Flux =' num2str(AverageFlux) ' m^3/m/yr']})
xlabel('Date')
ylabel('Q_S (m^3/m/yr)')
xlim([1919 2013])

