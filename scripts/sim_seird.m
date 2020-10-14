function xsim=sim_seird(tsim,p)
 xsim=zeros(2,length(tsim));
 if sum(p>0)==length(p)&&sum(p<10)==length(p) %all parameters must be positive
   global T;
   global TP;
    t0=tsim(1);
    tf=tsim(length(tsim));
    S0=TP;
    x0=zeros(T+8,1);
    x0(1)=S0;
    [t,x] = dtsim(@seird_scenes,x0,t0,tf,p);
   xsim(1,:)=x(6,:); %numero de casos totales
   xsim(2,:)=x(5,:); %numero de muertes totales
endif

end