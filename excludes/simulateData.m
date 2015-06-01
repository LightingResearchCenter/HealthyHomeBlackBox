function [lightReadingStruct,activityReadingStruct] = simulateData(startTimeUTC,timeOffset,simDuration,samplingInterval)


% Separate time for activity and light readings to simulate data comming
% from different devices. A random offset of up to 30 seconds is added to
% each time array.
timeUTC_CS = (startTimeUTC+round(30*rand(1,1)):samplingInterval:startTimeUTC+simDuration)'; 
%phase = pi/8*rand(1,1);
phase = pi/8*rand(1,1);
CS = 0.5*rand(size(timeUTC_CS)).*sin(pi*timeUTC_CS/(24*3600)+phase).^6;
b = fir1(20,0.2);
CS = filtfilt(b,1,CS);

timeUTC_Activity = (startTimeUTC+round(30*rand(1,1)):samplingInterval:startTimeUTC+simDuration)';
%phase = phase - pi/4*rand(1,1);
phase = phase - pi/2*rand(1,1);
AI = 0.5*rand(size(timeUTC_Activity)).*sin(pi*timeUTC_Activity/(24*3600)+phase).^6;
AI(AI>0.05) = 1;
AI(AI<=0.05) = 0;
AI = rand(size(AI)).*AI;
AI = filtfilt(b,1,AI);

%lightReadingObj     = lightReading(timeUTC_CS,timeOffset,'cs',CS);
%activityReadingObj	= activityReading(timeUTC_Activity,timeOffset,'activityIndex',AI);
lightReadingStruct.timeUTC = timeUTC_CS;
lightReadingStruct.timeOffset = timeOffset;
lightReadingStruct.cs = CS;
activityReadingStruct.timeUTC = timeUTC_Activity;
activityReadingStruct.timeOffset = timeOffset;
activityReadingStruct.activityIndex = AI;
end