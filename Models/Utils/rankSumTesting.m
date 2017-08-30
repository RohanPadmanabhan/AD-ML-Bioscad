%% Calculate tTests for each sample

% Clean slate
clear
close all
clc

%% Load the data and remove unnecesary variables

% Load the data file
filePath = '../Results/oSCORAD-logged.mat';
%filePath = input(' Enter the results filename: ', 's');
load(filePath);
clearvars -except yTestFull yPredFull

% Get mcid
mcid = 9;
%[~, mcid, ~, ~] = extractOutputs();

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

clear n nCross

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

%% Carry out the rank-sum test

[p, h] = ranksum(modelAcc, meanAcc);


%% Display the results

if (h)
    disp(['The values are different from the average. Statistical significance of: ', num2str(p)]);
else
    disp(['The values are the same as the average. Statistical significance of: ', num2str(p)]);
end