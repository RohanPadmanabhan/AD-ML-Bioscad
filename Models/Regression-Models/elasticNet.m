%% Parallelised elastic net with cross-validation for BIOSCAD data



%% Clean slate
clear
clc
close all

addpath('../Utils/');

%% Load the data and get the file names
inputFilename = input('Enter the input file path: ', 's');
load(inputFilename);

outputFileName = input('Enter the output file path: ', 's');

clear fullFile prefix extension rawData inputFilename

%% Extract the output data
[outData, mcid, maxSCORAD, ~] = extractOutputs(preprocessedData);

%% Extract the input data
[inpData, varNames] = extractCombinedInpData(preprocessedData);

%% Elastic net

% Define constants
nCross = 100;
testProportion = 0.2;
valProportion = 0.25;
[n, ~] = size(outData);

% Define alpha and lambda ranges
alpha = 0.05:0.05:1;
lambda = 10.^(-6:0.1:0.6);

% Pre-allocate space for arrays used in loop
bestLambda = zeros(nCross, 1);
bestAlpha = zeros(nCross, 1);
predPerf = zeros(nCross, 1);
predSucc = zeros(nCross, 1);

% Pre-allocate space for results
numTestCases = n * testProportion;
yPredFull = zeros(nCross, numTestCases);
yTestFull = zeros(nCross, numTestCases);

tic

parfor i = 1 : nCross
    
    % Split the data in totesting, training, and validation
    [xTest, xTrainVal, yTest, yTrainVal] = splitData(inpData, outData, testProportion);
    [xVal, xTrain, yVal, yTrain] = splitData(xTrainVal, yTrainVal, valProportion);
    
    % Try every combination of lambda and alpha
    diffs = zeros(length(lambda), length(alpha));
    for l = 1:length(lambda)
        for a = 1:length(alpha)
            
            % Train the model on the training data
            [coeffs, fitInfo] = lasso(xTrain, yTrain, 'Lambda', lambda(l), 'Alpha', alpha(a));
            coeffsFull = [fitInfo.Intercept; coeffs];
            
            % Predict the values
            yPred = elasticNetCoeffsPred(coeffsFull, xVal, maxSCORAD);
            
            % Validate the model using validation set
            diffs(l,a) = rmse(yVal, yPred);
        end
    end
    
    % Find the position of the first value with minimum difference
    % This prioritises high alpha values (closer to lasso)
    [~, minDiffLoc] = min(diffs(:));
    [minDiffRow, minDiffCol] = ind2sub(size(diffs), minDiffLoc);
    
    % Store the best alpha and lambda values
    bestLambda(i) = lambda(minDiffRow);
    bestAlpha(i) = alpha(minDiffCol);
    
    % Re-train the model with the best alpha and lambda
    [coeffs, fitInfo] = lasso(xTrain, yTrain, 'Lambda', bestLambda(i), 'Alpha', bestAlpha(i));
    coeffsFull = [fitInfo.Intercept; coeffs];
    
    % Predict the values using the newly trained model
    yPred = elasticNetCoeffsPred(coeffsFull, xTest, maxSCORAD);   
    
    % Asses the performance
    predPerf(i) = rmse(yTest, yPred);
    predSucc(i) = proportionSuccessful(yTest, yPred, mcid);
    
    %Save the results
    yPredFull(i, :) = yPred;
    yTestFull(i, :) = yTest;
    
end

toc

clear i nCross valProportion alpha lambda n testProportion valProportion numTestCases

%% Analyse the results
[yTestFull, yPredFull, ~, predPerfFinal, predSuccFinal] = analyseResults(yTestFull, yPredFull, mcid);

clear mcid

%% Find the mean alpha and lambda

% Find the unweighted mean
alphaUnweighted = mean(bestAlpha);
lambdaUnweighted = mean(bestLambda);

% Find the weighted mean
weights = predPerf.^-1;
sumWeights = sum(weights);
alphaWeighted = sum(bestAlpha .* weights) / sumWeights;
lambdaWeighted = sum(bestLambda .* weights) / sumWeights;

clear sumWeights weights


%% Re-train the model with the final values of alpha and lambda

% Train the model on the training data
[coeffs, fitInfo] = lasso(inpData, outData, 'Lambda', lambdaWeighted, 'Alpha', alphaWeighted);
coeffsFull = [fitInfo.Intercept; coeffs];

% Predict the values using the newly trained model
yPred = elasticNetCoeffsPred(coeffsFull, inpData, maxSCORAD);
residuals = outData - yPred;

clear mcid bl blFull fitInfo xTest xTrain yTrain coeffs maxSCORAD yPred


%% Save the results
save(outputFileName);

clear outputFileName