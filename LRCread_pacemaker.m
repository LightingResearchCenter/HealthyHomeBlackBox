function pacemaker = LRCread_pacemaker(fileID)
%LRCREAD_PACEMAKER Replace with native C functions
%   For use with MATLAB only. DO NOT use for codegen.

[runTimeUTC,runTimeOffset,version,model,x0,xc0,t0,xn,xcn,tn] = importfile(fileID);

pacemaker = struct(                             ...
    'runTimeUTC',       int32(runTimeUTC),      ...
    'runTimeOffset',	single(runTimeOffset),	...
    'version',          char(version),          ...
    'model',            char(model),            ...
    'x0',	double(x0),     ...
    'xc0',	double(xc0),	...
    't0',	int32(t0),      ...
    'xn',	double(xn),     ...
    'xcn',	double(xcn),	...
    'tn',	int32(tn)       ...
    );

end


function [runTimeUTC,runTimeOffset,version,model,x0,xc0,t0,xn,xcn,tn] = importfile(fileID)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [RUNTIMEUTC,RUNTIMEOFFSET,VERSION,MODEL,X0,XC0,T0,XN,XCN,TN] =
%   IMPORTFILE(FILENAME) Reads data from text file FILENAME for the default
%   selection.
%
%   [RUNTIMEUTC,RUNTIMEOFFSET,VERSION1,MODEL,X0,XC0,T0,XN,XCN,TN] =
%   IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [runTimeUTC,runTimeOffset,version,model,x0,xc0,t0,xn,xcn,tn] =
%   importfile('pacemaker.csv',2, 2);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2015/05/28 17:18:35

%% Initialize variables.
delimiter = ',';
startRow = 2;
endRow = inf;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: text (%s)
%	column4: text (%s)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%s%s%f%f%f%f%f%f%[^\n\r]';

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
runTimeUTC = dataArray{:, 1};
runTimeOffset = dataArray{:, 2};
version = dataArray{:, 3};
model = dataArray{:, 4};
x0 = dataArray{:, 5};
xc0 = dataArray{:, 6};
t0 = dataArray{:, 7};
xn = dataArray{:, 8};
xcn = dataArray{:, 9};
tn = dataArray{:, 10};


end