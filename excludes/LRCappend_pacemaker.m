function LRCappend_pacemaker(fileID,pacemaker)
%LRCAPPEND_PACEMAKER Append pacemaker values to file
%   Replace this with native function for iOS

fieldArray = fieldnames(pacemaker);

for iField = 1:numel(fieldArray);
    thisField = fieldArray{iField};
    thisObject = pacemaker.(thisField);
    
    % Define format
    thisFormat = determineFormat(thisField);
    formatSpec = [thisFormat,','];
    
    % Write to file
    fprintf(fileID,formatSpec,thisObject);
end

% Write new line characters
fprintf(fileID,'\r\n');

end

