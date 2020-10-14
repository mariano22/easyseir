indices='idxr=(datos(:,7)==82)&(datos(:,8)==14);';
t0=150; %start time of dynamics
crop=0;
data_virus;
maxdate=maxdate-crop;
%read_PCR;
global TP;
TP=82e3;
%tchange=[120,135,150]; %optimo Rosario
tchange=[138,160];
%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
useRel=false;
parametrize;
ciudad='caseros';
