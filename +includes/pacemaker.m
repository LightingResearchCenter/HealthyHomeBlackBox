classdef pacemaker
    %PACEMAKER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Dependent)
        runTimeUTC
        runTimeOffset
        version
        model
        x0
        xc0
        t0
        xn
        xcn
        tn
    end
    
    properties (Access=private)
        privateRunTimeUTC
        privateRunTimeOffset
        privateVersion
        privateModel
        privateX0
        privateXc0
        privateT0
        privateXn
        privateXcn
        privateTn
    end
    
    methods
        % Object creation
        function obj = pacemaker(runTimeUTC,runTimeOffset,version,model,varargin)
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = [];
            addRequired(p,'runTimeUTC',@isnumeric);
            addRequired(p,'runTimeOffset',@isnumeric);
            addRequired(p,'version',@ischar|iscell);
            addRequired(p,'model',@ischar|iscell);
            addParameter(p,'x0',defaultValue,@isnumeric);
            addParameter(p,'xc0',defaultValue,@isnumeric);
            addParameter(p,'t0',defaultValue,@isnumeric);
            addParameter(p,'xn',defaultValue,@isnumeric);
            addParameter(p,'xcn',defaultValue,@isnumeric);
            addParameter(p,'tn',defaultValue,@isnumeric);
            parse(p,runTimeUTC,runTimeOffset,version,model,varargin{:});
            
            runTimeUTC = p.Results.runTimeUTC(:);
            
            nRunTime = numel(runTimeUTC);
            arraySize = size(runTimeUTC);
            onesArray = ones(arraySize);
            zerosArray = zeros(arraySize);
            
            if numel(p.Results.runTimeOffset) ~= nRunTime;
                runTimeOffset = onesArray*p.Results.runTimeOffset(1);
            else
                runTimeOffset = p.Results.runTimeOffset(:);
            end
            
            if ischar(p.Results.version)
                version = {p.Results.version};
            elseif iscell(p.Results.version)
                version = p.Results.version(:);
            end
            if numel(version) ~= nRunTime;
                version = repmat(version(1),arraySize);
            elseif iscell(p.Results.version)
                version = p.Results.version(:);
            end
            
            % Check if variables are empty, make arrays equal size
            if isempty(p.Results.activityIndex)
                activityIndex = zerosArray;
            elseif numel(p.Results.activityIndex) ~= nRunTime
                error('Array size of red does not mach timeUTC');
            else
                activityIndex = p.Results.activityIndex(:);
            end
            
            if isempty(p.Results.activityCounts)
                activityCounts = zerosArray;
            elseif numel(p.Results.activityCounts) ~= nRunTime
                error('Array size of green does not mach timeUTC');
            else
                activityCounts = p.Results.activityCounts(:);
            end
            
            % Assign variables
            obj.privateTimeUTC          = runTimeUTC;
            obj.privateTimeOffset       = runTimeOffset;
            obj.privateActivityIndex	= activityIndex;
            obj.privateActivityCounts	= activityCounts;
        end
        
        function obj = append(obj,newObj)
            obj.privateTimeUTC          = [obj.timeUTC; newObj.timeUTC];
            obj.privateTimeOffset       = [obj.timeOffset; newObj.timeOffset];
            obj.privateActivityIndex	= [obj.activityIndex; newObj.activityIndex];
            obj.privateActivityCounts	= [obj.activityCounts; newObj.activityCounts];
        end
        
        function obj = truncate(obj,idx)
            obj.privateTimeUTC          = obj.timeUTC(idx);
            obj.privateTimeOffset       = obj.timeOffset(idx);
            obj.privateActivityIndex	= obj.activityIndex(idx);
            obj.privateActivityCounts	= obj.activityCounts(idx);
        end
        
        function timeUTC = get.timeUTC(obj)
            timeUTC = obj.privateTimeUTC;
        end
        
        function timeOffset = get.timeOffset(obj)
            timeOffset = obj.privateTimeOffset;
        end
        
        function activityIndex = get.activityIndex(obj)
            activityIndex = obj.privateActivityIndex;
        end
        
        function activityCounts = get.activityCounts(obj)
            activityCounts = obj.privateActivityCounts;
        end
        
    end
    
end

