%% Perform logistical regression using the individual attributes

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
outData = thresholdData(outData, eps);

%% Define constants and pre-allocate space

% Define start and end values for continuous data
contDataStart = 19;
[~, contDataEnd] = size(preprocessedData);
numAttr = contDataEnd - contDataStart + 1;

% Preallocate space for structs
singleResults = repmat(createIndivAttrStruct(), numAttr, 1 );

%% Perform logistic regression

for i = contDataStart : contDataEnd
    
    % Define the singular attribute for the input data
    inpData = table2array(preprocessedData(:, i));
    
    % Define the attribute names
    attributeName = preprocessedData.Properties.VariableNames(i);
    varNames = ['Constant', attributeName];
    
    % Perform logistic regression
    tempResults = logisticRegression(inpData, outData);
    
    % Add the variable names
    tempResults.varNames = varNames;
    tempResults.attribute = attributeName;
    
    % Assign the results in to the array
    index = i - contDataStart + 1;
    singleResults(index) = tempResults;
end

clearvars -except preprocessedData singleResults

%% Sort the results by in to best values

% Convert the results to a table and sort by accuracy
accuracyCol = 2;
singleResults = struct2table(singleResults);
singleResults = sortrows(singleResults, accuracyCol, 'Descend');

% Reorder the attributes
singleResults = [singleResults(:,8), singleResults(:,1:7)];

clear accuracyCol;