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

clear fullFile prefix extension rawData filename


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
mcid = 9;

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
    diffs = zeros(length(alpha),length(lambda));
    for l = 1:length(lambda)
        for a = 1:length(alpha)
            
            % Train the model on the training data
            [coeffs, fitInfo] = lasso(xTrain, yTrain, 'Lambda', lambda(l), 'Alpha', alpha(a));
            coeffsFull = [fitInfo.Intercept; coeffs];
            
            % Validate the model on validation data
            yPred = [ones(size(xVal, 1), 1), xVal] * coeffsFull;
            yPred = yPred .* (yPred > 0);
            diffs(a,l) = rmse(yVal, yPred);
        end
    end
    
    % Find the position of the first value with minimum difference
    % This prioritises high alpha values (closer to lasso)
    [~, minDiffLoc] = min(diffs(:));
    [minDiffRow, minDiffCol] = ind2sub(size(diffs), minDiffLoc);
    
    % Store the best alpha and lambda values
    bestLambda(i) = lambda(minDiffCol);
    bestAlpha(i) = alpha(minDiffRow);
    
    % Re-train the model with the best alpha and lambda
    [coeffs, fitInfo] = lasso(xTrain, yTrain, 'Lambda', bestLambda(i), 'Alpha', bestAlpha(i));
    coeffsFull = [fitInfo.Intercept; coeffs];
    
    % Predict the values using the newly trained model
    yPred = [ones(size(xTest, 1), 1), xTest] * coeffsFull;
    yPred = yPred .* (yPred > 0);
    
    % Asses the performance
    predPerf(i) = rmse(yTest, yPred);
    predSucc(i) = proportionSuccessful(yTest, yPred, mcid);
    
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

% Train the model on the training data
[coeffs, fitInfo] = lasso(contData, objSCORAD, 'Lambda', lambdaWeighted, 'Alpha', alphaWeighted);
coeffsFull = [fitInfo.Intercept; coeffs];

% Predict the results
yPred = [ones(size(contData, 1), 1), contData] * coeffsFull;
yPred = yPred .* (yPred > 0);

% Check the results against the originals
predPerfFinal = rmse(objSCORAD, yPred);
predSuccFinal = proportionSuccessful(objSCORAD, yPred, mcid);
residuals = objSCORAD - yPred;

clear mcid bl blFull fitInfo testProportion xTest xTrain yTrain coeffs

%% Save the results
save('post-ENET-variables.mat');
