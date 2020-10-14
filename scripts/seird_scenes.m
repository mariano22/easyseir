function xnew=seird_scenes(x,t,p)
 global T; %maximum delay
 global freqed; %exposure to diag
 global freqede;
 global TP;
 global g;
  S=x(1);
  E=x(2);
  I=x(3);
  R=x(4);
  D=x(5);
  Rep=x(6); %reported cases
  DImp=x(7); %detected imported cases
  N=7;
  NE=x(N+1:N+T); %new exposed at different times
  
  %parameters
  cfr=0.045; %case fatality rate
  
  if nargin>2
     r0i=p(1:length(p)/2);
    cfri=p(length(p)/2+1:length(p));
    cfr=cfri(1);
  end

  global intPars;
  TI=intPars(1); %infection time
  TD=intPars(2); %diagnosis/report time
  TC=intPars(3);
  TM=intPars(4); %death time
  TR=intPars(5); %recovery time
  tchange=intPars(6:length(intPars));
 
      r0=r0i(1);
      cfr=cfri(1);
      for i=1:length(tchange)
        if t+1>=tchange(i)
          r0=r0i(i+1);
        endif
        if t+1>=tchange(i)+TM
          cfr=cfri(i+1);
        endif
      endfor
   
  global scene
  global dr
  global datechange;
  global datechange2;
  global datechange3;
  global ropen;
  global topen;
  global rclosed;
  global tclosed;
  global r1;
  global r2;
  global r3;
  
  if isempty(scene)
    scene="";
  end  
  if !isempty(strfind(scene,"change"))
    if t>=datechange
      r0=r0*(1+dr/100);
    end
  end

  if !isempty(strfind(scene,"control"))
    if t>=datechange&&t<datechange2
      r0=rclosed; %first shutdown
    elseif t>=datechange2  
      if rem(t-datechange2,topen+tclosed)<topen
        r0=ropen;
      else
        r0=rclosed;
      end
      if !isempty(strfind(scene,"we"))&&(rem(t,7)==3||rem(t,7)==2)
        r0=rclosed;
      endif
    end
 
  end
  if !isempty(strfind(scene,"multidate"))
    if t>=datechange
      r0=r1;
    endif
    if t>=datechange2
      r0=r2;
    endif
    if t>=datechange3
      r0=r3;
    endif
  endif
  
  %dependent parameters
  r0d=r0/(TC-TI); %daily propagation rate
  
   %input signal 
   global dailyImpCases;

  if t+2+TD<1
    U=0;
  elseif t+2+TD<=length(dailyImpCases)  
    U=dailyImpCases(t+2+TD);
  else
    U=mean(dailyImpCases(length(dailyImpCases)-7:length(dailyImpCases)));
  end

  if t+2<1
    impdet=0;
  elseif t+2<=length(dailyImpCases)  
    impdet=dailyImpCases(t+2);
  else
    impdet=mean(dailyImpCases(length(dailyImpCases)-7:length(dailyImpCases)));
  end

  %equations
  NE = shift(NE,1);
  NE(1) = r0d*I*S/TP+U/g;
  S = S - r0d*I*S/TP;
  E = E + NE(1) - NE(TI+1);
  I = I + NE(TI+1) - NE(TC+1);
  R = R + (1-cfr*g)*NE(TR+1);
  D = D + cfr*g * NE(TM+1);
  Rep = Rep + g* NE(TD+1);
  DImp = DImp + impdet; 
  
  xnew=x;
  xnew(1)=S;
  xnew(2)=E;
  xnew(3)=I;
  xnew(4)=R;
  xnew(5)=D;
  xnew(6)=Rep;
  xnew(7)=DImp;
  xnew(N+1:N+T)=NE;

end