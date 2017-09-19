%% Perform logistical regression using the full data set

%% Clean slate
clear
clc
close all

addpath('../Utils/');

%% Load the data and get the file names

% Load input data
inputFilename = 'logisticRegressionRawData.mat';
load(inputFilename);

outputFileName = 'Results/fullDataLR.mat';

clear fullFile prefix extension rawData inputFilename

%% Perform logistic regression
fullDataRes = logisticRegression(inpDataFull, outData);
fullDataRes.varNames = varNamesFull;

clear varNamesFull outData inpDataFull

%% Save the results
save(outputFileName, 'fullDataRes');
clear outputFileName preprocessedData