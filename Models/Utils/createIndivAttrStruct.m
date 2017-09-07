function [indivAttrStruct] = createIndivAttrStruct()

% Create a struct with the same fields as the struct used for individual
% attribute logistic regression

indivAttrStruct = struct();
indivAttrStruct.threshold = 0;
indivAttrStruct.accuracy = 0;
indivAttrStruct.evaluation = struct();
indivAttrStruct.coefficients = 0;
indivAttrStruct.yPredFull = 0;
indivAttrStruct.yTestFull = 0;
indivAttrStruct.numTopAttributes = 0;