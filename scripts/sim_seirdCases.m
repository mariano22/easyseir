function xsim=sim_seirdCases(tsim,p)
 xsim=zeros(1,length(tsim));
 if sum(p>0)==length(p)&&sum(p<10)==length(p) %all parameters must be positive
   global T;
   global TP;
    t0=tsim(1);
    tf=tsim(length(tsim));
    S0=TP;
    x0=zeros(T+8,1);
    x0(1)=S0;
    [t,x] = dtsim(@seird_scenes,x0,t0,tf,p);
   xsim(1,:)=x(6,:);
endif

end