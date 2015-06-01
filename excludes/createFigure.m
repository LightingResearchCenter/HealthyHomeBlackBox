function [figureHandle,axisHandle1,axisHandle2,axisHandle3,textHandle] = createFigure
%CREATEFIGURE Summary of this function goes here
%   Detailed explanation goes here

figureHandle = figure;
configureFigure(figureHandle);

axisHandle1	= subplot(2,2,[1,2]);
configureAxis1(axisHandle1)

axisHandle2	= subplot(2,2,3);
configureAxis2(axisHandle2)

axisHandle3 = subplot(2,2,4);
textHandle = configureAxis3(axisHandle3);

% Create stop button
createStopButton(figureHandle);

end


function configureFigure(figureHandle)
%CONFIGUREFIGURE Intialize the figure settings

screenSize = get(groot,'ScreenSize');
figureSize = [200, 200, screenSize(3)-400, screenSize(4)-400]; % left, bottom, width, height

% figureUnits = figureHandle.Units;

figureUnits = get(figureHandle,'Units');

%figureHandle.ToolBar	= 'none';
%figureHandle.Units      = 'pixels';
%figureHandle.Position	= figureSize;
%figureHandle.Units      = figureUnits;
set(figureHandle,'Units','pixels','Position',figureSize); % 'ToolBar','none',
set(figureHandle,'Units',figureUnits);
end

function configureAxis1(axisHandle)
%CONFIGUREAXIS1 Initialize the first axis

hold(axisHandle,'on');

% Create empty data set
nowDatenum = now;
samplingInterval = 30/86400; % 30 seconds in datenum format
time = nowDatenum:samplingInterval:nowDatenum+10;
CS = zeros(size(time));
AI = zeros(size(time));

%axisHandle.YLim = [0 1];
%axisHandle.XLim = [time(1),time(end)];
set(axisHandle,'YLim',[0,1],'XLim',[time(1),time(end)]);

plotHandle = plot(axisHandle,time,CS,'b-',time,AI,'r-');

datetick(axisHandle,'x','mm/dd','keeplimits','keepticks')
xlabel('Time')
ylabel('Light (CS) and Activity (AI)')
legend('CS','AI','Location','SouthOutside','Orientation','Horizontal');
title('Simulated Input');

hold(axisHandle,'off');

% Link data
%plotHandle(1).XDataSource = 'timeCS';
%plotHandle(1).YDataSource = 'CS';
%plotHandle(2).XDataSource = 'timeAI';
%plotHandle(2).YDataSource = 'AI';
set(plotHandle(1),'XDataSource','timeCS');
set(plotHandle(1),'YDataSource','CS');
set(plotHandle(2),'XDataSource','timeAI');
set(plotHandle(2),'YDataSource','AI');
end

function configureAxis2(axisHandle)
%CONFIGUREAXIS2 Initialize the second axis

% Create empty data set
xf = [0];
xcf = [0];
xArray = [0];
xcArray = [0];
xAcrophase = [0];
xcAcrophase = [0];

%hold(axisHandle,'on');

set(axisHandle,'YLim',[-1.2,1.2],'XLim',[-1.2,1.2]);
plotHandle = plot(axisHandle,xf,xcf,'ro',xArray,xcArray,'b-',xAcrophase,xcAcrophase,'gs');

set(axisHandle,'DataAspectRatio',[1,1,1]);

%hold(axisHandle,'off');

% Link data
set(plotHandle(1),'XDataSource','xf');
set(plotHandle(1),'YDataSource','xcf');
set(plotHandle(2),'XDataSource','xArray');
set(plotHandle(2),'YDataSource','xcArray');
set(plotHandle(3),'XDataSource','xAcrophase');
set(plotHandle(3),'YDataSource','xcAcrophase');
end

function textHandle = configureAxis3(axisHandle)
%CONFIGUREAXIS2 Initialize the second axis

set(axisHandle,'YLim',[-1.2,1.2],'XLim',[-1.2,1.2]);
set(axisHandle,'DataAspectRatio',[1,1,1]);
theta = 0:.1:pi;
x1ring = 0.7*cos(theta);
y1ring = 0.7*sin(theta);
plotHandle1 = plot(axisHandle,x1ring,y1ring,'k-');
hold on
plotHandle2 = plot([0,0],[0,1],'r-','LineWidth',2);
hold off
set(gca,'XTick',[],'YTick',[])
textHandle = text(-0.25,-0.5,'NaN','FontSize',14);

% Link data
set(plotHandle2,'XDataSource','xNeedle');
set(plotHandle2,'YDataSource','yNeedle');
end
