function [col] = logAndNormalizeColumn(col)

% Input 1 : The array of data
% Output : The logged and normalized data

% Log each value in the column
col = log(col);

% Normalize each value in the column
col = normalizeColumn(col);