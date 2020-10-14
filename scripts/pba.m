indices='idxr=(datos(:,7)==6);';
t0=60; %start time of dynamics
crop=20;
data_virus;
global TP;
TP=16.6e6;
tchange=[50:28:106]; %amba

%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
useRel=true;
parametrize;