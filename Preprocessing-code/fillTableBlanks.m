function [preprocessedData] = fillTableBlanks(preprocessedData)

% Save variables that should not be normalized
subSCORAD = preprocessedData.SubjectiveSCORAD;
objSCORAD = preprocessedData.ObjectiveSCORAD;
ageDays = preprocessedData.AgeAtVisit_inDays_;
skinType = preprocessedData.SkinType;

% Temporarily normalize data
preprocessedData.SubjectiveSCORAD = normalizeColumn(preprocessedData.SubjectiveSCORAD);
preprocessedData.ObjectiveSCORAD = normalizeColumn(preprocessedData.ObjectiveSCORAD);
preprocessedData.AgeAtVisit_inDays_ = normalizeColumn(preprocessedData.AgeAtVisit_inDays_);
preprocessedData.SkinType = normalizeColumn(preprocessedData.SkinType);

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