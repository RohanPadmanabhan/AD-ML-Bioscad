%% Perform logistical regression using the individual attributes

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
outputFileName = 'Results/indivAttrLR.mat';

clear fullFile prefix extension rawData inputFilename

%% Pre-allocate space
[~, numAttr] = size(inpDataFull);
singleResults = repmat(createIndivAttrStruct(), numAttr, 1 );

%% Perform logistic regression

parfor i = 1 : numAttr
    
    % Define the singular attribute for the input data
    singularInpData = inpDataFull(:, i);
    
    % Define the attribute names
    attributeName = varNamesFull(i);
    varNames = ['Constant', attributeName];
    
    % Perform logistic regression
    tempResults = logisticRegression(singularInpData, outData);
    
    % Add the variable names
    tempResults.varNames = varNames;
    tempResults.attributeName = attributeName;
    tempResults.attributeNumber = i;
    
    % Assign the results in to the array
    singleResults(i) = tempResults;
end

clear i tempResults numAttr singularInpData tempResults attributeName varNames

%% Sort the results by in to best values

% Convert the results to a table and sort by accuracy
accuracyCol = 2;
singleResults = struct2table(singleResults);
singleResults = sortrows(singleResults, accuracyCol, 'Descend');

% Reorder the attributes
singleResults = [singleResults(:,8:9), singleResults(:,1:7)];

clear accuracyCol;

%% Save the results
save(outputFileName, 'singleResults', 'inpDataFull', 'outData', 'varNamesFull');
clear outputFileName