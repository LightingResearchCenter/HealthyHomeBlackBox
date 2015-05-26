function [figureHandle,axisHandle1,axisHandle2] = createFigure
%CREATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

% Import supporting functions
import excludes.*

figureHandle = figure;
configureFigure(figureHandle);

axisHandle1	= subplot(1,2,1);
configureAxis1(axisHandle1)

axisHandle2	= subplot(1,2,1);

% Create stop button
createStopButton(figureHandle);

end


function configureFigure(figureHandle)
%CONFIGUREFIGURE Intialize the figure settings

screenSize = get(groot,'ScreenSize');
figureSize = [200, 200, screenSize(3)-400, screenSize(4)-400]; % left, bottom, width, height

figureUnits = figureHandle.Units;

figureHandle.ToolBar	= 'none';
figureHandle.Units      = 'pixels';
figureHandle.Position	= figureSize;
figureHandle.Units      = figureUnits;
end

function configureAxis1(axisHandle)
%CONFIGUREAXIS1 Initialize the first axis

hold(axisHandle,'on');

% Create empty data set
nowDatenum = now;
samplingRate = 30/86400; % 30 seconds in datenum format
time = nowDatenum:samplingRate:nowDatenum+10;
CS = zeros(size(time));
AI = zeros(size(time));

axisHandle.YLim = [0 1];
axisHandle.XLim = [time(1),time(end)];

plotHandle = plot(axisHandle,time,CS,'b-',time,AI,'r-');

datetick('x','mm/dd','keeplimits','keepticks')
xlabel('Time')
ylabel('Light (CS) and Activity (AI)')
legend('CS','AI','Location','SouthOutside','Orientation','Horizontal');
title('Simulated Input');

hold(axisHandle,'off');

% Link data
plotHandle(1).XDataSource = 'timeCS';
plotHandle(1).YDataSource = 'CS';
plotHandle(2).XDataSource = 'timeAI';
plotHandle(2).YDataSource = 'AI';

end