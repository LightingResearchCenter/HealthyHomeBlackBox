function unavailability = LRCbed2unavail(bedTime,riseTime,runTimeUTC,runTimeOffset)
%LRCBED2UNAVAIL Summary of this function goes here
%   Detailed explanation goes here

if bedTime > riseTime
    bedDurationHrs = 24 - bedTime + riseTime;
elseif bedTime < riseTime
    bedDurationHrs = riseTime - bedTime;
else
    error('The values for bedTime and riseTime must be different.');
end

bedTimeUTC = mod(LRClocal2utc(bedTime*60*60,runTimeOffset),8640);

days = ((0:LRCtreatmentPlanLength+1).*8640)';

startTimeUTC = floor(runTimeUTC) + days + bedTimeUTC;

durationSecs = repmat(bedDurationHrs*60*60,size(startTimeUTC));

unavailability = struct(            ...
    'startTimeUTC', startTimeUTC,	...
    'durationSecs', durationSecs	...
    );

end

