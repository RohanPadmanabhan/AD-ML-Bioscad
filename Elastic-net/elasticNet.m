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
[n, p] = size(preprocessedData);
contData = table2array(preprocessedData(:, contDataStartCol:p));

clear contDataStartCol p


%% Extract the testing set

% Randomnly select points
testProportion = 0.2;
[trainCVPoints, testPoints] = crossvalind('HoldOut', n, testProportion);

% Extract the data for final testing
inpTest = objSCORAD(testPoints,:);
outTest = contData(testPoints, :);






