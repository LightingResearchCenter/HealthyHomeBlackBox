%% Reset MATLAB
close all
clear
clc

%%
addpath('excludes');

%% Set constants
bedTime         = 22.5; % 10:30 pm, hours, 0 <= bedTime < 24
riseTime        = 7.5;  % 07:30 am, hours, 0 <= wakeTime < 24
runTimeUTC      = [1446437114, 1446441885, 1446451488, 1446474304]; % Normally from system
runTimeOffset	= [-5,-5,-5,-5]; % Normally from system

% Initialize file paths
testDir = 'testData_2015-11-02';
filePaths = struct(             ...
    'lightReading',     [testDir,filesep,'lightReading.csv'],	...
    'activityReading',	[testDir,filesep,'activityReading.csv'],	...
    'pacemaker',        [testDir,filesep,'pacemaker.csv']	...
    );
pacemakerTemplate = [testDir,filesep,'pacemakerTemplate.csv'];
pacemakerFromApp = [testDir,filesep,'pacemakerFromApp.csv'];


if exist(filePaths.pacemaker,'file') == 2
    % Delete existing pacemaker file
    delete(filePaths.pacemaker);
end
% Create a copy of the pacemaker template and rename it
copyfile(pacemakerTemplate,filePaths.pacemaker);

% Simulate running the pacemaker blackbox at each of the run times
for iRun = 1:numel(runTimeUTC)

% Open the files for read only
filePointers = LRCopen(filePaths,'r');

% Initialize input struct
InputStruct = struct(                                           ...
    'runTimeUTC',               runTimeUTC(iRun),               ...
    'runTimeOffset',            runTimeOffset(iRun),            ...
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

end

%% Compare MATLAB pacemaker to that from the App
% Open MATLAB generate pacemaker file
fidMat = fopen(filePaths.pacemaker,'r');
% Read contents of MATLAB pacemaker
pacemakerArrayMat = LRCread_pacemaker(fidMat);
% Open App generate pacemaker file
fidApp = fopen(pacemakerFromApp,'r');
% Read contents of App pacemaker
pacemakerArrayApp = LRCread_pacemaker(fidApp);

% Calculate delta for all numeric variables
% delta = MATLAB Result - App Result
delta = struct;
varNames = fieldnames(pacemakerArrayMat);
for iVar = 1:numel(varNames)
    thisVar = varNames{iVar};
    if isnumeric(pacemakerArrayMat.(thisVar)) && isnumeric(pacemakerArrayApp.(thisVar))
        delta.(thisVar) = pacemakerArrayMat.(thisVar) - pacemakerArrayApp.(thisVar);
    end
end
display('delta = MATLAB Result - App Result');
display(any2csv(delta,'|',1));
