function [tf,xf,xcf] = rk4stepperSec(x0,xc0,lightDrive,ti,tf,nsteps)
% RK4STEPPERSEC is an ODE solver used to determine state variable values
% of the pacemaker model at the desired point in time

%% Create local variables
Bdrive = 0.56 * lightDrive;
deltat = (tf - ti)/nsteps;

%% Initialize loop variables
t = ti;

%% Loop
for iStep = 1:nsteps
    % Calculate values per step
    [x0, xc0] = rk4Sec(x0,xc0,Bdrive,deltat);
    
    % Update loop variable
    t = t + deltat;
end

%% Create return values
tf = t;
xf = x0;
xcf = xc0;

end