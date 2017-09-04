function [inpData, varNames] = extractCombinedInpData(preprocessedData)


%% Extract the continuous data
contData = extractContinuousData(preprocessedData);

%% Extract the categorical data
catData = extractCategoricalData(preprocessedData);

%% Combine the two to get the input data

% Combine the two types of data
inpData = [catData, contData];

% Add constant to front of variable names to match coefficients
varNames = ['Constant', inpData.Properties.VariableNames];

% Convert to an array
inpData = table2array(inpData);

clear catData contData