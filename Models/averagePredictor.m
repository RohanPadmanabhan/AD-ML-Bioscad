%% Parallelised elastic net with cross-validation for BIOSCAD data



%% Clean slate
clear
clc
close all

addpath('Utils/');


%% Load the data and get the file names
inputFilename = input('Enter the input file path: ', 's');
load(inputFilename);

outputFileName = input('Enter the output file path: ', 's');

clear fullFile prefix extension rawData inputFilename

%% Extract the output data
[outData, mcid, scoradType] = extractOutputs(preprocessedData);

%% Average prediction

% Define constants
nCross = 100;
testProportion = 0.2;
[n, ~] = size(outData);

predPerf = zeros(nCross, 1);
predSucc = zeros(nCross, 1);

% Pre-allocate space for results
numTestCases = n * testProportion;
yPredFull = zeros(nCross, numTestCases);
yTestFull = zeros(nCross, numTestCases);

tic

parfor i = 1 : nCross
    
    % Split the data in to training and testing
    [~, ~, yTest, yTrain] = splitData(outData, outData, testProportion);
    
    % Find the average
    avg = mean(yTest);
    yPred = repmat(avg, numTestCases, 1);
    
    % Asses the performance
    predPerf(i) = rmse(yTest, yPred);
    predSucc(i) = proportionSuccessful(yTest, yPred, mcid);
    
    %Save the results
    yPredFull(i, :) = yPred;
    yTestFull(i, :) = yTest;
    
end

toc


clear i nCross valProportion alpha lambda

%% Analyse the results
[yTestFull, yPredFull, residuals, predPerfFinal, predSuccFinal] = analyseResults(yTestFull, yPredFull, mcid);

clear mcid

%% Save the results
save(outputFileName);

clear outputFileName

%% Draw a scatter graph of the test results
drawScatterPredictions(scoradType, yTestFull, yPredFull);