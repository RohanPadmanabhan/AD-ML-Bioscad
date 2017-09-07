%% Perform logistical regression using the full data set

%% Clean slate
clear
clc
close all

addpath('../Utils/');

%% Load the data and get the file names

%inputFilename = input('Enter the input file path: ', 's');
inputFilename = 'logisticRegressionRawData.mat';
load(inputFilename);

%outputFileName = input('Enter the output file path: ', 's');

clear fullFile prefix extension rawData inputFilename

%% Select the variables to use
[inpData, varNames] = selectAttributes(inpDataFull, varNamesFull);

%% Perform logistic regression
selectDataRes = logisticRegression(inpData, outData);
selectDataRes.varNames = varNames;

clearvars -except selectDataRes

%% Display preliminary results
display(selectDataRes.evaluation);