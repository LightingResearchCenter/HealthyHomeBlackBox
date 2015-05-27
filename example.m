%% Reset MATLAB
close all
clear
clc

%% Import supporting functions and classdefs
import includes.* % classdefs should be matched to those used in the app
import excludes.* % functions used purely to demo, exclude from build

%% Set static variables
version          = '0.0.0.1'; % Version of HealthyHome App
pauseDuration    = 0.01;      % Pause time between loops in seconds
simDuration      = 2;         % Duration of time to simulate in hours
samplingInterval = 30;        % Simulated sampling interval in seconds

%% Simulate multiple runs
% Create and initialize figure
[figureHandle,axisHandle1,axisHandle2] = createFigure;

% Create initial set of simulated light and activity
[startTimeUTC,timeOffset] = getTime;
[lightReadingObj,activityReadingObj] = simulateData(startTimeUTC,timeOffset,simDuration,samplingInterval);

runflag = true;
while runflag % infinite loop
    % Get current UTC time in UNIX from system and offset of local time to
    % UTC in hours.
    [runTimeUTC,runTimeOffset] = getTime;
    
    % If pacemakerObj does not exist or has empty variables call blackbox
    % without pacemakerObj as input
    if exist('pacemakerObj','var') ~= 2 || isempty(pacemakerObj.t0)
        [scheduleObj,pacemakerObj,distanceToGoal] = ...
            blackbox(runTimeUTC,runTimeOffset,version,...
            goalObj,lightReadingObj,activityReadingObj);
    else
        [scheduleObj,newPacemakerObj,distanceToGoal] = ...
            blackbox(runTimeUTC,runTimeOffset,version,...
            goalObj,lightReadingObj,activityReadingObj,pacemakerObj);
        % Append pacemakerObj
        pacemakerObj = pacemakerObj.append(newPacemakerObj);
    end
    
    updateFigure(axisHandle1,axisHandle2,lightReadingObj,activityReadingObj,pacemakerObj);
    pause(pauseDuration);
    
    % Generate simulated light and activity for next loop
    startTimeUTC = lightReadingObj.timeUTC(end) + samplingInterval;
    [newLightReadingObj,newActivityReadingObj] = simulateData(startTimeUTC,timeOffset,simDuration,samplingInterval);
    lightReadingObj     = lightReadingObj.append(newLightReadingObj);
    activityReadingObj  = activityReadingObj.append(newActivityReadingObj);
end

display('The program has been stopped.');

