classdef activityReading
    %ACTIVITYREADING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Dependent)
        timeUTC
        timeOffset
        activityIndex
        activityCounts
    end
    
    properties (Access=private)
        privateTimeUTC
        privateTimeOffset
        privateActivityIndex
        privateActivityCounts
    end
    
    methods
        % Object creation
        function obj = lightReading(timeUTC,timeOffset,varargin)
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = [];
            addRequired(p,'timeUTC',@isnumeric);
            addRequired(p,'timeOffset',@isnumeric);
            addParameter(p,'activityIndex',defaultValue,@isnumeric);
            addParameter(p,'activityCounts',defaultValue,@isnumeric);
            parse(p,timeUTC,timeOffset,varargin{:});
            
            timeUTC = p.Results.timeUTC(:);
            
            nTime = numel(timeUTC);
            arraySize = size(timeUTC);
            onesArray = ones(arraySize);
            zerosArray = zeros(arraySize);
            
            if numel(p.Results.timeOffset) ~= nTime;
                timeOffset = onesArray*p.Results.timeOffset(1);
            else
                timeOffset = p.Results.timeOffset(:);
            end
            
            % Check if variables are empty, make arrays equal size
            if isempty(p.Results.activityIndex)
                activityIndex = zerosArray;
            elseif numel(p.Results.activityIndex) ~= nTime
                error('Array size of red does not mach timeUTC');
            else
                activityIndex = p.Results.activityIndex(:);
            end
            
            if isempty(p.Results.activityCounts)
                activityCounts = zerosArray;
            elseif numel(p.Results.activityCounts) ~= nTime
                error('Array size of green does not mach timeUTC');
            else
                activityCounts = p.Results.activityCounts(:);
            end
            
            % Assign variables
            obj.privateTimeUTC          = timeUTC;
            obj.privateTimeOffset       = timeOffset;
            obj.privateActivityIndex	= activityIndex;
            obj.privateActivityCounts	= activityCounts;
        end
        
        function obj = append(obj,newObj)
            obj.privateTimeUTC          = [obj.timeUTC; newObj.timeUTC];
            obj.privateTimeOffset       = [obj.timeOffset; newObj.timeOffset];
            obj.privateActivityIndex	= [obj.activityIndex; newObj.activityIndex];
            obj.privateActivityCounts	= [obj.activityCounts; newObj.activityCounts];
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

