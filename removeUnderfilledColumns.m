function [table] = removeUnderfilledColumns(table, startColumn, endColumn, fillPercentage)

i = startColumn; % First column to be tested
while i <= endColumn
   if isUnderfilled(table2array(table(:,i)), fillPercentage)
        table(:,i) = [];
        endColumn = endColumn - 1; % Now one fewer column
   else
       i = i + 1; % Move to next column
   end
end