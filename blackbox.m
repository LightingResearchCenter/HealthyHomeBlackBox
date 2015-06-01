function [scheduleStruct,pacemakerStruct,distanceToGoal,acrophase] = blackbox(targetPhase,lightReadingStruct,activityReadingStruct,pacemakerStruct)
%BLACKBOX Create light treatment schedule and measure progress toward goal.
%
%   [SCHEDULEOBJ,PACEMAKEROBJ,DISTANCETOGOAL] = BLACKBOX(GOALOBJ,
%   LIGHTREADINGOBJ,ACTIVITYREADINGOBJ) On the first run a pacemakerObj has
%   not yet been created so it is omitted from the input. GOALOBJ is an
%   object of class goal. LIGHTREADINGOBJ is an object of class
%   lightReading. ACTIVITYREADINGOBJ is an object of class activityReading.
%
%   [scheduleObj,pacemakerObj,distanceToGoal] = BLACKBOX(...,
%   prevPacemakerObj) On subsequent calls to this function provide the 
%   previous pacemakerObj as an input.
%
%   See also INCLUDES.GOAL, INCLUDES.LIGHTREADING, INCLUDES.ACTIVITYREADING,
%   INCLUDES.PACEMAKEROBJ, INCLUDES.SCHEDULEOBJ.

%   Author(s): G. Jones,    2015-05-21
%   	       A. Bierman,  2015-05-26
%   Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved.

%   References:
%     reference goes here

% Parameter constants
phaseDiffMax = 5*3600; % seconds


% Return empty results and exit if less than 24 hours of data
%if (~isempty(lightReadingStruct))
lightDuration = lightReadingStruct.timeUTC(end) - lightReadingStruct.timeUTC(1);
activityDuration = activityReadingStruct.timeUTC(end) - activityReadingStruct.timeUTC(1);
if lightDuration < 86400 || activityDuration < 86400
    scheduleStruct = [];
    pacemakerStruct	= [];
    distanceToGoal	= [];
    acrophase = [];
    return
end

% Truncate data to 10 most recent days
tenDays = 86400*10;
if lightDuration > tenDays
    idx = lightReadingStruct.timeUTC >= (lightReadingStruct.timeUTC(end) - tenDays);
    lightReadingStruct.timeUTC = lightReadingStruct.timeUTC(idx);
    lightReadingStruct.cs = lightReadingStruct.cs(idx);
end
if activityDuration > tenDays
    idx = activityReadingStruct.timeUTC >= (activityReadingStruct.timeUTC(end) - tenDays);
    activityReadingStruct.timeUTC = activityReadingStruct.timeUTC(idx);
    activityReadingStruct.activityIndex = activityReadingStruct.activityIndex(idx);
end

% Calculate activity acrophase
time = activityReadingStruct.timeUTC + activityReadingStruct.timeOffset; % seconds
[M,A,phi] = n_cosinorFit(time,activityReadingStruct.activityIndex,1/86400,1); % Fit activity data with cosine function
acrophase = -phi/pi*43200; % Time of day, in seconds, when acrophase occurs
%acrophase = mod(acrophase,86400)
%
if (acrophase < 0)
    acrophase = acrophase+86400; % 0 <= acrophase < 86400
end
%
% Check if the pacemakerStruct has previous values
if isempty(pacemakerStruct)
    [t0LocalRel,x0,xc0] = refPhaseTime2StateAtTime(acrophase,mod(time(1),86400),'activityAcrophase');
    t0 = t0LocalRel + 86400*floor(time(1)/86400) - activityReadingStruct.timeOffset; % convert back to absolute UTC Unix time
    %phaseDiffState = 0; % Initialize value
    CS = lightReadingStruct.cs;
else
    t0  = pacemakerStruct.t(end);
    x0  = pacemakerStruct.x(end);
    xc0	= pacemakerStruct.xc(end);
    t0LocalRel = mod(mod(t0,86400) + activityReadingStruct.timeOffset,86400);
    idx = find(lightReadingStruct.timeUTC > pacemakerStruct.t(end)); % light readings recorded since last run
    CS = lightReadingStruct.cs(idx);
end

% Advance pacemaker model solution to end of light and activity data
lightSampleIncrement = (lightReadingStruct.timeUTC(end) - lightReadingStruct.timeUTC(1))/(length(lightReadingStruct.timeUTC)-1);
% lightSampleIncrement = mode(round(diff(lightReadingObj.timeUTC))); % alternate method
[tfLocalRel,xf,xcf] = pacemakerModelRun(t0LocalRel,x0,xc0,lightSampleIncrement,CS);

% Calculate pacemaker state from activity acrophase
[~,xAcrophase,xcAcrophase] = refPhaseTime2StateAtTime(acrophase,mod(tfLocalRel,86400),'activityAcrophase');

% Calculate phase difference from pacemaker state variables
pacemakerPhase = atan2(xcf,xf)*43200/pi;
pacemakerPhase = mod(pacemakerPhase,86400);
activityPhase = atan2(xcAcrophase,xAcrophase)*43200/pi;
activityPhase = mod(activityPhase,86400);
phaseDiffState = pacemakerPhase - activityPhase;
if (phaseDiffState > 43200)
    phaseDiffState = 43200 - phaseDiffState;
elseif (phaseDiffState < -43200)
    phaseDiffState = -43200 - phaseDiffState;
end

% If phase difference between activity acrophase and the pacemaker model is
% greater than phaseDiffMax then reset model to activity acrophase
if abs(phaseDiffState) > phaseDiffMax
    idx = find(activityReadingStruct.timeUTC > pacemakerStruct.t(end),1,'first'); % first activity reading recorded since last run
    startTimeNewDataRel = mod(activityReadingStruct.timeUTC(idx) + activityReadingStruct.timeOffset,86400);
    [t0LocalRel,x0,xc0] = refPhaseTime2StateAtTime(acrophase,startTimeNewDataRel,'activityAcrophase');
    %t0 = t0LocalRel + 86400*floor(time(1)/86400) - activityReadingStruct.timeOffset; % convert back to absolute UTC Unix time
    [tfLocalRel,xf,xcf] = pacemakerModelRun(t0LocalRel,x0,xc0,lightSampleIncrement,CS);
    pacemakerPhase = atan2(xcf,xf)*43200/pi;
    display('RESET')
end

% Place state variables in pacemakerStruct structure
tf = t0 + (tfLocalRel-t0LocalRel); % convert to absoulute Unix time (seconds since Jan 1, 1970)
pacemakerStruct.t = tf;
pacemakerStruct.x = xf;
pacemakerStruct.xc = xcf;

currentRefPhaseTime = stateAtTime2RefPhaseTime(tfLocalRel,xAcrophase,xcAcrophase);
distanceToGoal = mod(targetPhase - currentRefPhaseTime,86400); % seconds
disp(['targetPhase = ',num2str(targetPhase/3600)]);
disp(['pacemakerPhase = ',num2str(currentRefPhaseTime/3600)]);

% Calculate light treatment schedule
increment = 3600; % seconds
lightLevel = 0.4; % CS
nDaysPlan = 2; % Days
scheduleStruct = createlightschedule(tf,xf,xcf,increment,targetPhase,lightLevel,nDaysPlan);

end