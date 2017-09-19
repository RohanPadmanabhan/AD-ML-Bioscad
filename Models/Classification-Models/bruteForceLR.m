%% Brute force logistic regression on all combinations of n attributes

%% Clean slate
close all
clear
clc
addpath('../Utils/');
rng(100)

%% Load the data
load('logisticRegressionRawData.mat');
nInpAttr = 1;

%% List the combinations
[~, nAttr] = size(inpDataFull);
combinationsFull = combnk(1:nAttr, nInpAttr);

%% Preallocate space for results
[numComb, ~] = size(combinationsFull);
bfResults = repmat(createBFLRStruct(), numComb, 1 );

%% Perform logistic regression on all combinations

parfor i = 1 : numComb
    
    % Select the data for this combination
    combination = combinationsFull(i, :);
    inpData = inpDataFull(:, combination);
    varNames = varNamesFull(combination);
    
    % Try performing LR
    try
        % Perform logistic regression
        tempResults = logisticRegression(inpData, outData);
        
        % Add other variables to the results struct
        tempResults.varNames = varNames;
        tempResults.attributeNumbers = combination;
        tempResults.numAttributes = nInpAttr;
        tempResults = rmfield(tempResults, 'yPredFull');
        tempResults = rmfield(tempResults, 'yTestFull');
    catch
        % Fail value
        tempResults = createBFLRStruct();
    end
    
    % Assign the results in to the array
    bfResults(i) = tempResults;
    
end

%% Sort results

% Convert the results to a table and sort by accuracy
accuracyCol = 2;
bfResults = struct2table(bfResults);
bfResults = sortrows(bfResults, accuracyCol, 'Descend');


%% Save the results to file
outputPath = strcat('Results/bruteForce', num2str(nInpAttr), 'Attributes.mat');
save(outputPath, 'bfResults');

clear outputPath
