function [table] = removeUnderfilledRows(table, startColumn, endColumn, fillPercentage)

i = 1; % First row to be tested
[n, ~] = size(table); % Number of elements

% Repeat for each row
while i <= n
   if isUnderfilled(table2array(table(i,startColumn:endColumn)), fillPercentage)
        table(i,:) = [];
        n = n - 1; % Now one fewer row
   else
       i = i + 1; % Move to next row
   end
end