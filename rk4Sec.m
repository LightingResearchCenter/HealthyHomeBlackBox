function [xout,xcout] = rk4Sec(x0,xc0,Bdrive,hInterval,LRCparam)
% RK4SEC calculates the derivatives of the pacemaker model at each step

% Preallocate variables
n = 5;
xprime  = zeros(n,1);
xcprime = zeros(n,1);
x  = zeros(n,1);
xc = zeros(n,1);
x(1)  = x0;
xc(1) = xc0;

% Calculate derivatives
for i1 = 2:n
    [xprime(i1),xcprime(i1)] = xprimeSec(x(i1-1),xc(i1-1),Bdrive,LRCparam);
    x(i1) = hInterval/2*xprime(i1) + x0;
    xc(i1) = hInterval/2*xcprime(i1) + xc0;
end

xdym  = 2*(xprime(4)  + xprime(3));
xcdym = 2*(xcprime(4) + xcprime(3));

% Create output valriables
xout  = x0  + hInterval/6*(xprime(2)  + xprime(5)  + xdym);
xcout = xc0 + hInterval/6*(xcprime(2) + xcprime(5) + xcdym);

end