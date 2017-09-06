function [eval] = binaryPerfEval(predUnThresh, actual, threshold)
% Input 1: Array of predicted binary classification data
% Input 2: Array of actual binary clasification data

%% Threshold the values
predThresh = thresholdData(predUnThresh, threshold);

%% Calculate the area under curve
[~, ~, ~, auc] = perfcurve(actual, predUnThresh,1);

%% Find the locations of the positive values
posLocs = (actual==1);

%% Find the actual positive and negative values
numTotal = length(actual);
numPositives = sum(actual);
numNegatives = numTotal - numPositives;

%% Find the confusion matrix values
truePos = sum(actual(posLocs) == predThresh(posLocs));
trueNeg = sum(actual(~posLocs) == predThresh(~posLocs));
falsePos = numNegatives-trueNeg;
falseNeg = numPositives-truePos;

%% Compute measures of accuracy
accuracy = (truePos+trueNeg)/numTotal;
sensitivity = truePos/numPositives; % TP rate
specificity = trueNeg/numNegatives; % TN rate
precision = truePos/(truePos+falsePos);

%% Compute the F-Score (avoiding divide by zero errors)
if truePos>0
    fScore = 2*((precision*sensitivity)/(precision + sensitivity));
else
    fScore = 0;
end

%% Compute the Matthews correlation coefficient (avoiding divide by zero errors)
if (truePos + falsePos == 0)||(trueNeg + falseNeg  == 0)
    mcc=0;
else
    numerator = truePos*trueNeg-falsePos*falseNeg;
    denominator = sqrt((truePos+falsePos)*(truePos+falseNeg)*(trueNeg+falsePos)*(trueNeg+falseNeg));
    mcc = numerator / denominator;
end


%% Compute the diagnostic odds ratio
dor = (truePos*trueNeg) / (falsePos*falseNeg);

%% Bundle the results in to a struct
eval = struct();
eval.accuracy = accuracy;
eval.sensitivity = sensitivity;
eval.specificity = specificity;
eval.precision = precision;
eval.fScore = fScore;
eval.mcc = mcc;
eval.dor = dor;
eval.auc = auc;
