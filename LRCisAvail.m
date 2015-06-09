function tf = LRCisAvail(unavailability,t1,t2)
%LRCISAVAIL Summary of this function goes here
%   Detailed explanation goes here

unavailStart = unavailability.startTimeUTC;
unavailEnd   = unavailStart + unavailability.durationSecs;

% Test that t1 and t2 do not overlap with any unavailable times
tf = all( (unavailEnd <= t1) | (unavailStart >= t2) );

end

