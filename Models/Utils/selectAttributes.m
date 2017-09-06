function [selectData, selectNames] = selectAttributes(inpDataFull, varNames)

% Allows the user to select the variables they wish to use

% Remove the constant from the varNames
if isequal(varNames(1), {'Constant'})
    varNames(1) = [];
end

% Check the inputs
nNames = length(varNames);
[nPoints, nAttr] = size(inpDataFull);
assert(nAttr == nNames, 'Size of variable names and variable matrix does not match.');

% Display variables to use
for i = 1:length(varNames)
    disp(strcat(num2str(i), ' -', varNames(i)));
end

% Preallocate space for table
nAttr = input('Enter the number of attributes to use: ');
selectData = zeros(nPoints, nAttr);
selectNames = cell(1, nAttr);

% Select the required attributes
for i = 1:nAttr
   attrNum = input('Select the next attribute: ');
   selectData(:,i) = inpDataFull(:, attrNum);
   selectNames(i) = varNames(attrNum);
end