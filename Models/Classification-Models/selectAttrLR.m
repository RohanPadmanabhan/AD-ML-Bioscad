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

clear fullFile prefix extension rawData inputFilename

%% Extract the output data
outData = preprocessedData.ObjectiveSCORAD;
outData = double(outData > 0);

%% Extract the input data
[inpDataFull, varNamesFull] = extractCombinedInpData(preprocessedData);

%% Select the variables to use
[inpData, varNames] = selectAttributes(inpDataFull, varNamesFull);

%% Perform logistic regression
selectDataRes = logisticRegression(inpData, outData);
selectDataRes.varNames = varNames;

clearvars -except selectDataRes

%% Display preliminary results
display(selectDataRes.evaluation);