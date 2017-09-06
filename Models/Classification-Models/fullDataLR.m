%% Perform logistical regression using the full data set

%% Clean slate
clear
clc
close all

addpath('../Utils/');

%% Load the data and get the file names

%inputFilename = input('Enter the input file path: ', 's');
inputFilename = '../../preprocessed-combined-non-lesional.mat';
load(inputFilename);

%outputFileName = input('Enter the output file path: ', 's');
outputFileName = 'Results/fullDataLR.mat';

clear fullFile prefix extension rawData inputFilename

%% Extract the output data
outData = preprocessedData.ObjectiveSCORAD;
outData = thresholdData(outData, eps);

%% Extract the input data
[inpData, varNames] = extractCombinedInpData(preprocessedData);

%% Perform logistic regression
fullDataRes = logisticRegression(inpData, outData);
fullDataRes.varNames = varNames;

clear varNames outData inpData

%% Save the results
save(outputFileName, 'fullDataRes');