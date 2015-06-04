function [scheduleStruct] = createlightschedule(t0,x0,xc0,targetReferencePhaseTime)
% CREATELIGHTSCHEDULE creates a schedule of light treatment times based on
% the current state of the pacemaker and a target phase.
%
%   Input:
%       t0: The relative time in hours corresponding to the state variable
%       values (0 <= t0 < 24)
%       x0: Pacemaker state variable #1 (x-axis)
%       xc0: Pacemaker state variable #2 (y-axis)
%       increment: The shortest light treatment time interval (seconds)
%       targetReferencePhaseTime: The target time for the reference phase
%       lightLevel: The level of light used for the perscription pulse(CS)
%       nDaysPlan: The number of days covered by the light schedule
%       
%   Output:
%       treatmentStartTimes: An array of treatment start times
%       treatDurations: An array of treatment durations corresponding to 
%       the treatmentStartTimes

% Create loop variables
nIterations = round(LRCtreatmentPlanLength*24*3600/LRCtreatmentInc);
lightScheduleArray = zeros(nIterations,1);
nsteps = 30;
t1 = t0;
t2 = t1 + LRCtreatmentInc;

% Loop
for iIteration = 1:nIterations
    % Create Target sinosoid
    xTarget = -cos(2*pi*(t1/(24*3600) - targetReferencePhaseTime/(24*3600)));
    xcTarget = sin(2*pi*(t1/(24*3600) - targetReferencePhaseTime/(24*3600)));
    
    % Simulate increment of time by running the model with no light
    [tfDark,xfDark,xcfDark] = rk4stepperSec(x0,xc0,0,t1,t2,nsteps);
    
    % Simulate increment of time by running the model with light at the
    % prescribed light level
    [tfLight,xfLight,xcfLight] = rk4stepperSec(x0,xc0,LRCtreatmentCS,t1,t2,nsteps);
    
    % Create phasor angles
    targetAngle = mod(atan2(xcTarget, xTarget)+pi, 2*pi); %Angle at target point
    withLightAngle = mod(atan2(xcfLight, xfLight)+pi, 2*pi); %Angle at predicted light point
    withoutLightAngle = mod(atan2(xcfDark, xfDark)+pi, 2*pi); %Angle at predicted without light point
    
    % Determine phase difference with and without light
    withLight = pi - abs(abs(targetAngle - withLightAngle) - pi); 
    withoutLight = pi - abs(abs(targetAngle - withoutLightAngle) - pi); 
    
    % Choose best plan
    if withLight < withoutLight
        lightScheduleArray(iIteration) = LRCtreatmentCS;
        x0 = xfLight;
        xc0 = xcfLight;
    else
        lightScheduleArray(iIteration) = 0;
        x0 = xfDark;
        xc0 = xcfDark;
    end
        
    % Update loop variables
    t1 = t2;
    t2 = t2 + LRCtreatmentInc;
    
end

% Convert lightScheduleArray to treatment start times and durations
time = ((1:length(lightScheduleArray))-1)*LRCtreatmentInc + t0;
q = find(lightScheduleArray ~= 0);
qdiff = diff(q);
startTimes = time(q(find(qdiff>1)+1));
startTimes = [time(q(1)),startTimes];
% pad lightScheduleArray with zeros at start and end in order to find
% treatment durations that start (or end) at first (last) array element.
durations = LRCtreatmentInc*(find(diff([0;lightScheduleArray;0]) < 0) - find(diff([0;lightScheduleArray;0]) > 0));
scheduleStruct.startTimeUTC = startTimes;
scheduleStruct.durationMins = durations;

