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
[~, p] = size(preprocessedData);
contData = table2array(preprocessedData(:, contDataStartCol:p));

clear contDataStartCol p


%% Split the data set

% Randomnly select 20% of points for testing
testProportion = 0.2;
[contDataTest, contData, objSCORADTest, objSCORAD] = splitData(contData, objSCORAD, testProportion);

clear testProportion trainCVPoints testPoints n


