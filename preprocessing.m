%%Preprocessing the data

% Clean slate
clear;
clc;

%% Load the data
%filename = "AD-Non-Lesional.xlsx";
%rawData = readtable(filename);
load('raw-AD-non-lesional.mat');


%% Rename rawData
preprocessedData = rawData;

%% Remove unneeded columns
preprocessedData.IL_12P40 = [];
preprocessedData.Status = [];
preprocessedData.lesional_Non_lesional = [];
preprocessedData.FLGFailed_for = [];
preprocessedData.DateOfBirth = [];
preprocessedData.DateOfVisit = [];

%% Replace Male and Female with numerics
preprocessedData.Gender = makeNumericGender(preprocessedData.Gender, "M");

%% Remove unknown values
% List of different possible unknown values
unknownLabels = ["not known", "unknown", "not done"];


% Remove unknown values and make column of doubles
numDataStartCol = 2;
[~, numDataEndCol] = size(preprocessedData);
preprocessedData = removeUnknownsFromTable(preprocessedData, unknownLabels, numDataStartCol, numDataEndCol);

clear unknownLabels numDataEndCol numDataStartCol

%% Remove outliers, log, and normalize columns with numeric data
numericalDataStartColumn = 16;
[~, numericalDataEndColumn] = size(preprocessedData);

% Remove normal distribution outliers and log normalize each column between start and end
for i = numericalDataStartColumn:numericalDataEndColumn
    preprocessedData(:,i) = array2table(replaceZeros(table2array(preprocessedData(:,i))));
    preprocessedData(:,i) = array2table(logAndNormalizeColumn(table2array(preprocessedData(:,i))));
end

clear i numericalDataStartColumn numericalDataEndColumn stdDevLimit


%% Remove columns (attributes) & rows (data points) with lack of values

% Create variables defining position of data within table
dataStartColumn = 2; % First column with numeric data
[~, dataEndColumn] = size(preprocessedData);
minimumFillPercentage = 90;

% Remove underfilled rows
preprocessedData = removeUnderfilledRows(preprocessedData, dataStartColumn, dataEndColumn, minimumFillPercentage);

% Remove underfilled columns
[~, dataEndColumn] = size(preprocessedData); % Number of elements
preprocessedData = removeUnderfilledColumns(preprocessedData, dataStartColumn, dataEndColumn, minimumFillPercentage);


clear n i dataStartColumn dataEndColumn minimumFillPercentage


%% Fill in data using KNN
preprocessedData = fillTableBlanks(preprocessedData);

%% Save the results
save("preprocessed-AD-non-lesional.mat");
