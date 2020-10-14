gbacods=[28,35,91,260,270,274,371,408,410,412,427,434,490,515,539,560,568,658,749,756,760,805,840,861];

indices='idxr=(datos(:,7)==6&any(datos(:,8)==gbacods,2))|(datos(:,7)==2);';
t0=60; %start time of dynamics
crop=15;
data_virus;
global TP;
TP=15e6;
tchange=[50:28:106]; %amba

%delays: [TI, TD, TC, TM, TR]
delays=[3,11,12,18,18];
parametrize;