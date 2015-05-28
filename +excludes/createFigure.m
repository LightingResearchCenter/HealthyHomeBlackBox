function [figureHandle,axisHandle1,axisHandle2] = createFigure
%CREATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

matlabVersionStr = version;
shortVersionStr = regexprep(matlabVersionStr,'(\d*\.\d*)\..*','$1');
versionNum = str2double(shortVersionStr);


% Import supporting functions
import excludes.*

figureHandle = figure;
configureFigure(figureHandle,versionNum);

axisHandle1	= subplot(1,2,1);
configureAxis1(axisHandle1,versionNum)

axisHandle2	= subplot(1,2,1);

% Create stop button
createStopButton(figureHandle,versionNum);

end


function configureFigure(figureHandle,versionNum)
%CONFIGUREFIGURE Intialize the figure settings

screenSize = get(groot,'ScreenSize');
figureSize = [200, 200, screenSize(3)-400, screenSize(4)-400]; % left, bottom, width, height

if versionNum < 8.4 % Code for older MATLAB
    figureUnits = get(figureHandle,'Units');
    
    set(figureHandle,'ToolBar','none');
    set(figureHandle,'Units','pixels');
    set(figureHandle,'Position',figureSize);
    set(figureHandle,'Units',figureUnits);
else % Code for newer MATLAB
    figureUnits = figureHandle.Units;

    figureHandle.ToolBar	= 'none';
    figureHandle.Units      = 'pixels';
    figureHandle.Position	= figureSize;
    figureHandle.Units      = figureUnits;
end

end

function configureAxis1(axisHandle,versionNum)
%CONFIGUREAXIS1 Initialize the first axis

hold(axisHandle,'on');

% Create empty data set
nowDatenum = now;
samplingRate = 30/86400; % 30 seconds in datenum format
time = nowDatenum:samplingRate:nowDatenum+10;
CS = zeros(size(time));
AI = zeros(size(time));

plotHandle = plot(axisHandle,time,CS,'b-',time,AI,'r-');

datetick('x','mm/dd','keeplimits','keepticks')
xlabel('Time')
ylabel('Light (CS) and Activity (AI)')
legend('CS','AI','Location','SouthOutside','Orientation','Horizontal');
title('Simulated Input');

hold(axisHandle,'off');


if versionNum < 8.4 % Code for older MATLAB
    set(axisHandle,'YLim',[0 1]);
    set(axisHandle,'XLim',[time(1),time(end)]);
    
    set(plotHandle(1),'XDataSource','timeCS');
    set(plotHandle(1),'YDataSource','CS');
    set(plotHandle(1),'XDataSource','timeAI');
    set(plotHandle(1),'YDataSource','AI');
else % Code for newer MATLAB
    axisHandle.YLim = [0 1];
    axisHandle.XLim = [time(1),time(end)];

    % Link data
    plotHandle(1).XDataSource = 'timeCS';
    plotHandle(1).YDataSource = 'CS';
    plotHandle(2).XDataSource = 'timeAI';
    plotHandle(2).YDataSource = 'AI';
end

end