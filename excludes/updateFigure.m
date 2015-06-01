function updateFigure(axisHandle1,axisHandle2,axisHandle3,textHandle,lightReadingStruct,activityReadingStruct,pacemakerStruct,activityAcrophase,distanceToGoal)
%UPDATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

timeCS = unix2datenum(lightReadingStruct.timeUTC) + unix2datenum(lightReadingStruct.timeOffset);
CS = lightReadingStruct.cs;
timeAI = unix2datenum(activityReadingStruct.timeUTC) + unix2datenum(activityReadingStruct.timeOffset);
AI = activityReadingStruct.activityIndex;

if ~isempty(pacemakerStruct)
    tf = pacemakerStruct.t(end);
    xf = pacemakerStruct.x(end);
    xcf = pacemakerStruct.xc(end);
    xArray = pacemakerStruct.x;
    xcArray = pacemakerStruct.xc;
    [~,xAcrophase,xcAcrophase] = refPhaseTime2StateAtTime(activityAcrophase,mod(tf,86400)+activityReadingStruct.timeOffset,'activityAcrophase');
else
    tf = 0;
    xf = 0;
    xcf = 0;
    xArray = 0;
    xcArray = 0;
    xAcrophase = 0;
    xcAcrophase = 0;
end

xNeedle = [0,-cos(distanceToGoal/86400*pi+pi/2)];
yNeedle = [0,sin(distanceToGoal/86400*pi+pi/2)];

%axisHandle1.XLim = [max(timeCS)-10, max(timeCS)];
%axisHandle1.XTick = floor(max(timeCS)-10):ceil(max(timeCS));
set(axisHandle1,'XLim',[max(timeCS)-10, max(timeCS)],'XTick',floor(max(timeCS)-10):ceil(max(timeCS)));
datetick(axisHandle1,'x','mm/dd','keeplimits','keepticks')
set(axisHandle2,'YLim',[-1.2,1.2],'XLim',[-1.2,1.2]);
set(axisHandle2,'DataAspectRatio',[1,1,1]);
set(axisHandle3,'YLim',[-1.2,1.2],'XLim',[-1.2,1.2]);
set(axisHandle3,'DataAspectRatio',[1,1,1]);
set(textHandle,'String',num2str(distanceToGoal/3600,'%.2f'));
%refreshdata;
refreshdata(gcf,'caller');
drawnow;



end

