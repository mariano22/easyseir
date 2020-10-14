indices='idxr=(datos(:,7)==82)&(datos(:,8)==42);';
t0=160; %start time of dynamics
crop=0;
data_virus;
maxdate=maxdate-crop;
read_PCR;
global TP;
TP=190e3;
tchange=[149];
%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
useRel=false;
cfr=0.01;
parametrize_Cases;
ciudad='gral_lopez';
