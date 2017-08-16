%



%% Clean slate
clear
clc


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
[n, p] = size(preprocessedData);
contData = table2array(preprocessedData(:, contDataStartCol:p));

clear contDataStartCol p


%% Split the data set

% Randomnly select 20% of points for testing
testProportion = 0.2;
[trainValPoints, testPoints] = crossvalind('HoldOut', n, testProportion);

% Extract the data for final testing
objSCORADTest = objSCORAD(testPoints, :);
contDataTest = contData(testPoints, :);

% Extract the points that can be used in training and crossvalidation
objSCORAD = objSCORAD(trainValPoints, :);
contData = contData(trainValPoints, :);

clear testProportion trainCVPoints testPoints n


