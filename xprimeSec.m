function [xprime, xcprime] = xprimeSec(x,xc,Bdrive)
%% Model Constants
mu = 0.13;
q = 2/3;
k = 0.15;
tau = 24.2; % hours

%% Model
xprime = pi/43200*(mu*(x/3+4/3*x^3-256/105*x^7)+xc+Bdrive);
xcprime = pi/43200*(q*Bdrive*xc-(24/(0.99729*tau))^2*x+k*Bdrive*x);

end
