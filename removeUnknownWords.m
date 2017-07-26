function [retVals]=removeUnknownWords(vals, unknowns)
% Removes unknown values from an array and replaces them with NaN
% Input 1: The values including any unknowns
% Input 2: Array of unknown values to be checked against
% Output : Double array of values


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
      retVals(i) = str2double(vals(i));
   end 
end