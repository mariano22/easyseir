pkg load optim;
global intPars;
clear scene;
%discrete parameters
%intPars = [TI, TD, TC, TM, TR, t1, t2,t3,t4]

global xdata;
global tdata;
xdata=[totCases;totDeaths];%input data
tdata=[0:length(totCases)-1];

global T; %maximum delay
T=25; 
global g;
g=0.1;
nchanges=length(tchange);
%initial guess for parameters
p0=[ones(1,nchanges+1),0.02*ones(1,nchanges+1)];
p0(1)=0;
%discrete parameters
intPars=[delays,tchange];

%weight functions
WT=ones(size(xdata));
for i=1:size(xdata,1)
  WT(i,:)=WT(i,:)./sqrt(abs(xdata(i,:))+1);
end
if useRel
  [xb,p]=leasqr(tdata,xdata,p0,@sim_seird,[],[],WT);
else
  [xb,p]=leasqr(tdata,xdata,p0,@sim_seird);
end
%e=zeros(1,2);
display errors
display(norm(xb-xdata)/norm(xdata))
