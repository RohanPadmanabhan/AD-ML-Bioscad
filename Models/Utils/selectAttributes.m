function [inpData] = selectAttributes(inpDataFull, varNames)

%% Allows the user to select the variables they wish to use

% Remove the constant from the varNames
if isequal(varNames(1), {'Constant'})
    varNames(1) = [];
end

% Display variables to use
for i = 1:length(varNames)
    disp(strcat(num2str(i), ' -', varNames(i)));
end

% Preallocate space for table
[nPoints, ~] = size(inpDataFull);
nAttr = input('Enter the number of attributes to use: ');
inpData = zeros(nPoints, nAttr);

% Select the required attributes
for i = 1:nAttr
   attrNum = input('Select the next attribute: ');
   inpData(:,i) = inpDataFull(:, attrNum);
end