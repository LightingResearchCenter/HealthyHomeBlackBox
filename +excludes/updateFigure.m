function updateFigure(axisHandle1,axisHandle2,lightReadingObj,activityReadingObj,pacemakerObj)
%UPDATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

axisHandle1.XLim = [max(timeCS)-10, max(timeCS)];
axisHandle1.XTick = floor(max(timeCS)-10):ceil(max(timeCS));
datetick('x','mm/dd','keeplimits','keepticks')
refreshdata;
drawnow;

end

