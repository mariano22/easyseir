function [t,x] = dtsim(f,x0,ti,tf,pars)
  t=[ti:tf];
  x(:,1)=x0;
  for k=1:length(t)-1
    if nargin==4
      x(:,k+1)=f(x(:,k),t(k));
    else
      x(:,k+1)=f(x(:,k),t(k),pars);
    end
  end
end