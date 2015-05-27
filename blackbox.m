function [scheduleObj,pacemakerObj,distanceToGoal] = blackbox(goalObj,lightReadingObj,activityReadingObj,varargin)
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

% Import classdefs
import includes.*

% Parse input
p = inputParser;
addRequired(p,'goalObj',@(x)isa(x,'includes.goal'));
addRequired(p,'lightReadingObj',@(x)isa(x,'includes.lightReading'));
addRequired(p,'activityReadingObj',@(x)isa(x,'includes.activityReading'));
addOptional(p,'pacemakerObj',[],@(x)isa(x,'includes.pacemaker'));
parse(p,goalObj,lightReadingObj,activityReadingObj,varargin{:});

% Reassign parsed input
goalObj = p.Results.goalObj;
lightReadingObj = p.Results.lightReadingObj;
activityReadingObj = p.Results.activityReadingObj;
pacemakerObj = p.Results.pacemakerObj;

% Return empty results and exit if less than 24 hours of data
lightDuration    = lightReadingObj.timeUTC(end)    - lightReadingObj.timeUTC(1);
activityDuration = activityReadingObj.timeUTC(end) - activityReadingObj.timeUTC(1);
if lightDuration < 86400 || activityDuration < 86400
    scheduleObj     = [];
    pacemakerObj	= [];
    distanceToGoal	= [];
    return
end

% Truncate data to 10 most recent days
tenDays = 86400*10;
if lightDuration > tenDays
    idx = lightReadingObj.timeUTC >= lightReadingObj.timeUTC(end) - tenDays;
    lightReadingObj = lightReadingObj.truncate(idx);
end
if activityDuration > tenDays
    idx = activityReadingObj.timeUTC >= activityReadingObj.timeUTC(end) - tenDays;
    activityReadingObj = activityReadingObj.truncate(idx);
end

% Check if the pacemakerObj has seed values
if isempty(pacemakerObj)
    [t0,x0,xc0] = refPhaseTime2StateAtTime(acrophase,startHour,'activityAcrophase');
else
    t0  = pacemakerObj.tn;
    x0  = pacemakerObj.xn;
    xc0	= pacemakerObj.xcn;
end


end

