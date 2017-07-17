function [col] = normalizeColumn(col)

% Input 1 : The array of data
% Output : The normalized data

% Find the maximum and minimum values
minVal = min(col);
maxVal = max(col);

% Shift the lowest value to zero
col = col - minVal;

% Divide by range to scale between 0 & 1;
range = maxVal - minVal;
col = col/range;