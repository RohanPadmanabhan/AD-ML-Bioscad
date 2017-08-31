%% Test script to draw graphs

% Clean slate
clear
clc
close all

addpath('Utils/');

%% Load the data
inputFilepath = input('Data file path: ', 's');
load(inputFilepath);

%% Check if using objective or total scorad
[~, ~, ~, scoradType] = extractOutputs(preprocessedData);

%% Create boxplots to evaluate the model prediction
rmseTitle = 'RMSE for each cross validation iteration';
accTitle = 'Successful predictions for for each cross validation iteration';
drawBoxPlot(predPerf, predSucc, rmseTitle, accTitle);

%% Draw remaining graphs
drawScatterPredictions(scoradType, yTestFull, yPredFull);
drawResidualGraph(outVals, residuals, scoradType);
drawCoefficientPlot(coeffs, varNames);