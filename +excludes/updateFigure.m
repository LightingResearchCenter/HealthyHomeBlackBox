function updateFigure(axisHandle1,axisHandle2,lightReadingObj,activityReadingObj,pacemakerObj)
%UPDATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

tempTimeCS = lightReadingObj.timeUTC;
tempTimeAI = activityReadingObj.timeUTC;

maxTimeUTC = max([tempTimeCS(:);tempTimeAI(:)]);
minTimeUTC = maxTimeUTC - 10*24*60*60;

last10daysCS = tempTimeCS >= minTimeUTC;
last10daysAI = tempTimeAI >= minTimeUTC;

timeCS = lightReadingObj.timeUTC(last10daysCS);
CS = lightReadingObj.cs(last10daysCS);

timeAI = activityReadingObj.timeUTC(last10daysAI);
AI = activityReadingObj.activityIndex(last10daysAI);

axisHandle1.XLim = [max(timeCS)-10, max(timeCS)];
axisHandle1.XTick = floor(max(timeCS)-10):ceil(max(timeCS));
datetick('x','mm/dd','keeplimits','keepticks')
refreshdata;
drawnow;

% Pacemaker phase state plotting not yet supported

end

