indices='idxr=(datos(:,7)==82)&(datos(:,8)==63);';
t0=172; %start time of dynamics
crop=0;
data_virus;
maxdate=maxdate-crop;
read_PCR;
global TP;
TP=490e3;
tchange=[160,164];
%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,17,17];
useRel=false;
cfr=0.018;
parametrize_Cases;
ciudad='lacapital';
