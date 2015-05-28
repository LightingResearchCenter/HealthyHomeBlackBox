function lightReading = LRCread_lightReading(fid) %#codegen
%LRCREAD_LIGHTREADING Summary of this function goes here
%   Detailed explanation goes here

% Constants
global LRCparam
maxDataLength = uint8(ceil(LRCparam.maxDays*24*60*60/...
    LRCparam.nominalSamplingInterval));

% Variables
lightReading = struct(                          ...
    timeUTC,    int32.empty(maxDataLength,0),	...
    timeOffset, single.empty(maxDataLength,0),	...
    red,        double.empty(maxDataLength,0),	...
    green,      double.empty(maxDataLength,0),	...
    blue,       double.empty(maxDataLength,0),	...
    cla,        double.empty(maxDataLength,0),	...
    cs,         double.empty(maxDataLength,0)	...
    );

fscanf

end

