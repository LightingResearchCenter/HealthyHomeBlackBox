function LRCparam = LRCconfig %#codegen
%LRCCONFIG Define static parameters.
%
%   See also STRUCT

%   Author(s): G. Jones,    2015-05-27
%   Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved.

LRCparam = struct(                      ...
    'model',            '0.1.0',        ...	% Model version
    'version',          LRCgetAppVer,   ... % REPLACE. Function to get app version
    'phaseDiffMax',     5*60*60,        ... % 5 hours in seconds, max allowed difference between activity acrophase and pacemaker
    'readingDuration',  10*24*60*60     ... % 10 days in seconds, duration of time to keep from readings
    );

end

