%% General regression on a small data subset

%% Clean slate
close all
clear
clc


%% Load the preprocessed data
%inpFilepath = input('Filepath for the data: ', 's');
inpFilepath = '../preprocessed-combined-non-lesional.mat';
load(inpFilepath);

clear inpFilepath
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

clear useObjSCORAD

%% Train on multiple subsets

% Assign constants
[n, ~] = size(inpVals);
testProportion = 0.2;
nCross = 100;
mcid = 9;

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
    
    % Train the model
    model = fitglm(xTrain, yTrain);
    
    % Predict results using model
    coeffs = model.Coefficients.Estimate;
    [n, ~] = size(yTest);
    yPred = [ones(n,1), xTest] * coeffs;
    
    % Save the results
    yPredFull(i, :) = yPred;
    yTestFull(i, :) = yTest;
    
    % Test the performace
    predPerf(i) = rmse(yTest, yPred);
    predSucc(i) = proportionSuccessful(yTest, yPred, mcid);
end

clear n nCross numTestCases testProportion
