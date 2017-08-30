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

boxPredEval = figure('name', 'Prediction Evaluation');
set(gcf, 'Position', [100, 800, 1000, 400])

% Create a boxplot of the RMSE
subplot(1,2,1);
boxplot(predPerf);
title('RMSE for best alpha and lambda values');
grid on;
ylabel('RMSE');

% Create a boxplot of the prediction success
subplot(1,2,2);
boxplot(predSucc);
title('Successful predictions for best alpha and lambda values');
grid on;
ylabel('Proportion successful predictions');


%% Create graph to show prediction correlation
drawScatterPredictions(scoradType, yTestFull, yPredFull);


%% Create graphs to show alpha and lambda performance
alpLamPerf = figure('name', 'Alpha and lambda performance');
set(gcf, 'Position', [100, 100, 1600, 400])

% Draw a 3D graphs with all 3 variables
subplot(1,3,1);
scatter3(bestAlpha, bestLambda, predPerf, 'x');
title('Alpha vs Lambda vs RMSE');
xlabel('Alpha');
ylabel('Lambda');
zlabel('RMSE');
axis square

% Draw a 2D alpha vs RMSE plot
subplot(1,3,2);
scatter(bestAlpha, predPerf, 'x');
title('Alpha vs RMSE');
xlabel('Alpha');
ylabel('RMSE');
axis square

% Draw a 2D alpha vs RMSE plot
subplot(1,3,3);
scatter(bestLambda, predPerf, 'x');
axis square

% Labels
title('Lambda vs RMSE');
xlabel('Lambda');
ylabel('RMSE');

%% Create graph to show residuals

% Plot the graph
residualVsActual = figure('name', strcat('Residual vs Actual ', scoradType));
scatter(outData, residuals, 'x');

% Labels
title(strcat('Residual vs Actual ', scoradType));
xlabel(strcat('Actual ', scoradType));
ylabel(strcat('Residual ', scoradType));


%% Draw coefficients plot

% Initialise the figure
coeffsBar = figure('name', 'Coefficient values');
set(gcf, 'Position', [100, 800, 1200, 400])

% Find the locations of non-zero coefficients
nonZeroLocs = coeffsFull ~= 0;
coeffs = coeffsFull(nonZeroLocs);
varNames = varNames(nonZeroLocs);

% Remove the constant coefficients
varNames(1) = [];
coeffs(1) = [];

% Plot the bar graph
varNames = categorical(varNames);
bar(varNames, coeffs);

% Labels
title('Coefficient values');
xlabel('Attribute');
ylabel('Coeffient value');
grid on
