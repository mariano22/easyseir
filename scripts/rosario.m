indices='idxr=(datos(:,7)==82)&(datos(:,8)==84);';
t0=130; %start time of dynamics
crop=0;
data_virus;
maxdate=maxdate-crop;
read_PCR;
global TP;
TP=1.2e6;
%tchange=[120,135,150]; %optimo Rosario
tchange=[119,144];%optimo Rosario
tchange=[119,144];
%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
useRel=true;
parametrize;
ciudad='rosario';
