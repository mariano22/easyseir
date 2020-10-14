indices='idxr=(datos(:,7)==2);';
t0=60; %start time of dynamics
crop=0;
data_virus;
read_PCR;
global TP;
TP=2.8e6;
tchange=[50,86]; %caba

%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,19,19];
useRel=true;
parametrize;
ciudad = 'caba'; 
