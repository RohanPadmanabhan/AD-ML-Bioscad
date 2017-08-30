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

%% Calculate the t-tests interval

% Calculate the difference between the predictions and average
diffs = yPredFull - meanVals;

% Replace values within mcid with 0
diffs = diffs .* (diffs > mcid | diffs < -mcid);

% Carry out the t-test
[h, p] = ttest(diffs);


%% Display the results

if (h)
    disp(['The values are different from the average. Statistical significance of: ', num2str(p)]);
else
    disp(['The values are the same as the average. Statistical significance of: ', num2str(p)]);
end