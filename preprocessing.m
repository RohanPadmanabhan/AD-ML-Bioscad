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
unknownLabels = ["not known", "unknown"];
preprocessedData.FLGCarrier = removeUnknownWords(preprocessedData.FLGCarrier, unknownLabels);
preprocessedData.FLGNumberOfMutations = removeUnknownWords(preprocessedData.FLGNumberOfMutations, unknownLabels);

clear unknownLabels

%% Remove outliers, log, and normalize columns with numeric data
numericalDataStartColumn = 16;
numericalDataEndColumn = 45;
stdDevLimit = 1.96;

% Remove normal distribution outliers and log normalize each column between start and end
for i = numericalDataStartColumn:numericalDataEndColumn
    preprocessedData(:,i) = array2table(removeNormalDistOutliers(table2array(preprocessedData(:,i)), stdDevLimit));
    preprocessedData(:,i) = array2table(logAndNormalizeColumn(table2array(preprocessedData(:,i))));
end

clear i numericalDataStartColumn numericalDataEndColumn stdDevLimit


%% Remove columns with lack of values
dataStartColumn = 2;
dataEndColumn = 45;
minimumFillPercentage = 85;

i = dataStartColumn; % First column to be tested
while i <= dataEndColumn
   if isUnderfilled(table2array(preprocessedData(:,i)), minimumFillPercentage)
        preprocessedData(:,i) = [];
        dataEndColumn = dataEndColumn - 1; %Now one fewer column
   else
       i = i + 1; % Move to next column
   end
end

clear dataStartColumn dataEndColumn i minimumFillPercentage


