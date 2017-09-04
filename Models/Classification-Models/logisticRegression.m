function [fullResults] = logisticRegression(inpData, outData)

addpath('../Utils/');

% Define constants
nCross = 100;
testProportion = 0.2;
valProportion = 0.25;

% Pre-allocate space for 2D results arrays
bestThresholds = zeros(nCross, 1);
predSucc = zeros(nCross, 1);

% Pre-allocate space for 3D results arrays
[n, ~] = size(outData);
numTestCases = n * testProportion;
yPredFull = zeros(nCross, numTestCases);
yTestFull = zeros(nCross, numTestCases);

tic


% Cross-validate
for i = 1 : nCross
    
    % Split the data in totesting, training, and validation
    [xTest, xTrainVal, yTest, yTrainVal] = splitData(inpData, outData, testProportion);
    [xVal, xTrain, yVal, yTrain] = splitData(xTrainVal, yTrainVal, valProportion);
    
    % Train the model and predict the validation data
    coeffs = glmfit(xTrain, yTrain,'binomial','link','probit');
    yPredVal = genRegPred(coeffs, xVal, 1);   
    
    % Find the best threshold value
    bestThresholds(i) = findBestThreshold(yPredVal, yVal);
    
    % Test the model
    yPredTest = genRegPred(coeffs, xTest, 1);
    predSucc(i) = categoricalPredictionAcc(yPredTest, yTest, bestThresholds(i));
    
    %Save the results
    yPredFull(i, :) = double(yPredTest > bestThresholds(i));
    yTestFull(i, :) = yTest;
    
end

toc

clear n nCross numTestCases testProportion valProportion

%% Re-train the matrix on full data set
[coeffs, ~] = genRegTrainPred(inpData, outData, inpData, 1);

%% Analyse the results

% Reshape the matrices and get the final success value
[yTestFull, yPredFull, ~, ~, predSuccFinal] = analyseResults(yTestFull, yPredFull, 0);

% Calculate the weighted mean
nonExtremeLocs = (bestThresholds > 0) & (bestThresholds < 1);
nonExtrThresh = bestThresholds(nonExtremeLocs);
nonExtrWeights = predSucc(nonExtremeLocs);
thresholdFinal = sum(nonExtrThresh .* nonExtrWeights) / sum(nonExtrWeights);

%% Save the results in a struct
fullResults = struct();
fullResults.threshold = thresholdFinal;
fullResults.successRate = predSuccFinal;
fullResults.coefficients = coeffs;
fullResults.yPredFull = yPredFull;
fullResults.yTestFull = yTestFull;



