function [table] = removeUnknownsFromTable(table, unknowns, startCol,endCol)

% Used to work around errors when converting a column from a string to
% double

% Number of rows and columns
[~, p] = size(table);

% For each column
for i=startCol:endCol 
    
    % Save columns to the left and right
    lhs = table(:, 1:i-1);
    rhs = table(:, i+1:p);
    
    % Save the name of the column
    colName = table.Properties.VariableNames(i);
    
    % Remove unknown words from the column
    centreCol = table(:, i);
    centreCol = removeUnknownWords(table2array(centreCol), unknowns);
    centreTable = array2table(centreCol);
  
    % Assign the name to the column
    centreTable.Properties.VariableNames = colName;
    
    % Combine the table again
    table = [lhs, centreTable, rhs];
end


