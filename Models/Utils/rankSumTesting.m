%% Calculate tTests for each sample

% Clean slate
clear
close all
clc

%% Load the data and remove unnecesary variables

filePath = input(' Enter the results filename: ', 's');
load(filePath);
clearvars -except yTestFull yPredFull

clear filePath

%% Reshape the matric

% Number of CV iterations
nCross = 100;

% Total number of data points
n = length(yTestFull);

% Predictions per crossvalidation iteration
predsPerCross = n / nCross;

% Reshape the matrix to it's original form
yTestFull = reshape(yTestFull, [], predsPerCross);

clear n nCross

%% Calculate the means

% Calculate the mean for each row
meanVals = mean(transpose(yTestFull));

% Repeat the mean and reshape the matrix
meanVals = repmat(meanVals, predsPerCross, 1);
meanVals = reshape(meanVals, [], 1);

clear predsPerCross

meanVals = meanVals(1:20);
yPredFull = yPredFull(1:20);


%% Calculate the t-tests interval
[p, h] = ranksum(yPredFull, meanVals);

if (h)
    disp(['The values are different from the average. Statistical significance of: ', num2str(p)]);
else
    disp(['The values are the same as the average. Statistical significance of: ', num2str(p)]);
end
