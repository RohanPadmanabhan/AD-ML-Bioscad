%% General regression on a small data subset

%% Clean slate
close all
clear
clc

addpath('Utils/');

%% Load the preprocessed data
inpFilepath = input('Filepath for the input data: ', 's');
load(inpFilepath);

outFilepath = input('Filepath to save results: ', 's');

clear inpFilepath
%% Select the data

% Select the output data
[outVals, mcid, maxSCORAD, scoradType] = extractOutputs(preprocessedData);

% Select the input data
catData = extractCategoricalData(preprocessedData);
varNames = ['Constant', catData.Properties.VariableNames, 'IL_1a', 'IL_1_'];
inpVals = [table2array(catData), preprocessedData.IL_1a, preprocessedData.IL_1_];

clear catData

%% Train on multiple subsets

% Assign constants
[n, ~] = size(inpVals);
testProportion = 0.2;
nCross = 100;

% Pre-allocate space for arrays used in loop
predPerf = zeros(nCross, 1);
predSucc = zeros(nCross, 1);

% Pre-allocate space for results
numTestCases = n * testProportion;
yPredFull = zeros(nCross, numTestCases);
yTestFull = zeros(nCross, numTestCases);

parfor i = 1:nCross
    % Split the data
    [xTest, xTrain, yTest, yTrain] = splitData(inpVals, outVals, testProportion);
    
    % Train and predict using general regression
    [~, yPred] = genRegTrainPred(xTrain, yTrain, xTest, yTest, maxSCORAD);
    
    % Save the results
    yPredFull(i, :) = yPred;
    yTestFull(i, :) = yTest;
    
    % Test the performace
    predPerf(i) = rmse(yTest, yPred);
    predSucc(i) = proportionSuccessful(yTest, yPred, mcid);
end

clear n nCross numTestCases testProportion

%% Analyse the results
[yTestFull, yPredFull, ~, predPerfFinal, predSuccFinal] = analyseResults(yTestFull, yPredFull, mcid);

clear mcid


%% Train and test model on all the data
[coeffs, yPred] = genRegTrainPred(inpVals, outVals, inpVals, outVals, maxSCORAD);
residuals = outVals - yPred;


%% Save the data to file
save(outFilepath);

%% Draw a graphs of the test results
drawScatterPredictions(scoradType, yTestFull, yPredFull);
drawResidualGraph(outVals, residuals, scoradType);
drawCoefficientPlot(coeffs, varNames);

clear scoradType