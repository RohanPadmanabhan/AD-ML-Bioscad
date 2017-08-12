%%Preprocessing the data

% Clean slate
clear;
clc;

%% Load the data
filename = 'AD-lesional';
prefix = '../raw-';
extension = '.mat';
fullFile = strcat(prefix, filename, extension);
load(fullFile);

clear fullFile prefix extension

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
disp(preprocessedData);
numDataStartCol = 2; %input('In which column does the numeric data start? ');
[~, numDataEndCol] = size(preprocessedData);
preprocessedData = removeUnknownsFromTable(preprocessedData, unknownLabels, numDataStartCol, numDataEndCol);

clear unknownLabels numDataEndCol

%% Remove outliers, log, and normalize columns with numeric data
disp(preprocessedData);
numericalDataStartColumn = 16; %input('In which column does the continuous data start? ');
[~, numericalDataEndColumn] = size(preprocessedData);

% Remove normal distribution outliers and log normalize each column between start and end
for i = numericalDataStartColumn:numericalDataEndColumn
    preprocessedData(:,i) = array2table(replaceZeros(table2array(preprocessedData(:,i))));
    preprocessedData(:,i) = array2table(logAndNormalizeColumn(table2array(preprocessedData(:,i))));
end

clear i numericalDataStartColumn numericalDataEndColumn stdDevLimit


%% Remove columns (attributes) & rows (data points) with lack of values

% Create variables defining position of data within table
numDataStartCol = 2; % First column with numeric data
[~,numDataEndCol] = size(preprocessedData);
minimumFillPercentage = 90;

% Remove underfilled rows
preprocessedData = removeUnderfilledRows(preprocessedData, numDataStartCol, numDataEndCol, minimumFillPercentage);

% Remove underfilled columns
[~, numDataEndCol] = size(preprocessedData); % Number of elements
preprocessedData = removeUnderfilledColumns(preprocessedData, numDataStartCol, numDataEndCol, minimumFillPercentage);


clear n i numDataStartCol numDataEndCol minimumFillPercentage


%% Fill in data using KNN
preprocessedData = fillTableBlanks(preprocessedData);

%% Save the results


prefix = '../preprocessed-';
extension = '.mat';
fullFile = strcat(prefix, filename, extension);
save(fullFile);

clear extension filename fullFile prefix