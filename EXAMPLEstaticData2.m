%% Reset MATLAB
close all
clear
clc

%%
addpath('excludes');

%% Set constants
bedTime         = 22.5; 
riseTime        = 7.5;
runTimeUTC      = 1446437114;
runTimeOffset   = -5;
cropForDebug = false;

%% Initialize file paths
testDir = 'testData_2015-11-02';
filePaths = struct(             ...
    'lightReading',     [testDir,filesep,'lightReading.csv'],	...
    'activityReading',	[testDir,filesep,'activityReading.csv'],	...
    'pacemaker',        [testDir,filesep,'pacemaker.csv']	...
    );
pacemakerTemplate = [testDir,filesep,'pacemakerTemplate.csv'];
pacemakerV1 = [testDir,filesep,'pacemaker_CandMATLAB_v1.csv'];
treatmentPath = [testDir,filesep,'treatment.csv'];
treatmentTemplate = [testDir,filesep,'treatmentTemplate.csv'];

if exist(filePaths.pacemaker,'file') == 2
    % Delete existing pacemaker file
    delete(filePaths.pacemaker);
end
% Create a copy of the pacemaker template and rename it
copyfile(pacemakerTemplate,filePaths.pacemaker);

%% Simulate running the pacemaker blackbox at each of the run times
for iRun = 1:numel(runTimeUTC)
    
    if exist(treatmentPath,'file') == 2
        % Delete existing treatment file
        delete(treatmentPath);
    end
    % Create a copy of the treatment template and rename it
    copyfile(treatmentTemplate,treatmentPath);

    % Open the files for read only
    filePointers = LRCopen(filePaths,'rt');

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
    OutputStruct = wrapper(InputStruct,cropForDebug);
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

    % Close the files
    fclose('all');

    % Reopen the pacemaker file for appending
    fid = fopen(filePaths.pacemaker,'at');
    % Append new pacemaker struct to file
    LRCappend_file(fid,OutputStruct.pacemaker);
    fclose(fid);
    
    
    % Format treatment for output
    treatment = struct;
    treatment.startTime = OutputStruct.treatment.startTimeUTC;
    treatment.durationMins = OutputStruct.treatment.durationMins;
    treatment.subjectId = repmat({'geoff'},size(treatment.startTime));
    treatment.hubId = repmat({'debug'},size(treatment.startTime));
    
    % Reopen the treatment file for appending
    fid = fopen(treatmentPath,'at');
    % Append new pacemaker struct to file
    LRCappend_file(fid,treatment);
    fclose(fid);
    
end

%% Compare MATLAB pacemaker to that from the App
% Open MATLAB generated pacemaker file
fid = fopen(filePaths.pacemaker,'rt');
% Read contents of MATLAB pacemaker
pacemakerArrayMat = LRCread_pacemaker(fid);
fclose(fid);
% Open App generated pacemaker file
fid = fopen(pacemakerV1,'rt');
% Read contents of App pacemaker
pacemakerArrayV1 = LRCread_pacemaker(fid);
fclose(fid);

% Calculate delta for all numeric variables
% delta = MATLAB Result - V1 Result
pacemakerDelta = struct;
varNames = fieldnames(pacemakerArrayMat);
for iVar = 1:numel(varNames)
    thisVar = varNames{iVar};
    if isnumeric(pacemakerArrayMat.(thisVar)) && isnumeric(pacemakerArrayV1.(thisVar))
        pacemakerDelta.(thisVar) = pacemakerArrayMat.(thisVar) - pacemakerArrayV1.(thisVar);
    end
end
display('pacemakerDelta = MATLAB Pacemaker - MATLAB/C v1 Pacemaker');
display(any2csv(pacemakerDelta,'|',1));

