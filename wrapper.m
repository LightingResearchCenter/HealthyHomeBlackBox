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
lightReading	= LRCread_lightReading(lightReadingPointer);
activityReading	= LRCread_activityReading(activityReadingPointer);
pacemaker       = LRCread_pacemaker(pacemakerPointer);

% Call blackbox
[treatment,pacemaker,distanceToGoal] = blackbox(...
    runTimeUTC,runTimeOffset,bedTime,riseTime,  ...
    lightReading,activityReading,pacemaker      ...
    );

% Assign output
OutputStruct = struct(                  ...
    'treatment',        treatment,      ...
    'pacemaker',        pacemaker,      ...
    'distanceToGoal',   distanceToGoal	...
    );

end

