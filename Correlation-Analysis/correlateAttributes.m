function [pmcc, spearman] = correlateAttributes(filename)

% Load the data
prefix = '../preprocessed-';
extension = '.mat';
fullFile = strcat(prefix, filename, extension);
load(fullFile);

% Remove the first 12 columns of the data
preprocessedData(:, 1:12) = [];

% Convert the table to an array
preprocessedData = table2array(preprocessedData);

% Find the correlation between columns
pmcc = corr(preprocessedData);
spearman = corr(preprocessedData, 'type', 'Spearman');

% Remove the duplicate data
pmcc = removeLowerLeftTriangle(pmcc);
spearman = removeLowerLeftTriangle(spearman);