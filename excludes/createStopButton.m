function buttonHandle = createStopButton(figureHandle)
%CREATESTOPBUTTON Summary of this function goes here
%   Detailed explanation goes here

%figureUnits = figureHandle.Units;
figureUnits = get(figureHandle,'Units');
%figureHandle.Units = 'pixels';
set(figureHandle,'Units','pixels');

buttonHandle = uicontrol(figureHandle);
% buttonHandle.Style              = 'pushbutton';
% buttonHandle.String             = 'STOP';
% buttonHandle.Position           = [20 20 100 40];
% buttonHandle.Callback           = 'runflag=false;';
% buttonHandle.BackgroundColor	= 'red';
% buttonHandle.FontSize           = 16;
% buttonHandle.FontWeight         = 'bold';
set(buttonHandle,'Style','pushbutton','String','STOP','Position',[20 20 100 40],'Callback','runflag=false;',...
    'BackgroundColor','red','FontSize',16,'FontWeight','bold');

axisHandle	= gca;
%axisUnits	= axisHandle.Units;
axisUnits = get(axisHandle,'Units');
%buttonUnits = buttonHandle.Units;
buttonUnits = get(buttonHandle,'Units');

%axisHandle.Units	= 'pixels';
%buttonHandle.Units	= 'pixels';
set(buttonHandle,'Units','pixels');
set(axisHandle,'Units','pixels');

% Reposition the button
%figurePosition	= figureHandle.Position;
%axisPosition	= axisHandle.Position;
%buttonPosition	= buttonHandle.Position;
figurePosition = get(figureHandle,'Position');
axisPosition = get(axisHandle,'Position');
buttonPosition = get(buttonHandle,'Position');

x = (figurePosition(3) - buttonPosition(3))/2;
y = (figurePosition(4) - buttonPosition(4))/2;
% x = axisPosition(1)-450;
% y = axisPosition(1) - 180;
buttonPosition(1) = max([x,0]);
buttonPosition(2) = max([y,0]);
%buttonHandle.Position = buttonPosition;
set(buttonHandle,'Position',buttonPosition);

% Return units to starting value
%figureHandle.Units	= figureUnits;
%axisHandle.Units	= axisUnits;
%buttonHandle.Units  = buttonUnits;
set(figureHandle,'Units',figureUnits);
set(axisHandle,'Units',axisUnits);
set(buttonHandle,'Units',buttonUnits);
end

