function [treatmentObj,pacemakerObj,distanceToGoal] = blackbox(runTimeUTC,runTimeOffset,version,subjectId,hubId,goalObj,lightReadingObj,activityReadingObj,varargin)
%BLACKBOX Create light treatment schedule and measure progress toward goal.
%
%   [TREATMENTOBJ,PACEMAKEROBJ,DISTANCETOGOAL] = BLACKBOX(RUNTIMEUTC,
%   RUNTIMEOFFSET,VERSION,SUBJECTID,HUBID,GOALOBJ,LIGHTREADINGOBJ,
%   ACTIVITYREADINGOBJ) On the first run a pacemakerObj has not yet been 
%   created so it is omitted from the input. GOALOBJ is an object of class 
%   goal. LIGHTREADINGOBJ is an object of class lightReading. 
%   ACTIVITYREADINGOBJ is an object of class activityReading.
%
%   [TREATMENTOBJ,PACEMAKEROBJ,DISTANCETOGOAL] = BLACKBOX(...,
%   PREVPACEMAKEROBJ) On subsequent calls to this function provide the 
%   previous pacemakerObj as an input.
%
%   See also INCLUDES.GOAL, INCLUDES.LIGHTREADING, 
%   INCLUDES.ACTIVITYREADING, INCLUDES.PACEMAKER, INCLUDES.TREATMENT.

%   Author(s): G. Jones,    2015-05-21
%   	       A. Bierman,  2015-05-26
%   Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved.

%   References:
%     reference goes here

% Black Box model version
model = 'INSERT VERSION HERE';

% Import classdefs
import includes.*

% Parse input
p = inputParser;
addRequired(p,'runTimeUTC',@isnumeric);
addRequired(p,'runTimeOffset',@isnumeric);
addRequired(p,'version',@ischar);
addRequired(p,'subjectId',@ischar);
addRequired(p,'hubId',@ischar);
addRequired(p,'goalObj',@(x)isa(x,'includes.goal'));
addRequired(p,'lightReadingObj',@(x)isa(x,'includes.lightReading'));
addRequired(p,'activityReadingObj',@(x)isa(x,'includes.activityReading'));
addOptional(p,'pacemakerObj',[],@(x)isa(x,'includes.pacemaker'));
parse(p,runTimeUTC,runTimeOffset,version,subjectId,hubId,goalObj,...
    lightReadingObj,activityReadingObj,varargin{:});

% Reassign parsed input
goalObj = p.Results.goalObj;
lightReadingObj = p.Results.lightReadingObj;
activityReadingObj = p.Results.activityReadingObj;
pacemakerObj = p.Results.pacemakerObj;

% Return empty results and exit if less than 24 hours of data
lightDuration    = lightReadingObj.timeUTC(end)    - lightReadingObj.timeUTC(1);
activityDuration = activityReadingObj.timeUTC(end) - activityReadingObj.timeUTC(1);
if lightDuration < 86400 || activityDuration < 86400
    treatmentObj     = [];
    pacemakerObj	= pacemaker(runTimeUTC,runTimeOffset,version,model);
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

pacemakerObj = pacemaker(runTimeUTC,runTimeOffset,version,model,...
    'x0',x0,'xc0',xc0,'t0',t0,'xn',xn,'xcn',xcn,'tn',tn);
end

