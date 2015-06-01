function [tf,xf,xcf] = pacemakerModelRun(t0,x0,xc0,increment,lightArray)
%   PACEMAKERMODELRUN runs the LRC's version of the circadian pacemaker 
%   model (based on Kronauer's 1999 paper) using the given light data.
%
%   Input:
%       t0: The initial relative time of the data in seconds (0.0<=t0<86400)
%       x0: Pacemaker state variable #1 (x-axis) initial value
%       xc0: Pacemaker state variable #2 (y-axis) initial value
%       increment: The time between sequencial lightArray data points in
%       seconds
%       lightArray: an array of CS values
%
%   Ouput:
%       tf: The final relative time of the data in seconds (0.0<=tf<86400)
%       xf: Pacemaker state variable #1 (x-axix) final value
%       xcf: Pacemaker state variable #2 (y-axix) final value
%

%% Create local variables
nsteps = 30;

%% Initial loop values
t1 = t0;
t2 = t1 + increment;

%% Loop
for iStep = 1:length(lightArray)-1
    % Set light drive
    lightDrive = (lightArray(iStep) + lightArray(iStep + 1))/2;
    
    [tf,xf,xcf] = rk4stepperSec(x0,xc0,lightDrive,t1,t2,nsteps);
    
    % update loop variables
    t1 = t2;
    t2 = t1 + increment;
    x0 = xf;
    xc0 = xcf;
end

end





