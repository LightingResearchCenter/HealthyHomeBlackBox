function buttonHandle = createStopButton(figureHandle,versionNum)
%CREATESTOPBUTTON Summary of this function goes here
%   Detailed explanation goes here

if versionNum < 8.4 % Code for older MALTAB
    figureUnits = get(figureHandle,'Units');
    set(figureHandle,Units,'pixels');

    buttonHandle = uicontrol(figureHandle);
    set(buttonHandle,'Style','pushbutton');
    set(buttonHandle,'String','STOP');
    set(buttonHandle,'Position',[20 20 100 40]);
    set(buttonHandle,'Callback','runflag=false;');
    set(buttonHandle,'BackgroundColor','red');
    set(buttonHandle,'FontSize',16);
    set(buttonHandle,'FontWeight','bold');

    axisHandle	= gca;
    axisUnits	= get(axisHandle,'Units');
    buttonUnits = get(buttonHandle,'Units');

    set(axisHandle,'Units','pixels');
    set(buttonHandle,'Units','pixels');

    % Reposition the button
    figurePosition	= get(figureHandle,'Position');
    axisPosition	= get(axisHandle,'Position');
    buttonPosition	= get(buttonHandle,'Position');

    x = (axisPosition(1) - buttonPosition(3))/2;
    y = figurePosition(4) - x - buttonPosition(4);
    buttonPosition(1) = max([x,0]);
    buttonPosition(2) = max([y,0]);
    set(buttonHandle,'Position',buttonPosition);

    % Return units to starting value
    set(figureHandle,'Units',figureUnits);
    set(axisHandle,'Units',axisUnits);
    set(buttonHandle,'Units',buttonUnits);
else % Code for newer MATLAB
    figureUnits = figureHandle.Units;
    figureHandle.Units = 'pixels';

    buttonHandle = uicontrol(figureHandle);
    buttonHandle.Style              = 'pushbutton';
    buttonHandle.String             = 'STOP';
    buttonHandle.Position           = [20 20 100 40];
    buttonHandle.Callback           = 'runflag=false;';
    buttonHandle.BackgroundColor	= 'red';
    buttonHandle.FontSize           = 16;
    buttonHandle.FontWeight         = 'bold';

    axisHandle	= gca;
    axisUnits	= axisHandle.Units;
    buttonUnits = buttonHandle.Units;

    axisHandle.Units	= 'pixels';
    buttonHandle.Units	= 'pixels';

    % Reposition the button
    figurePosition	= figureHandle.Position;
    axisPosition	= axisHandle.Position;
    buttonPosition	= buttonHandle.Position;

    x = (axisPosition(1) - buttonPosition(3))/2;
    y = figurePosition(4) - x - buttonPosition(4);
    buttonPosition(1) = max([x,0]);
    buttonPosition(2) = max([y,0]);
    buttonHandle.Position = buttonPosition;

    % Return units to starting value
    figureHandle.Units	= figureUnits;
    axisHandle.Units	= axisUnits;
    buttonHandle.Units  = buttonUnits;
end

end

