function [retVals]=removeUnknownVals(vals, unknowns)

% Number of elements
n = length(vals);

% Find the elements with unknown values
unknownLocs = ismember(vals, unknowns);

% Initialise a double array for return values
retVals = zeros(n,1);

% Replace all unknown values with NaN
parfor i=1:n
   if unknownLocs(i) % If the element is unknown
      retVals(i) = NaN;
   else
      retVals(i) = str2double(cell2mat(vals(i)));
   end 
end