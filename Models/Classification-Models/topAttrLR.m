%% Use logistic regression on the top attributes

%% Clean slate
close all
clear
clc

%% Load the data
load('Results/indivAttrLR.mat');

%% Sort the input data so best attributes are first
bestAttrOrder = singleResults.attributeNumber;
inpDataFull = inpDataFull(:, bestAttrOrder);
varNamesFull = varNamesFull(bestAttrOrder);

%% Pre-allocate space
[~, numAttr] = size(inpDataFull);
nBestResults = repmat(createNTopAttrStruct(), numAttr, 1 );

%% Perform logistic regression

for i = 1 : numAttr
    
    % Turn off warnings
    warning('off', 'all');
    
    % Define the attributes to use for the input data
    inpData = inpDataFull(:, 1:i);
    
    % Perform logistic regression
    tempResults = logisticRegression(inpData, outData);
    
    % Add the number of attributes used
    tempResults.numTopAttributes = i;
    
    % Assign the results in to the array
    nBestResults(i) = tempResults;
end

clear i tempResults numAttr tempResults inpData

%% Sort the results by in to best values

% Convert the results to a table and sort by accuracy
accuracyCol = 2;
nBestResults = struct2table(nBestResults);
nBestResults = sortrows(nBestResults, accuracyCol, 'Descend');

% Reorder the attributes
nBestResults = [nBestResults(:,7), nBestResults(:,1:6)];

clear accuracyCol


%% Save the results to file
outputPath = 'Results/nTopAttrLR.mat';
save(outputPath, 'nBestResults', 'varNamesFull', 'bestAttrOrder');

clear outputPath

%% Draw a graph of the results
scatter(nBestResults.numTopAttributes, nBestResults.accuracy, 'x');
xlabel('Number of top performing attributes used')
ylabel('Accuracy')