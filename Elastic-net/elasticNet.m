%



%% Clean slate
clear
clc


%% Load the data
filename = 'combined-non-lesional';
prefix = '../preprocessed-';
extension = '.mat';
fullFile = strcat(prefix, filename, extension);
load(fullFile);

clear fullFile prefix extension rawData


%% Extract SCORAD and the continuous data

objSCORAD = preprocessedData.ObjectiveSCORAD;

contDataStartCol = 16;
[~, p] = size(preprocessedData);
contData = table2array(preprocessedData(:, contDataStartCol:p));

clear contDataStartCol p


%% Split off the test data set

% Randomnly select 20% of points for testing

clear testProportion trainCVPoints testPoints n


%% Elastic net

nCross = 100;
testProportion = 0.2;
valProportion = 0.25;

alpha = 0:0.1:1;
lambda = 10.^(-3:0.5:5);



for i = 1 : nCross
    
    % Split the data in to training and validation
    [xTest, xTrainVal, yTest, yTrainVal] = splitData(contData, objSCORAD, testProportion);
    [xVal, xTrain, yVal, yTrain] = splitData(xTrainVal, yTrainVal, valProportion);
    
    % Try every combination of lambda and alpha
    diffs = zeros(length(lambda), length(alpha));
    for l = 1:length(lambda);
        for a = 1:length(alpha);
            
            % Train the model on the training data
            [bl, fitInfo] = lasso(xTrain, yTrain, 'Lambda', lambda(l), 'Alpha', alpha(a));
            bl = [fitInfo.Intercept; bl];
            
            % Validate the model on validation data
            yPred = [ones(size(xVal, 1), 1), xVal] * bl;
            diffs(l,a) = rmse(yVal, yPred);
        end
    end
    
    % Find the position of the values with minimum difference
    [minRow, minCol] = find(diffs == max(diffs(:)));
    
    
    
    
    
    
    
    
    
end



