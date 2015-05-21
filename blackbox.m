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
%   % Example:
%   %   Description
%
%   example code goes here
%
%   See also FUNCTION, FUNCTION2, FUNCTION3.

%   Author(s): G. Jones, 2015-05-21
%   	         additional authors
%   Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved.

%   References:
%     reference goes here


end

