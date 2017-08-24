function [catData] = extractCategoricalData(fullTable)

% Define start and end locations
catDataStartCol = 2;
catDataEndCol = 15;
catData = fullTable(:, catDataStartCol:catDataEndCol);

% Remove unncessary columns and convert to table
catData.EtnicityChild = [];
catData.FLG2282del4 = [];
catData.FLGFailed = [];
catData.FLGS3247X = [];
catData.FLGNumberOfMutations = [];
catData.FLGR2447X = [];
catData.FLGR501X = [];
catData.skinTypeOther = [];

% Convert to table
catData = table2array(catData);