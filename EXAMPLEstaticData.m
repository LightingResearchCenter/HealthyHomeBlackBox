% Reset MATLAB
close all
clear
clc

addpath('excludes');

% Set constants
bedTime         = 22.5; % hours, 0 <= bedTime < 24
riseTime        = 6.5;  % hours, 0 <= wakeTime < 24
runTimeUTC      = 1437637059.724; % Normally from system
runTimeOffset	= -5; % Normally from system

% Initialize file paths
filePaths = struct(             ...
    'lightReading',     ['testData',filesep,'lightReading.csv'],	...
    'activityReading',	['testData',filesep,'activityReading.csv'],	...
    'pacemaker',        ['testData',filesep,'pacemaker.csv']	...
    );

% Open the files for read only
filePointers = LRCopen(filePaths,'r');

% Initialize input struct
InputStruct = struct(                                           ...
    'runTimeUTC',               runTimeUTC,                     ...
    'runTimeOffset',            runTimeOffset,                  ...
    'bedTime',                  bedTime,                        ...
    'riseTime',                 riseTime,                       ...
    'lightReadingPointer',      filePointers.lightReading,      ...
    'activityReadingPointer',   filePointers.activityReading,   ...
    'pacemakerPointer',         filePointers.pacemaker          ...
    );

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% RUN THE MODEL                    %
OutputStruct = wrapper(InputStruct);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

% Close the files
fclose('all');

% Reopen the pacemaker file for appending
fid = fopen(filePaths.pacemaker,'a');
% Append new pacemaker struct to file
LRCappend_file(fid,OutputStruct.pacemaker);
fclose(fid);

% Compare results to reference
treatment = OutputStruct.treatment;
treatment = struct2table(treatment);

reference_treatment = struct(...
    'startTimeUTC', [1.437657774724000e+09;1.437737874724000e+09],...
    'durationMins', [720;180]...
    );
reference_treatment = struct2table(reference_treatment);

display(treatment);
display(reference_treatment);
