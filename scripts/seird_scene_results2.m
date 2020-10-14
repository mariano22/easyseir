pkg load optim;
%parametrize_seird2;

global scene

global ropen;
global topen;
global rclosed;
global tclosed;

global datechange;
global datechange2;
global datechange3;
global r1;
global r2;
global r3;
global TP;

datechange=400;
r1=1.3;
datechange2=400;
r2=1.3;
datechange3=datechange2+400;
r3=1;
printing=true;
tstart=t0;
tend=300;
%tend=480;
nx=15;%x points in axes
cmax=240;

 
data_virus;

tdata=[0:length(totDeaths)-1];
date0=datenum([2020,02,20]); %day 0

##scene=strcat("control",mat2str(rclosed),mat2str(tclosed),mat2str(ropen),mat2str(topen));
##scenetitle=strcat(" Alterna: R=",mat2str(rclosed),"(",mat2str(tclosed)," dias) - ",mat2str(ropen),"(",mat2str(topen)," dias)");
##scene="control R=07";
##scenetitle=" Control R=0.7";
scene="multidate";
##scenetitle=strcat(" Distanciamiento estricto en el periodo: ",datestr(date0+datechange,19)," - ",datestr(date0+datechange2,19));
scene="sin cambios";
scenetitle=" Sin Cambios";
scene="multidate";
T=25;
x0=zeros(T+8,1);
x0(1)=TP;
%[t,x]=dtsim(@seird,x0,0,70,p);

[t,x]=dtsim(@seird_scenes,x0,0,tend,p);
%x(6,:)=filterSig(x(6,:));

figure()
plot(t,x(5,:),tdata,totDeaths,'-+')
grid on
title(strcat("Total de Muertes Reportadas. Escenario: ",scenetitle))
legend("modelo","datos")
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
xtick=[date0:stepd:date0+maxtd];
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
##set(gca(),'fontsize',8);
#axis("tight")
axis([tstart length(t) 0 50])
axis("auto[y]")
filen=strcat('./octave_figs/totDeaths_',scene,".pdf");
if printing 
   print (filen);
end

figure()
plot(t,diff([0 x(5,:)]),tdata,dailyDeaths,'-+')
grid on
title(strcat("Muertes Reportadas por Dia. Escenario: ",scenetitle))
legend("modelo","datos")
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%#set(gca(),'fontsize',8);
%axis("tight")
axis([tstart length(t) 0 100])
axis("auto[y]")
filen=strcat('./octave_figs/dailyDeaths_',scene,".pdf");
if printing 
   print (filen);
end

figure()
plot(t,x(6,:),tdata,totCases,'-+')
legend("Total (modelo)","Total (datos)")
title(strcat("Total de Casos Reportados. Escenario: ",scenetitle))
grid on
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%set(gca(),'fontsize',8);
%axis("tight")
axis([tstart length(t) 0 2000])
axis("auto[y]")
filen=strcat('./octave_figs/totCases_',scene,".pdf");
if printing 
   print (filen);
end

##actCases=x(6,1:length(t))-[zeros(1,15),x(6,1:length(t)-15)];
##figure()
##plot(t,actCases*0.13)
##title(strcat("Internaciones. Escenario: ",scenetitle))
##grid on
##stepd=floor((length(t)-1)/nx);
##maxtd=stepd*nx;
##set(gca(),'xtick',0:stepd:maxtd);
##datalabels=datestr(date0:stepd:date0+maxtd,19);
##set(gca(),'xticklabel',datalabels);
##%set(gca(),'fontsize',8);
##axis("tight")
##%axis([tstart length(t) 0 1000])
##filen=strcat('./octave_figs/actCases_',scene,".pdf");
##if printing 
##   print (filen);
##end

figure()
dailyDetSim=diff([0, x(6,:)]);
plot(t,dailyDetSim,tdata,dailyCases,'-+')
legend("modelo","datos")
title(strcat("Casos diarios detectados. Escenario: ",scenetitle))
grid on
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%set(gca(),'fontsize',8);
%axis("tight")
axis([tstart length(t) 0 cmax])
axis("auto[y]")
filen=strcat('./octave_figs/dailyCases_',scene,".pdf");
if printing 
   print (filen);
end

figure()
daysUCI=14;
percUCI=0.018;
uciEst=[zeros(1,daysUCI+1),x(6,daysUCI+1:tend)-x(6,1:tend-daysUCI)]*percUCI;
plot(t+2,uciEst,'-+')
legend("modelo")
title("Camas UCI Ocupadas. Escenario: 1.8% de los casos durante 14 dias.")
grid on
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%axis("tight")
axis([tstart length(t) 0 cmax])
axis("auto[y]")
filen=strcat('./octave_figs/uciEst_',scene,".pdf");
if printing
  print (filen);
end
