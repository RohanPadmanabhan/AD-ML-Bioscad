function [col] = logAndNormalizeColumn(col)

% Input 1 : The array of data
% Output : The logged and normalized data

% Log each value in the column
col = log(col);

% Replace inf with NaN
n = length(col);
parfor i=1:n
   if isinf(col(i))
      col(i) = NaN; 
   end
end

% Normalize each value in the column
col = normalizeColumn(col);