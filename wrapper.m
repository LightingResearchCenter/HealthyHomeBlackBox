function OutputStruct = wrapper(InputStruct)
%WRAPPER Summary of this function goes here
%   Detailed explanation goes here

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

