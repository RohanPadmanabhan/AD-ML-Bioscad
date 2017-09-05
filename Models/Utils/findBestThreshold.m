function [bestThreshold] = findBestThreshold(pred, actual)

% Define the values to test against
thresholdTestVals = 0:0.05:1;
n = length(thresholdTestVals);

% Preallocate space for the results matrix
thresholdAcc = zeros(1, n);

% Compute the accuracy for each threshold value
for i=1:n    
    [predThresh, actThresh] = thresholdData(pred, actual, thresholdTestVals(i));
    eval = binaryPerfEval(predThresh, actThresh);
    thresholdAcc(i) = eval.accuracy;
end

% Find the best values
[~, thresholdIndex] = max(thresholdAcc);
bestThreshold = thresholdTestVals(thresholdIndex);