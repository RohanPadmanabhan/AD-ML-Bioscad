% Clean slate
clear
clc
close all

% Add path to other functions
addpath('../Utils');

% How many file loads to try
maxFiles = 5;

% Folder to try
folderPath = 'Results/';

% Initialisation data
fullRes = createBFLRStruct();
successfulLoads = 0;

% For each possible start point and it's sub iterations
for i = 1:maxFiles
        
        % Create the filename
        fileName = strcat(folderPath, 'bruteForce', num2str(i), 'Attributes.mat');
        
        % Load the file
        try
            % Try loading the file
            load(fileName);
            successfulLoads = successfulLoads + 1;
        catch
            % Continue to the next loop without completion of this one
            continue;
        end
        
        % Add the new data to the existing data
        currResultsStr = table2struct(bfResults);
        fullRes = [fullRes; currResultsStr];
        
        % Remove variables
        clear bfResults
    
end

% Convert the struct to a table and sort it by cost
fullRes = struct2table(fullRes);
fullRes = sortrows(fullRes, 2, 'Descend');

% Remove last element (empty element)
[n, ~] = size(fullRes);
fullRes(n,:) = [];

% Save the results
outFileName = strcat('Results/bruteForce1to', num2str(successfulLoads), 'Attr.mat');
save(outFileName, 'fullRes');
clearvars -except fullRes