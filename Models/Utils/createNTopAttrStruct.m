function [nTopAttrStruct] = createNTopAttrStruct()

% Create a struct with the same fields as the struct used for individual
% attribute logistic regression

nTopAttrStruct = struct();
nTopAttrStruct.threshold = 0;
nTopAttrStruct.accuracy = 0;
nTopAttrStruct.evaluation = struct();
nTopAttrStruct.coefficients = 0;
nTopAttrStruct.yPredFull = 0;
nTopAttrStruct.yTestFull = 0;
nTopAttrStruct.numTopAttributes = 0;