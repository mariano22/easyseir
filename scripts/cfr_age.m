idx=datosr(:,1)>maxdate-delay-twindow&datosr(:,1)<maxdate-delay&datosr(:,9)>minage&datosr(:,9)<maxage;
datosold=datosr(idx,:);
idx=datosold(:,6)>0;
datosoldd=datosold(idx,:);
cfr=size(datosoldd,1)/size(datosold,1)