function [xprime, xcprime] = xprimeSec(x,xc,Bdrive,LRCparam)
% Model
xprime  = pi/43200*(LRCparam.mu*(x/3 + 4/3*x^3 - 256/105*x^7) + xc + Bdrive);
xcprime = pi/43200*(LRCparam.q*Bdrive*xc - (24/(0.99729*LRCparam.tau))^2*x + LRCparam.k*Bdrive*x);

end
