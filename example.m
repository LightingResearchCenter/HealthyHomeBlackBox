%% Reset MATLAB
close all
clear
clc

%% Import supporting functions and classdefs
import includes.* % classdefs should be matched to those used in the app
import excludes.* % functions used purely to demo, exclude from build

%% Set static variables
pauseDuration	= 0.01;	% Pause time between loops in seconds
timeOffset      = -4;	% Simulated offset from UTC in hours
simDuration     = 2;	% Duration of time to simulate in hours
samplingRate	= 30;	% Simulated sampling rate in seconds

%% Simulate multiple runs
% Create and initialize figure
[figureHandle,axisHandle1,axisHandle2] = createFigure;

% Create initial set of simulated light and activity
startTimeUTC = datenum2unix(now);
[lightReadingObj,activityReadingObj] = simulateData(startTimeUTC,timeOffset,simDuration,samplingRate);

runflag = true;
while runflag % infinite loop
    if isempty(pacemakerObj) || exist(pacemakerObj,'variable') ~= 2
        [scheduleObj,pacemakerObj,distanceToGoal] = blackbox(goalObj,lightReadingObj,activityReadingObj);
    else
        [scheduleObj,newPacemakerObj,distanceToGoal] = blackbox(goalObj,lightReadingObj,activityReadingObj,pacemakerObj);
        % Append pacemakerObj
        pacemakerObj = pacemakerObj.append(newPacemakerObj);
    end
    
    updateFigure(axisHandle1,axisHandle2,lightReadingObj,activityReadingObj,pacemakerObj);
    pause(pauseDuration);
    
    % Generate simulated light and activity for next loop
    startTimeUTC = lightReadingObj.timeUTC(end) + samplingRate;
    [newLightReadingObj,newActivityReadingObj] = simulateData(startTimeUTC,timeOffset,simDuration,samplingRate);
    lightReadingObj     = lightReadingObj.append(newLightReadingObj);
    activityReadingObj  = activityReadingObj.append(newActivityReadingObj);
end

display('The program has been stopped.');

