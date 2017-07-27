function [underFilled] = isUnderfilled(col, cutOffPercentage)

% Input 1 : The column of data
% Input 2 : The minimum percentage of actual values required

% Number of items
n = length(col);

% Number of NaN values
countNaN = sum(isnan(col));

% Percentage of NaN values
percentageActualVals = ((n - countNaN) / n) * 100;

% Remove column if too many missing values of return unchanged
underFilled = (percentageActualVals <= cutOffPercentage);

