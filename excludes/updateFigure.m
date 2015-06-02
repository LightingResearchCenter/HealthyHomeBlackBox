function updateFigure(axisHandles,textHandle,filePaths,OutputStruct)
%UPDATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

axisHandle1 = axisHandles(1);
axisHandle2 = axisHandles(2);
axisHandle3 = axisHandles(3);

% Read data from disk
filePointers = LRCopen(filePaths,'r');
lightReading	= LRCread_lightReading(filePointers.lightReading);
activityReading	= LRCread_activityReading(filePointers.activityReading);
pacemaker       = LRCread_pacemaker(filePointers.pacemaker);
LRCclose(filePointers);

distanceToGoal = OutputStruct.distanceToGoal;

activityAcrophase = [];


timeCS = unix2datenum(lightReading.timeUTC) + lightReading.timeOffset/24;
CS = lightReading.cs;
timeAI = unix2datenum(activityReading.timeUTC) + activityReading.timeOffset/24;
AI = activityReading.activityIndex;

if ~isempty(pacemaker)
    tn = pacemaker.tn(end);
    xn = pacemaker.xn(end);
    xcn = pacemaker.xcn(end);
    xArray = pacemaker.xn;
    xcArray = pacemaker.xcn;
%     [~,xAcrophase,xcAcrophase] = refPhaseTime2StateAtTime(activityAcrophase,mod(tn,86400)+activityReading.timeOffset,'activityAcrophase');
else
    tn = 0;
    xn = 0;
    xcn = 0;
    xArray = 0;
    xcArray = 0;
%     xAcrophase = 0;
%     xcAcrophase = 0;
end

xNeedle = [0,-cos(distanceToGoal/86400*pi+pi/2)];
yNeedle = [0,sin(distanceToGoal/86400*pi+pi/2)];


set(axisHandle1,'XLim',[max(timeCS)-10, max(timeCS)],'XTick',floor(max(timeCS)-10):ceil(max(timeCS)));
datetick(axisHandle1,'x','mm/dd','keeplimits','keepticks')
set(axisHandle2,'YLim',[-1.2,1.2],'XLim',[-1.2,1.2]);
set(axisHandle2,'DataAspectRatio',[1,1,1]);
set(axisHandle3,'YLim',[-1.2,1.2],'XLim',[-1.2,1.2]);
set(axisHandle3,'DataAspectRatio',[1,1,1]);
set(textHandle,'String',num2str(distanceToGoal/3600,'%.2f'));

refreshdata(gcf,'caller');
drawnow;



end

