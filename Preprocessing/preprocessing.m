%%Preprocessing the data

function [preprocessedData] = preprocessing(filename)

%% Load the data
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
numDataStartCol = 2;
[~, numDataEndCol] = size(preprocessedData);
preprocessedData = removeUnknownsFromTable(preprocessedData, unknownLabels, numDataStartCol, numDataEndCol);

clear unknownLabels numDataEndCol

%% Remove outliers, log, and normalize columns with numeric data

numericalDataStartColumn = 16;
[~, numericalDataEndColumn] = size(preprocessedData);

% Remove normal distribution outliers and log normalize each column between start and end
for i = numericalDataStartColumn:numericalDataEndColumn
    currColumn = table2array(preprocessedData(:,i));
    currColumn = replaceZeros(currColumn);
    currColumn = logAndNormalizeColumn(currColumn);
    preprocessedData(:,i) = array2table(currColumn);
end

clear i numericalDataEndColumn stdDevLimit currColumn


%% Remove columns (attributes) & rows (data points) with lack of values

% Create variables defining position of data within table
numDataStartCol = 2; % First column with numeric data
[~,numDataEndCol] = size(preprocessedData);
minimumFillPercentage = 80;

% Remove underfilled rows
preprocessedData = removeUnderfilledRows(preprocessedData, numDataStartCol, numDataEndCol, minimumFillPercentage);

% Remove underfilled columns
[~, numDataEndCol] = size(preprocessedData); % Number of elements
preprocessedData = removeUnderfilledColumns(preprocessedData, numDataStartCol, numDataEndCol, minimumFillPercentage);


clear n i numDataEndCol minimumFillPercentage


%% Fill in data using KNN

% Select only the continuous data
[~,numDataEndCol] = size(preprocessedData);
continuousData = table2array(preprocessedData(:, numDataStartCol:numDataEndCol));

% Replace NaNs using 3 nearest neighbours
k = 3;
continuousData = transpose(knnimpute(transpose(continuousData), k));

% Insert the new data back into the table
preprocessedData(:, 2:numDataEndCol) = array2table(continuousData);


clear numDataEndCol k continuousData numDataStartCol


%% Split the skintype catergorical data
preprocessedData = splitSkinType(preprocessedData);

%% Save the results

% Save location
prefix = '../preprocessed-';
extension = '.mat';
fullFile = strcat(prefix, filename, extension);

% Save only necessary variables
save(fullFile, '*Data');

clear extension filename fullFile prefix