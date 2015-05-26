function [lightReadingObj,activityReadingObj] = simulateData(startTimeUTC,timeOffset,simDuration,samplingRate)

import includes.*

increment = 1/60; % minute intervals
if (endHour < startHour)
    endHour = endHour + 24;
end
time = (startHour:increment:endHour)';
phase = pi/8*rand(1,1);
CS = 0.5*rand(size(time)).*sin(pi*time/24+phase).^6;
b = fir1(20,0.2);
CS = filtfilt(b,1,CS);

phase = phase - pi/4*rand(1,1);
AI = 0.5*rand(size(time)).*sin(pi*time/24+phase).^6;
AI(AI>0.05) = 1;
AI(AI<=0.05) = 0;
AI = rand(size(AI)).*AI;
AI = filtfilt(b,1,AI);

lightReadingObj     = lightReading(timeUTC,timeOffset,'cs',CS);
activityReadingObj	= activityReading(timeUTC,timeOffset,'activityIndex',AI);

end