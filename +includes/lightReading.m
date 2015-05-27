classdef lightReading
    %LIGHTREADING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Dependent)
        timeUTC
        timeOffset
        red
        green
        blue
        cla
        cs
    end
    
    properties (Access=private)
        privateTimeUTC
        privateTimeOffset
        privateRed
        privateGreen
        privateBlue
        privateCla
        privateCs
    end
    
    methods
        % Object creation
        function obj = lightReading(timeUTC,timeOffset,varargin)
            % Parse the matched pair input.
            p = inputParser;
            defaultValue = [];
            addRequired(p,'timeUTC',@isnumeric);
            addRequired(p,'timeOffset',@isnumeric);
            addParameter(p,'red',defaultValue,@isnumeric);
            addParameter(p,'green',defaultValue,@isnumeric);
            addParameter(p,'blue',defaultValue,@isnumeric);
            addParameter(p,'cla',defaultValue,@isnumeric);
            addParameter(p,'cs',defaultValue,@isnumeric);
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
            if isempty(p.Results.red)
                red = zerosArray;
            elseif numel(p.Results.red) ~= nTime
                error('Array size of red does not mach timeUTC');
            else
                red = p.Results.red(:);
            end
            
            if isempty(p.Results.green)
                green = zerosArray;
            elseif numel(p.Results.green) ~= nTime
                error('Array size of green does not mach timeUTC');
            else
                green = p.Results.green(:);
            end
            
            if isempty(p.Results.blue)
                blue = zerosArray;
            elseif numel(p.Results.blue) ~= nTime
                error('Array size of blue does not mach timeUTC');
            else
                blue = p.Results.blue(:);
            end
            
            if isempty(p.Results.cla)
                cla = zerosArray;
            elseif numel(p.Results.cla) ~= nTime
                error('Array size of cla does not mach timeUTC');
            else
                cla = p.Results.cla(:);
            end
            
            if isempty(p.Results.cs)
                cs = zerosArray;
            elseif numel(p.Results.cs) ~= nTime
                error('Array size of blue does not mach timeUTC');
            else
                cs = p.Results.cs(:);
            end
            
            % Assign variables
            obj.privateTimeUTC      = timeUTC;
            obj.privateTimeOffset	= timeOffset;
            obj.privateRed          = red;
            obj.privateGreen        = green;
            obj.privateBlue         = blue;
            obj.privateCla          = cla;
            obj.privateCs           = cs;
        end
        
        function obj = append(obj,newObj)
            obj.privateTimeUTC      = [obj.timeUTC; newObj.timeUTC];
            obj.privateTimeOffset	= [obj.timeOffset; newObj.timeOffset];
            obj.privateRed          = [obj.red; newObj.red];
            obj.privateGreen        = [obj.green; newObj.green];
            obj.privateBlue         = [obj.blue; newObj.blue];
            obj.privateCla          = [obj.cla; newObj.cla];
            obj.privateCs           = [obj.cs; newObj.cs];
        end
        
        function obj = truncate(obj,idx)
            obj.privateTimeUTC      = obj.timeUTC(idx);
            obj.privateTimeOffset	= obj.timeOffset(idx);
            obj.privateRed          = obj.red(idx);
            obj.privateGreen        = obj.green(idx);
            obj.privateBlue         = obj.blue(idx);
            obj.privateCla          = obj.cla(idx);
            obj.privateCs           = obj.cs(idx);
        end
        
        function timeUTC = get.timeUTC(obj)
            timeUTC = obj.privateTimeUTC;
        end
        
        function timeOffset = get.timeOffset(obj)
            timeOffset = obj.privateTimeOffset;
        end
        
        function red = get.red(obj)
            red = obj.privateRed;
        end
        
        function green = get.green(obj)
            green = obj.privateGreen;
        end
        
        function blue = get.blue(obj)
            blue = obj.privateBlue;
        end
        
        function cla = get.cla(obj)
            cla = obj.privateCla;
        end
        
        function cs = get.cs(obj)
            cs = obj.privateCs;
        end
        
    end
    
end

