indices='idxr=(datos(:,7)>0);';
t0=60; %start time of dynamics
crop=0;
data_virus;
global TP;
TP=46e6;
tchange=[50,106]; %amba

%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
parametrize;