tPCR=[1:maxdate];
fPosit=positivePCR./max(testsPCR,1);
figure()
plot(tPCR,fPosit,"-+")
legend("datos")
title("Fracción de tests PCR positivos")
grid on
stepd=floor((maxdate-1)/nx);
set(gca(),'xtick',0:stepd:maxdate);
datalabels=datestr(date0:stepd:date0+maxdate,19);
set(gca(),'xticklabel',datalabels);
%set(gca(),'fontsize',8);
%axis("tight")
axis([tstart maxdate 0 1])
filen=strcat("./octave_figs/fposit.jpg");
if printing 
   print (filen);
end
