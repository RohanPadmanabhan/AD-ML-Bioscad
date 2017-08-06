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

% TODO: Automate this in a loop
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


%% Remove columns (attributes) with lack of values
dataStartColumn = 2;
dataEndColumn = 45;
minimumFillPercentage = 85;

i = dataStartColumn; % First column to be tested
while i <= dataEndColumn
   if isUnderfilled(table2array(preprocessedData(:,i)), minimumFillPercentage)
        preprocessedData(:,i) = [];
        dataEndColumn = dataEndColumn - 1; % Now one fewer column
   else
       i = i + 1; % Move to next column
   end
end

clear i

%% Remove rows (data points) with lack of values

i = 1; % First row to be tested
[n, ~] = size(preprocessedData); % Number of elements

% Repeat for each row
while i <= n
   if isUnderfilled(table2array(preprocessedData(i,dataStartColumn:dataEndColumn)), minimumFillPercentage)
        preprocessedData(i,:) = [];
        n = n - 1; % Now one fewer row
   else
       i = i + 1; % Move to next row
   end
end


clear n i dataStartColumn dataEndColumn minimumFillPercentage


%% Fill in data using KNN

% Save variables that should not be normalized
subSCORAD = preprocessedData.SubjectiveSCORAD;
objSCORAD = preprocessedData.ObjectiveSCORAD;
ageDays = preprocessedData.AgeAtVisit_inDays_;
skinType = preprocessedData.SkinType;

% Temporarily normalize data
preprocessedData.SubjectiveSCORAD = normalizeColumn(preprocessedData.SubjectiveSCORAD);
preprocessedData.ObjectiveSCORAD = normalizeColumn(preprocessedData.ObjectiveSCORAD);
preprocessedData.AgeAtVisit_inDays_ = normalizeColumn(preprocessedData.AgeAtVisit_inDays_);
preprocessedData.SkinType_ = normalizeColumn(preprocessedData.SkinType);

% Create a new table with only the numeric data
[~, p] = size(preprocessedData);
numOfStringCols = 1;
numericsOnly = preprocessedData(:, numOfStringCols+1:p);

% Use KNN on the numerics only table to fill in the blanks
[nNumerics, pNumberics] = size(numericsOnly);
for i=1:nNumerics
    for j=1:pNumberics
        if isnan(table2array(numericsOnly(i,j)))
            preprocessedData{i, j + numOfStringCols} = fillBlank(numericsOnly, i, j);
        end
    end
end


% Replace normalized data
preprocessedData.SubjectiveSCORAD = subSCORAD;
preprocessedData.ObjectiveSCORAD = objSCORAD;
preprocessedData.AgeAtVisit_inDays_ = ageDays;
preprocessedData.SkinType = skinType;

clear ageDays i j nNumerics numericsOnly numOfStringCols objSCORAD subSCORAD p pNumberics skinType



