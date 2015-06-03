function [treatment,pacemaker,distanceToGoal] = blackbox(runTimeUTC,runTimeOffset,bedTime,riseTime,lightReading,activityReading,pacemakerArray)
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

% Import globals
global LRCparam

% Initialize outputs
treatment = struct(     ...
    'startTimeUTC', [], ...
    'durationMins', []	...
    );
pacemaker = struct(      ...
    'runTimeUTC',       runTimeUTC,	...
    'runTimeOffset',	runTimeOffset,	...
    'version',          LRCparam.version,	...
    'model',            LRCparam.model,	...
    'x0',               [],	...
    'xc0',              [],	...
    't0',               [],	...
    'xn',               [],	...
    'xcn',              [],	...
    'tn',               []	...
    );
distanceToGoal = [];

% Return empty results and exit if either data is empty
if isempty(lightReading.timeUTC) || isempty(activityReading.timeUTC)
    return;
end
% Return empty results and exit if less than 24 hours of data
lightDuration = lightReading.timeUTC(end) - lightReading.timeUTC(1);
activityDuration = activityReading.timeUTC(end) - activityReading.timeUTC(1);
if lightDuration < 86400 || activityDuration < 86400
    return
end

% Truncate data to most recent
lightReading    = LRCtruncate_reading(lightReading,   LRCparam.readingDuration);
activityReading = LRCtruncate_reading(activityReading,LRCparam.readingDuration);
lastPacemaker   = LRCtruncate_pacemaker(pacemakerArray);

% Calculate target phase
targetPhase = bedWakeTimes2TargetPhase(bedTime,riseTime);

% Calculate activity acrophase
activityTimeLocal = LRCutc2local(activityReading.timeUTC,activityReading.timeOffset);
% Fit activity data with cosine function
[~,~,phi] = LRCcosinorFit(activityTimeLocal,activityReading.activityIndex);
acrophase = -phi/pi*43200; % Time of day, in seconds, when acrophase occurs

if (acrophase < 0)
    acrophase = acrophase+86400; % 0 <= acrophase < 86400
end

% Check if the pacemakerStruct has previous values
if isempty(lastPacemaker.tn) || isnan(lastPacemaker.tn)
    [t0LocalRel,x0,xc0] = refPhaseTime2StateAtTime(acrophase,mod(activityTimeLocal(1),86400),'activityAcrophase');
    % convert back to absolute UTC Unix time
    t0Local = t0LocalRel + 86400*floor(activityTimeLocal(1)/86400);
    t0 = LRClocal2utc(t0Local,activityReading.timeOffset(1));
    CS = lightReading.cs;
else
    t0  = lastPacemaker.tn;
    x0  = lastPacemaker.xn;
    xc0	= lastPacemaker.xcn;
%     t0LocalRel = mod(mod(t0,86400) + activityReading.timeOffset(1),86400);
    t0Local = LRCutc2local(t0,activityReading.timeOffset(1));
    t0LocalRel = LRCabs2relTime(t0Local);
    idx = lightReading.timeUTC > lastPacemaker.tn; % light readings recorded since last run
    CS = lightReading.cs(idx);
end

% Advance pacemaker model solution to end of light and activity data
lightSampleIncrement = (lightReading.timeUTC(end) - lightReading.timeUTC(1))/(length(lightReading.timeUTC)-1);
% lightSampleIncrement = mode(round(diff(lightReadingObj.timeUTC))); % alternate method
[tnLocalRel,xn,xcn] = pacemakerModelRun(t0LocalRel,x0,xc0,lightSampleIncrement,CS);

% Calculate pacemaker state from activity acrophase
[~,xAcrophase,xcAcrophase] = refPhaseTime2StateAtTime(acrophase,mod(tnLocalRel,86400),'activityAcrophase');

% Calculate phase difference from pacemaker state variables
phaseDiff = LRCphaseDifference(xcn,xn,xcAcrophase,xAcrophase);

% If phase difference between activity acrophase and the pacemaker model is
% greater than phaseDiffMax then reset model to activity acrophase
if abs(phaseDiff) > LRCparam.phaseDiffMax
    idx = find(activityReading.timeUTC > lastPacemaker.tn,1,'first'); % first activity reading recorded since last run
    startTimeNewDataLocal = LRCutc2local(activityReading.timeUTC(idx),activityReading.timeOffset(idx));
    startTimeNewDataRel = LRCabs2relTime(startTimeNewDataLocal);
    [t0LocalRel,x0,xc0] = refPhaseTime2StateAtTime(acrophase,startTimeNewDataRel,'activityAcrophase');
    %t0 = t0LocalRel + 86400*floor(time(1)/86400) - activityReadingStruct.timeOffset; % convert back to absolute UTC Unix time
    [tnLocalRel,xn,xcn] = pacemakerModelRun(t0LocalRel,x0,xc0,lightSampleIncrement,CS);
    pacemakerPhase = atan2(xcn,xn)*43200/pi;
end

% Place state variables in pacemakerStruct structure
tn = t0 + (tnLocalRel-t0LocalRel); % convert to absoulute Unix time (seconds since Jan 1, 1970)

currentRefPhaseTime = stateAtTime2RefPhaseTime(tnLocalRel,xAcrophase,xcAcrophase);
% Calculate distance to goal phase from current phase
distanceToGoal = LRCdistanceToGoal(currentRefPhaseTime,targetPhase);

% Calculate light treatment schedule
increment = 3600; % seconds
lightLevel = 0.4; % CS
nDaysPlan = 2; % Days
treatment = createlightschedule(tn,xn,xcn,increment,targetPhase,lightLevel,nDaysPlan);

% Assign values to output
pacemaker.x0  = x0;
pacemaker.xc0 = xc0;
pacemaker.t0  = t0;
pacemaker.xn  = xn;
pacemaker.xcn = xcn;
pacemaker.tn  = tn;

end