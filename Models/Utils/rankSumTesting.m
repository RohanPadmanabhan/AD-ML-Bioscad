%% Calculate tTests for each sample

% Clean slate
clear
close all
clc

%% Load the data and remove unnecesary variables

% Load the data file
filePath = input(' Enter the results filename: ', 's');
load(filePath);
clearvars -except yTestFull yPredFull

% Get mcid
[~, mcid, ~, ~] = extractOutputs();

clear filePath

%% Reshape the matric

% Number of CV iterations
nCross = 100;

% Total number of data points
n = length(yTestFull);

% Predictions per crossvalidation iteration
predsPerCross = n / nCross;

% Reshape the matrices to their original form
yTestFull = reshape(yTestFull, [], predsPerCross);
yPredFull = reshape(yPredFull, [], predsPerCross);

clear n

%% Calculate the means

% Calculate the mean for each row
meanVals = mean(transpose(yTestFull));

% Repeat the mean and reshape the matrix
meanVals = transpose(repmat(meanVals, predsPerCross, 1));

clear predsPerCross

%% Calculate the accuracy of each model

% Calculate the accuracy of each cross validation iteration
meanAcc = modelAccuracy(meanVals, yTestFull, mcid);
modelAcc = modelAccuracy(yPredFull, yTestFull, mcid);


%% Calculate the RMSE

% Preallocate space for results
modelRMSE = zeros(1,100);
meanRMSE = zeros(1,100);

% Calculate the RMSE for each cross validation
parfor i=1:nCross
    modelRMSE(i) = rmse(yTestFull(i,:), yPredFull(i,:));
    meanRMSE(i) = rmse(yTestFull(i,:), meanVals(i,:));   
end

clear nCross
%% Carry out the significance tests

% Test the model accuracy is greater than the mean accuracy
[pAcc, hAcc] = ranksum(modelAcc, meanAcc, 'tail', 'right');

% Test that the model RMSE is less than the mean RMSE
[hRMSE, pRMSE] = ttest(modelRMSE, meanRMSE, 'tail', 'left');

%% Display the results
displaySignificance(hAcc, pAcc, 'accuracy');
displaySignificance(hRMSE, pRMSE, 'RMSE');