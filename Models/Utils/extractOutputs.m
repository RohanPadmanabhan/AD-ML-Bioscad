function [outData, mcid, maxSCORAD, scoradType] = extractOutputs(tabularDataSet)

%% Extract the output data

% Determine whether to use objective or total SCORAD
useObj = input('Use objective SCORAD? (1 or 0) ');

% Extract the appropriate data
if useObj
    try
        outData = tabularDataSet.ObjectiveSCORAD;
    catch
        outData = NaN;
    end
    mcid = 9;
    maxSCORAD = 83;
    scoradType = ' oSCORAD';
else
    try
        outData = tabularDataSet.TotalSCORAD;
    catch
        outData = NaN;
    end
    mcid = 10;
    maxSCORAD = 103;
    scoradType = ' totSCORAD';
end