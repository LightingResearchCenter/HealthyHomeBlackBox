function objectFormat = determineFormat(object)
%DETERMINEFORMAT Return the format string for an object based on its class
%   Detailed explanation goes here

if isfloat(object)
    objectFormat = '%f';
elseif isinteger(object)
    objectFormat = '%i';
elseif ischar(object)
    objectFormat = '%s';
else
    error(['Format not specified for class of: ',class(object)]);
end

end

