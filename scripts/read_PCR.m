%load data
%columnas: 1-Fecha, 2-Provincia, 3 - Depto, 4- Localidad 5-Nro de Tests 6-Nro.Positivos
datos=csvread("../datos/nacionales/datosPCR.csv");
datos(:,1)=floor(datos(:,1)/(3600*24))-18312;
datos(:,7)=datos(:,2);
datos(:,8)=datos(:,3);
eval(indices);
datosPCR=datos(idxr,:);
date0=datenum("2020/02/20");
maxdatePCR=max(max(datosPCR(:,1)));
maxdatePCR=max(maxdatePCR,maxdate);
testsPCR=zeros(1,maxdatePCR);
positivePCR=zeros(1,maxdatePCR);
for i=1:length(datosPCR)
  if datosPCR(i,1)>0
   testsPCR(datosPCR(i,1))=testsPCR(datosPCR(i,1))+datosPCR(i,5);
   positivePCR(datosPCR(i,1))=positivePCR(datosPCR(i,1))+datosPCR(i,6);
  endif 
endfor
testsPCR=testsPCR(1:maxdate);
positivePCR=positivePCR(1:maxdate);
