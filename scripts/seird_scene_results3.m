pkg load optim;

global scene
clear dr;
global dr
clear datechange
global datechange;
global datechange2;
global datechange3;
global rend;
global TP;
dr=0;
printing=false;
pformat=".jpg";

crop=0;
data_virus;
%scene=strcat("change",mat2str(dr));
%scenetitle=strcat(" Cambio de R0:",mat2str(dr),"%  (",datestr(date0+datechange),")");


 
tdata=[1:length(totDeaths)]-1;
date0=datenum([2020,02,20]); %day 0

T=25;%maximum delay
x0=zeros(T+8,1);
x0(1)=TP;

tf=230;
nx=23;%x points in axes
datechange=maxdate-10;
datechange=205;

tstart=t0;
tstart=150;
tend=tf;
cmax=2500;


scene="multiscene";
scenetitle=strcat(" Cambios de R0 el dia:",datestr(date0+datechange),")");


[t,x]=dtsim(@seird_scenes,x0,0,tf,p);
dr1=-10;
%dr1=-25;
dr=dr1;
scene=strcat("change",mat2str(dr));

[t,x1]=dtsim(@seird_scenes,x0,0,tf,p);

dr2=+10;
%dr2=-50;
dr=dr2;
scene=strcat("change",mat2str(dr));
[t,x2]=dtsim(@seird_scenes,x0,0,tf,p);

x(6,:)=filterSig(x(6,:));
x1(6,:)=filterSig(x1(6,:));
x2(6,:)=filterSig(x2(6,:));

scene=strcat(scene,ciudad);

figure()
plot(tdata,totDeaths,'-+',t,x(5,:),"linewidth",3,t,x1(5,:),"linewidth",2,t,x2(5,:),"linewidth",2)
grid on
title(strcat("Total de Muertes Reportadas. Escenario: ",scenetitle))
le=legend("datos","modelo",strcat("modelo R0",mat2str(dr1),"%"),strcat("modelo R0+",mat2str(dr2),"%"));
set (le, "fontsize", 12);
set(le,"location","northwest");
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
axis([tstart length(t) 0 1500])
axis("auto[y]")
filen=strcat('./octave_figs/totDeaths_',scene,pformat);
if printing
  if pformat=='.pdf'|pformat=='.eps'
    print(filen,'-color','-bestfit','-landscape');
  else
    print(filen);
  end  
end


figure()
plot(tdata,dailyDeaths,'-+',t,diff([0 x(5,:)]),"linewidth",3,t,diff([0 x1(5,:)]),t,diff([0 x2(5,:)]))
grid on
title(strcat("Muertes Reportadas por Dia. Escenario: ",scenetitle))
le=legend("datos","modelo",strcat("modelo R0",mat2str(dr1),"%"),strcat("modelo R0+",mat2str(dr2),"%"));
set (le, "fontsize", 12);
set(le,"location","northwest");
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
axis([tstart length(t) 0 50])
axis("auto[y]")
filen=strcat('./octave_figs/dailyDeaths_',scene,pformat);
if printing
  if pformat=='.pdf'|pformat=='.eps'
    print(filen,'-color','-bestfit','-landscape');
  else
    print(filen);
  end  
end

figure()
plot(tdata,totCases,'-+',t,x(6,:),"linewidth",3,t,x1(6,:),"linewidth",2,t,x2(6,:),"linewidth",2)
le=legend("datos","modelo",strcat("modelo R0",mat2str(dr1),"%"),strcat("modelo R0+",mat2str(dr2),"%"));
set (le, "fontsize", 12);
set(le,"location","northwest");
title(strcat("Total de Casos Reportados. Escenario: ",scenetitle))
grid on
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%axis("tight")
axis([tstart length(t) 0 10000])
axis("auto[y]")
filen=strcat('./octave_figs/totCases_',scene,pformat);
if printing
  if pformat=='.pdf'|pformat=='.eps'
    print(filen,'-color','-bestfit','-landscape');
  else
    print(filen);
  end  
end


figure()
dailyDetSim=diff([0, x(6,:)]);
dailyDetSim1=diff([0, x1(6,:)]);
dailyDetSim2=diff([0, x2(6,:)]);

plot(tdata,dailyCases,'-+',t,dailyDetSim,"linewidth",3,t,dailyDetSim1,"linewidth",2,t,dailyDetSim2,"linewidth",2)
le=legend("datos","modelo",strcat("modelo R0",mat2str(dr1),"%"),strcat("modelo R0+",mat2str(dr2),"%"));
set (le, "fontsize", 12);
set(le,"location","northwest");
title(strcat("Casos diarios detectados. Escenario: ",scenetitle))
grid on
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%axis("tight")
axis([tstart length(t) 0 cmax])
axis("auto[y]")
filen=strcat('./octave_figs/dailyCases_',scene,pformat);
if printing
  if pformat=='.pdf'|pformat=='.eps'
    print(filen,'-color','-bestfit','-landscape');
  else
    print(filen);
  end  
end

figure()
daysUCI=14;
percUCI=0.018;
uciEst=[zeros(1,daysUCI+1),x(6,daysUCI+1:tend)-x(6,1:tend-daysUCI)]*percUCI;
uciEst1=[zeros(1,daysUCI+1),x1(6,daysUCI+1:tend)-x1(6,1:tend-daysUCI)]*percUCI;
uciEst2=[zeros(1,daysUCI+1),x2(6,daysUCI+1:tend)-x2(6,1:tend-daysUCI)]*percUCI;
plot(t+2,uciEst,"linewidth",3,t+2,uciEst1,"linewidth",2,t+2,uciEst2,"linewidth",2)
le=legend("modelo",strcat("modelo R0",mat2str(dr1),"%"),strcat("modelo R0+",mat2str(dr2),"%"),"location","northwest");
set (le, "fontsize", 12);
title("Camas UTI Ocupadas. Escenario: 1.8% de los casos durante 14 dias.")
grid on
stepd=floor((length(t)-1)/nx);
maxtd=stepd*nx;
set(gca(),'xtick',0:stepd:maxtd);
datalabels=datestr(date0:stepd:date0+maxtd,19);
set(gca(),'xticklabel',datalabels);
%axis("tight")
axis([tstart length(t) 0 cmax])
axis("auto[y]")
filen=strcat('./octave_figs/uciEst_',scene,pformat);
if printing
  if pformat=='.pdf'|pformat=='.eps'
    print(filen,'-color','-bestfit','-landscape');
  else
    print(filen);
  end  
end
