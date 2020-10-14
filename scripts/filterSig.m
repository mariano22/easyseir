function filSignal=filterSig(Signal)
%  filSignal=filter(fir1(5,0.1),1,Signal);
#global freqsd;
n=3;
k=floor((n-1)/2);
tS=[1:length(Signal)]+k;
tS2=[1:length(Signal)+2*k];
Signal2=interp1(tS,Signal,tS2,"extrap");
filSignal=filter(ones(1,n)/n,1,Signal2);
filSignal=filSignal(2*k+1:2*k+length(Signal));

#filSignal=filter(freqsd(2:6)/sum(freqsd(2:6)),1,Signal);
%filSignal=Signal;
end