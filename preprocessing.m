%%Preprocessing the data

% Clean slate
clear;
clc;

%% Load the data
%filename = "AD-Non-Lesional.xlsx";
%rawData = readtable(filename);
load('rawADNonLesionalData.mat');

%% Remove unneeded columns
rawData.IL_12P40 = [];
rawData.Status = [];
rawData.lesional_Non_lesional = [];

%% Replace Male and Female with numerics
rawData.Gender = makeNumericGender(rawData.Gender, "M");

%% Remove unknown values
unknownLabels = ["not known", "unknown"];
rawData.FLGCarrier = removeUnknownWords(rawData.FLGCarrier, unknownLabels);
rawData.FLGNumberOfMutations = removeUnknownWords(rawData.FLGNumberOfMutations, unknownLabels);

%% Remove outliers, log, and normalize columns with numeric data
numericalDataStartColumn = 19;
numericalDataEndColumn = 48;
stdDevLimit = 5;

for i = numericalDataStartColumn:numericalDataEndColumn
    rawData(:,i) = array2table(removeNormalDistOutliers(table2array(rawData(:,i)), stdDevLimit));
    rawData(:,i) = array2table(logAndNormalizeColumn(table2array(rawData(:,i))));
end





