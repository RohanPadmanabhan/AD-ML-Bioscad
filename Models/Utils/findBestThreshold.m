function [bestThreshold] = findBestThreshold(pred, actual)

% Define the values to test against
thresholdTestVals = 0:0.05:1;
n = length(thresholdTestVals);

% Preallocate space for the results matrix
thresholdAcc = zeros(1, n);

% Compute the accuracy for each threshold value
for i=1:n    
    eval = binaryPerfEval(pred, actual, thresholdTestVals(i));
    thresholdAcc(i) = eval.accuracy;
end

% Find the best values
[~, thresholdIndex] = max(thresholdAcc);
bestThreshold = thresholdTestVals(thresholdIndex);