%load data
%columnas: 1-Fecha Diagnostico, 2-Fecha de apertura, 3- Fecha sintomas 4-Fecha internacion
%5- Fecha UCI, 6- Fecha Fallecimiento, 7-Provincia, 8- Depto,  9-Edad
datos=csvread("../datos/nacionales/datos.csv");
datos(:,1:6)=floor(datos(:,1:6)/(3600*24))-18312;
date0=datenum("2020/02/20");
maxdate=max(max(datos(:,1:6)))-1;
%ic=2; %usar fecha apertura
ic=1; %usar fecha de diagnostico
casos=zeros(maxdate,6);
t=[1:maxdate];
for i=1:maxdate
  for j=1:6
    casos(i,j)=sum(datos(:,j) == i);
  endfor
endfor
idx=( datos(:,ic)>0 );
datosfilt=datos(idx,: );
idx=( datosfilt(:,3)>0 );
datosfiltsint=datosfilt(idx,: );
idx=( datosfilt(:,5)>0 );
datosfiltuci=datosfilt(idx,: );
idx=( datosfilt(:,6)>0 );
datosfiltdeath=datosfilt(idx,: );
tsymptdiag=mean(datosfiltsint(:,1)-datosfiltsint(:,3))
tdiaguci=mean(datosfiltuci(:,5)-datosfiltuci(:,ic))
tdiagdeath=mean(datosfiltdeath(:,6)-datosfiltdeath(:,ic))
tcasos=[1:size(casos,1)];

eval(indices);
datosr=datos(idxr,:);
casosr=zeros(maxdate,6);
for i=1:maxdate
  for j=1:6
    casosr(i,j)=sum(datosr(:,j) == i);
  endfor
endfor

idx=( datosr(:,ic)>0 );
datosfilt=datosr(idx,: );
idx=( datosfilt(:,3)>0 );
datosfiltsint=datosfilt(idx,: );
idx=( datosfilt(:,5)>0 );
datosfiltuci=datosfilt(idx,: );
idx=( datosfilt(:,6)>0 );
datosfiltdeath=datosfilt(idx,: );
tsymptdiagr=mean(datosfiltsint(:,1)-datosfiltsint(:,3))
tdiagucir=mean(datosfiltuci(:,5)-datosfiltuci(:,ic))
tdiagdeathr=mean(datosfiltdeath(:,6)-datosfiltdeath(:,ic))
tcasos=[1:size(casos,1)];

##display("Ultima semana")
##idx=( datosr(:,ic)>maxdate-42&datosr(:,ic)<maxdate-30 );
##datosfilt=datosr(idx,: );
##idx=( datosfilt(:,3)>0 );
##datosfiltsint=datosfilt(idx,: );
##idx=( datosfilt(:,5)>0 );
##datosfiltuci=datosfilt(idx,: );
##idx=( datosfilt(:,6)>0 );
##datosfiltdeath=datosfilt(idx,: );
##tsymptdiagr=mean(datosfiltsint(:,1)-datosfiltsint(:,3))
##tdiagucir=mean(datosfiltuci(:,5)-datosfiltuci(:,ic))
##tdiagdeathr=mean(datosfiltdeath(:,6)-datosfiltdeath(:,ic))
