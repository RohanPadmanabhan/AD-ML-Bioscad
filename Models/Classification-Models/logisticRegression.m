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

% Cross-validate
for i = 1 : nCross
    
    % Split the data in totesting, training, and validation
    [xTest, xTrainVal, yTest, yTrainVal] = splitData(inpData, outData, testProportion);
    [xVal, xTrain, yVal, yTrain] = splitData(xTrainVal, yTrainVal, valProportion);
    
    % Suppress warnings from glmfit
    warning('off','all');
    
    % Train the model and predict the validation data
    logitCoeffs = glmfit(xTrain, yTrain,'binomial', 'logit');
    yPredVal = glmval(logitCoeffs, xVal, 'logit');
    
    % Find the best threshold value
    bestThresholds(i) = findBestThreshold(yPredVal, yVal);
    
    % Test the model
    yPredTest = glmval(logitCoeffs, xTest, 'logit');
    eval = binaryPerfEval(yPredTest, yTest, bestThresholds(i));
    predSucc(i) = eval.accuracy;
    
    %Save the results
    yPredTest = thresholdData(yPredTest, bestThresholds(i));
    yPredFull(i, :) = yPredTest;
    yTestFull(i, :) = yTest;
    
end

clear n nCross numTestCases testProportion valProportion

%% Re-train the matrix on full data set
logitCoeffs = glmfit(inpData, outData,'binomial', 'logit');

%% Analyse the results

% Reshape the matrices and get the final success value
[yTestFull, yPredFull, ~, ~, predSuccFinal] = analyseResults(yTestFull, yPredFull, 0);

% Calculate the weighted mean
thresholdFinal = sum(bestThresholds .* predSucc) / sum(predSucc);

% Full evaluation
eval = binaryPerfEval(yPredFull, yTestFull, thresholdFinal);
eval = rmfield(eval, 'auc');

%% Save the results in a struct
fullResults = struct();
fullResults.threshold = thresholdFinal;
fullResults.accuracy = predSuccFinal;
fullResults.evaluation = eval;
fullResults.coefficients = logitCoeffs;
fullResults.yPredFull = yPredFull;
fullResults.yTestFull = yTestFull;



