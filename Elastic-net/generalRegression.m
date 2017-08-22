%% General regression on a small data subset

%% Clean slate
close all
clear
clc


%% Load the preprocessed data
%inpFilepath = input('Filepath for the data: ', 's');
inpFilepath = '../preprocessed-combined-non-lesional.mat';
load(inpFilepath);


%% Select the data 

% Select the output data
%useObjSCORAD = input('Use objective SCORAD? (1 or 0) ');
useObjSCORAD = 1;
if useObjSCORAD
    outVals = preprocessedData.ObjectiveSCORAD;
    scoradType = ' oSCORAD';
else
    outVals = preprocessedData.TotalSCORAD;
    scoradType = ' SCORAD';
end

% Select the input data
inpVals = [preprocessedData.IL_1a, preprocessedData.IL_1_];


%% Split the data into testing and training
testProportion = 0.2;
[xTest, xTrain, yTest, yTrain] = splitData(inpVals, outVals, testProportion);

%% Train the model
model = fitglm(xTrain, yTrain);

%% Predict results using model
coeffs = model.Coefficients.Estimate;
[n, ~] = size(yTest);
yPred = [ones(n,1), xTest] * coeffs;

%% Test the performace
predPerf = rmse(yTest, yPred);
mcid = 9;
predSucc = proportionSuccessful(yTest, yPred, mcid);

%% Draw a scatter graph of the test results
drawScatterPredictions(scoradType, yTest, yPred);