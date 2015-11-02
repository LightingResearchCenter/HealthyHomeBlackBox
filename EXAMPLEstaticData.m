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

%% Initialize file paths
testDir = 'testData_2015-11-02';
filePaths = struct(             ...
    'lightReading',     [testDir,filesep,'lightReading.csv'],	...
    'activityReading',	[testDir,filesep,'activityReading.csv'],	...
    'pacemaker',        [testDir,filesep,'pacemaker.csv']	...
    );
pacemakerTemplate = [testDir,filesep,'pacemakerTemplate.csv'];
pacemakerFromApp = [testDir,filesep,'pacemakerFromApp.csv'];
treatmentPath = [testDir,filesep,'treatment.csv'];
treatmentTemplate = [testDir,filesep,'treatmentTemplate.csv'];
treatmentFromApp = [testDir,filesep,'treatmentFromApp.csv'];

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
    OutputStruct = wrapper(InputStruct);
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
fidMat = fopen(filePaths.pacemaker,'rt');
% Read contents of MATLAB pacemaker
pacemakerArrayMat = LRCread_pacemaker(fidMat);
fclose(fidMat);
% Open App generated pacemaker file
fidApp = fopen(pacemakerFromApp,'rt');
% Read contents of App pacemaker
pacemakerArrayApp = LRCread_pacemaker(fidApp);
fclose(fidApp);

% Calculate delta for all numeric variables
% delta = MATLAB Result - App Result
pacemakerDelta = struct;
varNames = fieldnames(pacemakerArrayMat);
for iVar = 1:numel(varNames)
    thisVar = varNames{iVar};
    if isnumeric(pacemakerArrayMat.(thisVar)) && isnumeric(pacemakerArrayApp.(thisVar))
        pacemakerDelta.(thisVar) = pacemakerArrayMat.(thisVar) - pacemakerArrayApp.(thisVar);
    end
end
display('pacemakerDelta = MATLAB Pacemaker - App Pacemaker');
display(any2csv(pacemakerDelta,'|',1));

%% Compare LAST MATLAB treatment to that from the App
% Open MATLAB generated treatment file
fidMat = fopen(treatmentPath,'rt');
% Read contents of MATLAB treatment
treatmentMat = LRCread_treatment(fidMat);
fclose(fidMat);
% Open App generated treatment file
fidApp = fopen(pacemakerFromApp,'rt');
% Read contents of App treatment
treatmentApp = LRCread_treatment(fidApp);
fclose(fidApp);

% Calculate delta for all numeric variables
% delta = MATLAB Result - App Result
treatmentDelta = struct;
varNames = fieldnames(treatmentMat);
for iVar = 1:numel(varNames)
    thisVar = varNames{iVar};
    if isnumeric(treatmentMat.(thisVar)) && isnumeric(treatmentApp.(thisVar))
        nMat = numel(treatmentMat.(thisVar));
        nApp = numel(treatmentApp.(thisVar));
        if nMat == nApp
            treatmentDelta.(thisVar) = treatmentMat.(thisVar) - treatmentApp.(thisVar);
        elseif nMat > nApp
            warning('More MATLAB treatments than App treatments')
            temp1 = treatmentMat.(thisVar)(1:nApp) - treatmentApp.(thisVar);
            temp2 = treatmentMat.(thisVar)(nApp+1:end) - 0;
            treatmentDelta.(thisVar) = [temp1;temp1];
        elseif nApp > nMat
            warning('More App treatments than MATLAB treatments')
            temp1 = treatmentMat.(thisVar) - treatmentApp.(thisVar)(1:nMat);
            temp2 = 0 - treatmentApp.(thisVar)(nMat+1:end);
            treatmentDelta.(thisVar) = [temp1;temp1];
        end
    end
end
display('treatmentDelta = MATLAB Treatment - App Treatment');
display(any2csv(treatmentDelta,'|',1));