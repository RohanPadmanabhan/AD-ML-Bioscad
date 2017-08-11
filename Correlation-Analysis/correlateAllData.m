% Correlate all non-lesional data

% Clean slate
clear
clc


% Define filenames
onlyAD = 'AD-non-lesional';
allData = 'combined-non-lesional';

% Correlate the data
[ADPMCC, ADSpearman] = correlateAttributes(onlyAD);
[allPMCC, allSpearman] = correlateAttributes(allData);


% Garbage collection
clear onlyAD allData


