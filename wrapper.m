function OutputStruct = wrapper(InputStruct)
%WRAPPER wrapper function for BLACKBOX
%   Parses inputs and outputs. Reads input data from file.
%
%   See also BLACKBOX.

%   Author(s): G. Jones,    2015-06-01
%   Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved.

% Enable access to constants
% REPLACE with actual #define in C code
addpath('defines');

% Assign input
runTimeUTC              = InputStruct.runTimeUTC;
runTimeOffset           = InputStruct.runTimeOffset;
bedTime                 = InputStruct.bedTime;
riseTime                = InputStruct.riseTime;
lightReadingPointer     = InputStruct.lightReadingPointer;
activityReadingPointer	= InputStruct.activityReadingPointer;
pacemakerPointer        = InputStruct.pacemakerPointer;

% Perform file IO REPLACE with native C functions
lightReading0	 = LRCread_lightReading(lightReadingPointer);
activityReading0 = LRCread_activityReading(activityReadingPointer);
pacemakerArray   = LRCread_pacemaker(pacemakerPointer);
lastPacemaker    = LRCtruncate_pacemaker(pacemakerArray);

% Keep just the needed variables from light reading
lightReading = struct(                          ...
    'timeUTC',      lightReading0.timeUTC,      ...
    'timeOffset',	lightReading0.timeOffset,   ...
    'cs',           lightReading0.cs            ...
    );

% Keep just the needed variables from activity reading
activityReading = struct(                               ...
    'timeUTC',          activityReading0.timeUTC,       ...
    'timeOffset',       activityReading0.timeOffset,    ...
    'activityIndex',	activityReading0.activityIndex  ...
    );

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% DELETE ME
% Only use readings before runTimeUTC
% For testing ONLY
% Light Reading
idxL = lightReading.timeUTC <= runTimeUTC;
lightReading.timeUTC(~idxL) = [];
lightReading.timeOffset(~idxL) = [];
lightReading.cs(~idxL) = [];
% Activity Reading
idxA = lightReading.timeUTC <= runTimeUTC;
activityReading.timeUTC(~idxA) = [];
activityReading.timeOffset(~idxA) = [];
activityReading.activityIndex(~idxA) = [];
% END of DELETE ME
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Call blackbox
[treatment,pacemaker,distanceToGoal] = blackbox(    ...
    runTimeUTC,runTimeOffset,bedTime,riseTime,      ...
    lightReading,activityReading,lastPacemaker      ...
    );

% Assign output
OutputStruct = struct(                  ...
    'treatment',        treatment,      ...
    'pacemaker',        pacemaker,      ...
    'distanceToGoal',   distanceToGoal	...
    );

end

