function [firstFloatColNum] = findFirstFloatColumn(table)

% Initialise an array to store the remainders
[numRows, numCols] = size(table);
remainders = zeros(numRows, numCols);

% Find the non integer section of each table value
parfor i = 1:numRows
    for j = 1:numCols
        try
            remainders(i,j) = mod(table2array(table(i,j)), 1);
        catch
            remainders(i,j) = 0;
        end
    end
end

% Sum the columns to find if there are any remainders
remainderTotals = nansum(remainders);


% Set the first 
for i=1:numCols
    if (remainderTotals(i)~=0)
        firstFloatColNum = i;
        return
    end
end

ME = MException('MATLAB:UndefinedFunction', 'No float columns found');
throw(ME);

