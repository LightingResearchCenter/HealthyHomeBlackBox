%% Reset MATLAB
close all
clear
clc

%%
addpath('excludes');

%% Set static variables
pauseDuration	= 0;	% Pause time between loops in seconds
simDuration     = 2*3600;	% Duration of time to simulate in seconds
samplingInterval= 30;	% Simulated sampling interval in seconds
bedTime         = 22.5; % hours, 0 <= bedTime < 24
wakeTime        = 6.5;  % hours, 0 <= wakeTime < 24

%% Create initial data set. Replace with read from file.
pacemaker = [];
%pacemakerStruct.t = [];
%pacemakerStruct.x = [];
%pacemakerStruct.xc = [];

%% Simulate multiple runs
% Create and initialize figure
[figureHandle,axisHandle1,axisHandle2,axisHandle3,textHandle] = createFigure;

% Create initial set of simulated light and activity
[nowTimeUTC,nowTimeOffset] = getTime; % Current time and offset from system
[lightReading,activityReading] = simulateData(nowTimeUTC,nowTimeOffset,simDuration,samplingInterval);

runflag = true;
while runflag % infinite loop
    [scheduleStruct,newPacemaker,distanceToGoal,activityAcrophase] = blackbox(bedTime,wakeTime,lightReading,activityReading,pacemaker);
    % Append pacemakerStruct
    pacemaker = appendStruct(pacemaker,newPacemaker);
    
    updateFigure(axisHandle1,axisHandle2,axisHandle3,textHandle,lightReading,activityReading,pacemaker,activityAcrophase,distanceToGoal);
    display(['Distance to goal = ',num2str(distanceToGoal/3600),' hours']); % hours
    pause(pauseDuration);
    
    % Generate simulated light and activity for next loop
    startTimeUTC = lightReading.timeUTC(end) + samplingInterval;
    [newLightReadingStruct,newActivityReadingStruct] = simulateData(startTimeUTC,nowTimeOffset,simDuration,samplingInterval);
    lightReading = appendStruct(lightReading,newLightReadingStruct);
    activityReading = appendStruct(activityReading,newActivityReadingStruct);
end

display('The program has been stopped.');
