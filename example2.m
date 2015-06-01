%% Reset MATLAB
close all
clear
clc

%% Set static variables
pauseDuration	= 0.5;	% Pause time between loops in seconds
timeOffset      = -4*3600;	% Simulated offset from UTC in seconds
simDuration     = 2*3600;	% Duration of time to simulate in seconds
samplingInterval= 30;	% Simulated sampling interval in seconds
bedTime         = 22.5; % hour 0 <= bedTime < 24
wakeTime        = 6.5;  % hour, 0 <= wakeTime < 24

%% Define structures
lightReadingStruct.timeUTC = datenum2unix(now);
lightReadingStruct.timeOffset = timeOffset;
lightReadingStruct.red = [];
lightReadingStruct.green = [];
lightReadingStruct.blue = [];
lightReadingStruct.cla = [];
lightReadingStruct.cs = [];

activityReadingStruct.timeUTC = datenum2unix(now);
activityReadingStruct.timeOffset = timeOffset;
activityReadingStruct.activityIndex = [];
activityReadingStruct.activityCounts = [];

pacemakerStruct = [];
%pacemakerStruct.t = [];
%pacemakerStruct.x = [];
%pacemakerStruct.xc = [];

%% Simulate multiple runs
% Create and initialize figure
[figureHandle,axisHandle1,axisHandle2,axisHandle3,textHandle] = createFigure;

% Create initial set of simulated light and activity
startTimeUTC = datenum2unix(now); % seconds
[lightReadingStruct,activityReadingStruct] = simulateData(startTimeUTC,timeOffset,simDuration,samplingInterval);

% Calculate target phase
targetPhase = bedWakeTimes2TargetPhase(bedTime,wakeTime)

runflag = true;
while runflag % infinite loop
    [scheduleStruct,newPacemakerStruct,distanceToGoal,activityAcrophase] = blackbox(targetPhase,lightReadingStruct,activityReadingStruct,pacemakerStruct);
    % Append pacemakerStruct
    if ~isempty(newPacemakerStruct)
        if isempty(pacemakerStruct)
            pacemakerStruct.t = newPacemakerStruct.t;
            pacemakerStruct.x = newPacemakerStruct.x;
            pacemakerStruct.xc = newPacemakerStruct.xc;
        else
            pacemakerStruct.t = [pacemakerStruct.t;newPacemakerStruct.t];
            pacemakerStruct.x = [pacemakerStruct.x;newPacemakerStruct.x];
            pacemakerStruct.xc = [pacemakerStruct.xc;newPacemakerStruct.xc];
        end
    end
    
    updateFigure(axisHandle1,axisHandle2,axisHandle3,textHandle,lightReadingStruct,activityReadingStruct,pacemakerStruct,activityAcrophase,distanceToGoal);
    display(['Distance to goal = ',num2str(distanceToGoal/3600),' hours']); % hours
    pause(pauseDuration);
    
    % Generate simulated light and activity for next loop
    startTimeUTC = lightReadingStruct.timeUTC(end) + samplingInterval;
    [newLightReadingStruct,newActivityReadingStruct] = simulateData(startTimeUTC,timeOffset,simDuration,samplingInterval);
    lightReadingStruct.timeUTC = [lightReadingStruct.timeUTC;newLightReadingStruct.timeUTC];
    lightReadingStruct.cs = [lightReadingStruct.cs;newLightReadingStruct.cs];
    activityReadingStruct.timeUTC  = [activityReadingStruct.timeUTC;newActivityReadingStruct.timeUTC];
    activityReadingStruct.activityIndex  = [activityReadingStruct.activityIndex;newActivityReadingStruct.activityIndex];
end

display('The program has been stopped.');
