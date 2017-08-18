%% Parallelised elastic net with cross-validation for BIOSCAD data



%% Clean slate
clear
clc
close all


%% Load the data
filename = 'combined-non-lesional';
prefix = '../preprocessed-';
extension = '.mat';
fullFile = strcat(prefix, filename, extension);
load(fullFile);

clear fullFile prefix extension rawData


%% Extract SCORAD and the continuous data

objSCORAD = preprocessedData.ObjectiveSCORAD;

contDataStartCol = 16;
[~, p] = size(preprocessedData);
contData = table2array(preprocessedData(:, contDataStartCol:p));

clear contDataStartCol p


%% Elastic net

% Define constants
nCross = 100;
testProportion = 0.2;
valProportion = 0.25;
allowedSCORADDiff = 2;

% Define alpha and lambda ranges
alpha = 0.1:0.05:1;
lambda = 10.^(-3:0.1:5);


% Pre-allocate space
bestLambda = zeros(nCross, 1);
bestAlpha = zeros(nCross, 1);
predPerf = zeros(nCross, 1);
predSucc = zeros(nCross, 1);

tic

parfor i = 1 : nCross
    
    % Split the data in to training and validation
    [xTest, xTrainVal, yTest, yTrainVal] = splitData(contData, objSCORAD, testProportion);
    [xVal, xTrain, yVal, yTrain] = splitData(xTrainVal, yTrainVal, valProportion);
    
    % Try every combination of lambda and alpha
    diffs = zeros(length(lambda), length(alpha));
    for l = 1:length(lambda)
        for a = 1:length(alpha)
            
            % Train the model on the training data
            [bl, fitInfo] = lasso(xTrain, yTrain, 'Lambda', lambda(l), 'Alpha', alpha(a));
            blFull = [fitInfo.Intercept; bl];
            
            % Validate the model on validation data
            yPred = [ones(size(xVal, 1), 1), xVal] * blFull;
            diffs(l,a) = rmse(yVal, yPred);
        end
    end
    
    % Find the position of the first value with minimum difference
    % This prioritises low alpha values (closer to ridge)
    [minDiff, minDiffLoc] = min(diffs(:));
    [minDiffRow, minDiffCol] = ind2sub(size(diffs), minDiffLoc);
    
    % Store the best alpha and lambda values
    bestLambda(i) = lambda(minDiffRow);
    bestAlpha(i) = alpha(minDiffCol);
    
    % Re-train the model with the best alpha and lambda
    [bl, fitInfo] = lasso(xTrain, yTrain, 'Lambda', bestLambda(i), 'Alpha', bestAlpha(i));
    blFull = [fitInfo.Intercept; bl];
    
    % Predict the values using the newly trained model
    yPred = [ones(size(xVal, 1), 1), xVal] * blFull;
    
    % Asses the performance
    predPerf(i) = rmse(yVal, yPred);
    predSucc(i) = proportionSuccessful(yTest, yPred, allowedSCORADDiff);
    
end

toc


clear i nCross valProportion


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

% Split the training and testing data
[xTest, xTrain, yTest, yTrain] = splitData(contData, objSCORAD, testProportion);

% Train the model on the training data
[bl, fitInfo] = lasso(xTrain, yTrain, 'Lambda', lambdaWeighted, 'Alpha', alphaWeighted);
blFull = [fitInfo.Intercept; bl];

% Predict the results and test
yPred = [ones(size(xTest, 1), 1), xTest] * blFull;
predPerfFinal = rmse(yTest, yPred);
predSuccFinal = proportionSuccessful(yTest, yPred, allowedSCORADDiff);

clear allowedSCORADDiff bl blFull fitInfo testProportion xTest xTrain yTrain 

%% Save the results
save('post-ENET-variables.mat');

