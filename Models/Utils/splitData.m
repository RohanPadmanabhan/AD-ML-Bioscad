function [inpTest, inpTrain, outTest, outTrain] = splitData(inp, out, proportion)

% Splits input and output data in to training and testing data

% Input 1 : The input for regression
% Input 2 : The output of regression
% Input 3 : Proportion of data reserved for testing
% Outputs : The data points split up


% Randomnly select points for testing
[n, ~] = size(inp);
[trainPoints, testPoints] = crossvalind('HoldOut', n, proportion);

% Extract the data for final testing
outTest = out(testPoints, :);
inpTest = inp(testPoints, :);

% Extract the points that can be used in training and crossvalidation
outTrain = out(trainPoints, :);
inpTrain = inp(trainPoints, :);