indices='idxr=(datos(:,7)==82)&(datos(:,8)==126);';
t0=189; %start time of dynamics
crop=0;
data_virus;
maxdate=maxdate-crop;
%read_PCR;
global TP;
TP=64e3;
tchange=[178];
%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
useRel=false;
cfr=0.02;
parametrize_Cases;
ciudad='gral_lopez';
