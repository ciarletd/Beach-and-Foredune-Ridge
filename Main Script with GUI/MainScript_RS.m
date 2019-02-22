%%%%%Ridge and Swale Main Script%%%%

%This script is designed to run with an interface 'GUI_RS.m'

clear all
load('variables.mat')
figure(1); clf;

%Inputs
D=5; %m Depth of Shoreface
L=10; %m Initial Length of Beach
Lc=cinterface(3); %m Width required to nucleate a new dune 
Ls=10; %m Foredune setback distance
Qd=cinterface(2); %m3/m/yr Foredune Flux
Qd=round(Qd,2);
G1=0.065; %m/m Slope of dune flank 1
G2=0.065; %m/m Slope of dune flank 2
a=cinterface(4)*0.001; %rate of sea level rise in m/yr
H=0; %set starting height of dune
Qs=cinterface(1); %m3/m/yr Shoreface Flux
Qs=round(Qs,2);

%Starting Conditions and Trackers
Hback=H;
LDuneFlank10=H/G1;
LDuneFlank20=H/G2;
Shoreline=-LDuneFlank10-L;
DV=((LDuneFlank10+LDuneFlank20)*H)/2;
DV0i=DV;
DuneCounter=0; %Keep track of number of dunes produced
TotalDV=0;
speccond=0;

%Computational Parameters
dt=0.01; %time step
Tmax=cinterface(5); %maximum run time
t=0:dt:Tmax; %time vector
n=length(t);
xt=linspace(1,Tmax,n)'; %Scale time axis by dt for plots
PlotInterval=5/dt;

QQs=NaN(1,n); %Store Q to dune
DVst=NaN(1,n); %Store Dune Volume
Hst=NaN(1,n); %Store Dune Height
Lst=NaN(1,n); %Store Beach Length
Qsst=NaN(1,n); %Store Qs vector
ShorelineChange=NaN(1,n);
DuneVolumeLoss=NaN(1,n); %Store volume lost from dune to sea level rise

%Profile Vector
DuneProfX=zeros(1,200);
DuneProfY=zeros(1,200);
FanProfX=zeros(1,200);
FanProfY=zeros(1,200);

%Starting Geometry
InlandFlankToe=H/G2;
InlandFlankCrest=0;
SeawardFlankCrest=0;
SeawardFlankToe=-H/G1;
BaseLevel=0;

tfd=0; %Foredune transgression switch
j=1;
for i=1:n
P1=1+(DuneCounter*5); %Counter to track position of inland dune flank
P2=2+(DuneCounter*5); %Counter to track position of inland dune crest
P3=3+(DuneCounter*5); %Counter to track position of shoreward dune crest
P4=4+(DuneCounter*5); %Counter to track position of shoreward dune flank
P5=5+(DuneCounter*5); %Counter to track position of swale shoreward edge

%Qs=Qsv(i); %Turn this on if using vectorized Qs 

%if [insert condition]; speccond=1; end %Switch to activate a special condition aka alternate ridge growth mode

if speccond==0;
Laccom=L*a*dt; %Calculate accomodation volume of beach
D=D+a*dt; %Calculate new depth, accounting for sea level rise
DVlossAggro=((LDuneFlank10+LDuneFlank20)*a*dt); %How much dune volume is lost to sea level rise?
DuneVolumeLoss(i)=DVlossAggro; %Store volume lost from dune to sea level rise
Qsst(i)=Qs*dt; %Store Qs for volume check
DV=-DVlossAggro+DV+Qd*dt; %Dune volume equals previous dune volume plus sediment input from beach and loss to sea level
H=((2*DV)/((1/G1)+(1/G2)))^0.5; %Find the height of the new dune
LDuneFlank1=H/G1; %Find the flank width of the dune on the beach side of the crest
LDuneFlank2=H/G2; %Find the flank width of the dune on the inland side of the crest
LDuneFlankdot1=LDuneFlank1-LDuneFlank10;
LDuneFlankdot2=LDuneFlank2-LDuneFlank20;
L=L+(Qs/D*dt)-(Qd/D*dt)-LDuneFlankdot1; %What is the new length of the beach?
ShorelineChange(i)=-(Qs/D*dt)+(Qd/D*dt); %Store shoreline change values per dt
L=L-(Laccom/D); %What is the new length of the beach accounting for accomodation?
Shoreline=Shoreline+ShorelineChange(i)+(Laccom/D); %Where is the new shoreline?
LDuneFlank10=LDuneFlank1; %Set starting dune flank lengths for next iteration
LDuneFlank20=LDuneFlank2; %Set starting dune flank lengths for next iteration
Hback=H;
SeawardFlankCrest=InlandFlankCrest;
InlandFlankToe=InlandFlankToe+LDuneFlankdot2;
SeawardFlankToe=SeawardFlankToe-LDuneFlankdot1;
end

if speccond==1
%alternate form of dune growth can be activated here
end

if SeawardFlankToe<Shoreline; tfd=1; break; end %Foredune transgression


%%Vectors
DuneProfX(P1)=InlandFlankToe;
DuneProfX(P2)=InlandFlankCrest;
DuneProfX(P3)=SeawardFlankCrest;
DuneProfX(P4)=SeawardFlankToe;
DuneProfX(P5)=Shoreline;
DuneProfY(P1)=BaseLevel;
DuneProfY(P2)=a*dt*i+Hback;
DuneProfY(P3)=a*dt*i+H;
DuneProfY(P4)=a*dt*i;
DuneProfY(P5)=a*dt*i;

Lst(i)=L; %Store L 
Hst(i)=H; %Store H 

if L+H/G1>=Lc+Ls %Initiate dune nucleation
    HstR(j)=(SeawardFlankCrest-SeawardFlankToe); %Store H for Ridge
    HstRHG(j)=H/G1; %Store H for Ridge
    j=j+1;
    speccond=0; %Terminate alternate growth mode if activated
    DuneCounter=DuneCounter+1; %New dune counted
    H=a*dt; %Reset for new dune
    TotalDV=TotalDV+DV;
    DV=0; %Reset for new dune
    LDuneFlank20=0;
    LDuneFlank10=0; %Reset for new dune
    InlandFlankToe=Shoreline+Ls;
    DuneProfX(P5)=InlandFlankToe;
    InlandFlankCrest=Shoreline+Ls;
    SeawardFlankCrest=Shoreline+Ls;
    SeawardFlankToe=Shoreline+Ls;
    L=Ls; %Reset beach length
    BaseLevel=a*i*dt;
end

if (mod(i,PlotInterval)-1==0)||i==n; %plot at set interval and plot final frame
figure(1)
hold on
ylim([-2 10]);
xlim([-50 2000]);
SeaX=-[-2000,-2000,50,50];
SeaY=[-5,a*dt*i,a*dt*i,-5];
MarshX=-[Shoreline,Shoreline,100,100];
MarshY=[-5,a*dt*i,a*dt*i,-5];
plot(SeaX,SeaY,'b','linewidth',1)
fill(SeaX,SeaY,'b')
plot(MarshX,MarshY,'g','linewidth',1)
fill(MarshX,MarshY,'g')
DuneProfX(P5+1)=DuneProfX(P5);
DuneProfY(P5+1)=-5;
DuneProfX(P5+2)=100; %activate for falling sea level
DuneProfY(P5+2)=-5;
DuneProfX(P5+3)=100; %activate for falling sea level
DuneProfY(P5+3)=0;
plot(-DuneProfX,DuneProfY,'k','linewidth',1)
fill(-DuneProfX,DuneProfY,'y')
grid on
xlabel('Distance (km)');
ylabel('Elevation (m)');
aa=a*1000;
title({['Beach Profile at Time=' num2str(i*dt-dt) ' yrs'],['Q_S=' num2str(Qs) ' m^3/m/yr, Q_D=' num2str(Qd) ' m^3/m/yr']});
box on
grid on
set(gca,'FontSize',16)
set(gca,'Xdir','reverse')
%Axis Conversion
    aa=[cellstr(num2str(get(gca,'xtick')'*0.001))]; 
    new_yticks = [char(aa)];
    % Reflect the changes on the plot
    set(gca,'xticklabel',new_yticks)

%GIF
    set(gcf,'color','w'); % set figure background to white
    set(gcf, 'Position', [100, 100, 1200, 400])
    drawnow;
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    outfile = 'Animation.gif';
 
    % On the first loop, create the file. In subsequent loops, append.
    if i==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'writemode','append');
    end
    if i<n; figure(1); clf; 
    end
        
end


end
if tfd==1;  
        message = sprintf('The foredune has transgressed!'); 
        msgbox(message);
end


