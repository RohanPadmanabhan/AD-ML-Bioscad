%%Preprocessing the data

% Clean slate
clear;
clc;

%% Load the data
%filename = "AD-Non-Lesional.xlsx";
%rawData = readtable(filename);
load('rawADNonLesionalData.mat');


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
unknownLabels = ["not known", "unknown"];

% TODO: Automate this in a loop
% Remove unknown values and make column of doubles
preprocessedData.FLGCarrier = removeUnknownWords(preprocessedData.FLGCarrier, unknownLabels);
preprocessedData.FLGNumberOfMutations = removeUnknownWords(preprocessedData.FLGNumberOfMutations, unknownLabels);

clear unknownLabels

%% Remove outliers, log, and normalize columns with numeric data
numericalDataStartColumn = 16;
numericalDataEndColumn = 45;

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
minimumFillPercentage = 85;

% Remove underfilled columns
preprocessedData = removeUnderfilledColumns(preprocessedData, dataStartColumn, dataEndColumn, minimumFillPercentage);

% Remove underfilled rows
[~, dataEndColumn] = size(preprocessedData); % Number of elements
preprocessedData = removeUnderfilledRows(preprocessedData, dataStartColumn, dataEndColumn, minimumFillPercentage);


clear n i dataStartColumn dataEndColumn minimumFillPercentage


%% Fill in data using KNN
preprocessedData = fillTableBlanks(preprocessedData);


