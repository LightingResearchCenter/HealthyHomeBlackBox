function [xout,xcout] = rk4Sec(x0,xc0,Bdrive,hInterval,LRCparam)
% RK4SEC calculates the derivatives of the pacemaker model at each step

% Calculate derivatives
[xprime1,xcprime1] = xprimeSec(x0,xc0);
x1 = hInterval/2*xprime1+x0;
xc1 = hInterval/2*xcprime1+xc0;

[xprime2,xcprime2] = xprimeSec(x1,xc1);
x2 = hInterval/2*xprime2+x0;
xc2 = hInterval/2*xcprime2+xc0;

[xprime3,xcprime3] = xprimeSec(x2,xc2);
x3 = hInterval*xprime3+x0;
xc3 = hInterval*xcprime3+xc0;
xdym = 2*(xprime3+xprime2);
xcdym = 2*(xcprime3+xcprime2);

[xprime4,xcprime4] = xprimeSec(x3,xc3);


% Create output valriables
xout = x0+hInterval/6*(xprime1+xprime4+xdym);
xcout = xc0+hInterval/6*(xcprime1+xcprime4+xcdym);

function [xprime, xcprime] = xprimeSec(x,xc)
    % Model
    xprime  = pi/43200*(LRCparam.mu*(x/3 + 4/3*x^3 - 256/105*x^7) + xc + Bdrive);
    xcprime = pi/43200*(LRCparam.q*Bdrive*xc - (24/(0.99729*LRCparam.tau))^2*x + LRCparam.k*Bdrive*x);
end


end