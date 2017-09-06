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
outputFileName = 'Results/indivAttrLR.mat';

clear fullFile prefix extension rawData inputFilename

%% Extract the output data
outData = preprocessedData.ObjectiveSCORAD;
outData = thresholdData(outData, eps);

%% Extract the input data

% Extract both the categorical and continuous data
[inpData, varNamesFull] = extractCombinedInpData(preprocessedData);

% Remove the constant from the list of variable names
varNamesFull(1) = [];

%% Pre-allocate space
[~, numAttr] = size(inpData);
singleResults = repmat(createIndivAttrStruct(), numAttr, 1 );

%% Perform logistic regression

for i = 1 : numAttr
    
    % Define the singular attribute for the input data
    singularInpData = inpData(:, i);
    
    % Define the attribute names
    attributeName = varNamesFull(i);
    varNames = ['Constant', attributeName];
    
    % Perform logistic regression
    tempResults = logisticRegression(singularInpData, outData);
    
    % Add the variable names
    tempResults.varNames = varNames;
    tempResults.attribute = attributeName;
    
    % Assign the results in to the array
    singleResults(i) = tempResults;
end

clearvars -except preprocessedData singleResults outputFileName

%% Sort the results by in to best values

% Convert the results to a table and sort by accuracy
accuracyCol = 2;
singleResults = struct2table(singleResults);
singleResults = sortrows(singleResults, accuracyCol, 'Descend');

% Reorder the attributes
singleResults = [singleResults(:,8), singleResults(:,1:7)];

clear accuracyCol;

%% Save the results
save(outputFileName, 'singleResults');
clear outputFileName