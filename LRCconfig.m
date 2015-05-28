function LRCconfig %#codegen
%LRCCONFIG Gloabally declare and define parameters.
%   Define static parameters and make them accessable from a global
%   variable.
%
%   % Example:
%   %   Call LRCCONFIG to initialize the parameters. Add LRCparam to the
%   %   current worspace. Access parameter within LRCparam.
%
%   LRCconfig;
%   global LRCparam
%   paramValue = LRCparam.paramName;
%
%   See also GLOBAL, STRUCT

%   Author(s): G. Jones,    2015-05-27
%   Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved.

global LRCparam

LRCparam = struct(              ...
    'model',        '0.1.0',    ...	% Model version
    'paramName2',	2           ...
    );

end

