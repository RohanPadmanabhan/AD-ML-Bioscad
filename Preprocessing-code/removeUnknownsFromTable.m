function [table] = removeUnknownsFromTable(table, unknowns, startCol,endCol)

% Number of rows and columns
[~, p] = size(table);


% For each column
for i=startCol:endCol 
    
    
    lhs = table(:, 1:i-1);
    rhs = table(:, i+1:p);
    
    colName = table.Properties.VariableNames(i);
    
    centreCol = table(:, i);
    centreCol = removeUnknownWords(table2array(centreCol), unknowns);
    centreTable = array2table(centreCol);
  
    
    
    centreTable.Properties.VariableNames = colName;
    
    
    table = [lhs, centreTable, rhs];
end


