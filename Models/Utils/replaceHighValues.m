function [pred] = replaceHighValues(pred, maxVal)

% Finds the places less than the maxVal
locs = pred < maxVal;

% Sets places greater than the maxVal to 0
pred = pred .* locs;

% Set the places greater than the maxVal to maxVal
pred = pred + (~locs * maxVal);
