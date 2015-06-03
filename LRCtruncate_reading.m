function reading = LRCtruncate_reading(reading,durationSec)
%LRCTRUNCATE_READING Truncate lightReading or activityReading
%   Discards readings older than the specified duration. One of the fields
%   must be timeUTC. All fields must be vertical arrays of equal size.

cutoffTime = max(reading.timeUTC) - durationSec;
idx = reading.timeUTC >= cutoffTime;

fields = fieldnames(reading);
for iField = 1:numel(fields)
    thisField = fields{iField};
    reading.(thisField) = reading.(thisField)(idx);
end

end

