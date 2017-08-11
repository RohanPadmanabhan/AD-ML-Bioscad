function [missingVal] = fillBlank(table, pointRow, pointCol)

% Convert the data to an array
dataAsArray = table2array(table);

% Save the column and remove it from the table
missingAttVals = dataAsArray(:, pointCol);
dataAsArray(:,pointCol) = [];  

% Find number of elements
[~, p] = size(dataAsArray);


% Remove columns in which the row in question has no value
i = 1;
while i<=p
   if isnan(dataAsArray(pointRow, i))
       dataAsArray(:,i) = [];
       [~, p] = size(dataAsArray);
   else
       i = i + 1;
   end
end


% Assign values with penalty for other missing NaN values
penalty = 1;
[n, p] = size(dataAsArray);
for i=1:n
    for j=1:p
       if isnan(dataAsArray(i,j))
          dataAsArray(i,j) = dataAsArray(pointRow, j) + penalty;
       end
    end
end

% Save and remove the row in question
missingRow = dataAsArray(pointRow, :);
dataAsArray(pointRow, :) = [];


% Rank the data points by distance
nearest = knnsearch(dataAsArray, missingRow, 'k', n);

% Find the closest non NaN value
for i=1:n
    nextNearestLoc = nearest(i);
    nextNearestVal = missingAttVals(nextNearestLoc, 1);
    if ~isnan(nextNearestVal)
        missingVal = nextNearestVal;
        return
    end   
end
