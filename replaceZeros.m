function [col] = replaceZeros(col)

% Find the minimum value and reduce it by one order of magnitude
minVal = min(col);
minVal = minVal / 10;

parfor i=1:length(col)
    if (col(i) == 0)
       col(i) =  minVal;
    end
end
