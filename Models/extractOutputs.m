function [outData, mcid, scoradType] = extractOutputs(tabularDataSet) 

%% Extract the output data

% Determine whether to use objective or total SCORAD
useObj = input('Use objective SCORAD? (1 or 0) ');

% Extract the appropriate data
if useObj
    outData = tabularDataSet.ObjectiveSCORAD;
    mcid = 9;
    scoradType = ' oSCORAD';
else
    outData = tabularDataSet.TotalSCORAD;
    mcid = 10;
    scoradType = ' totSCORAD';
end