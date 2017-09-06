function [exampleStruct] = createIndivAttrStruct()

% Create a struct with the same fields as the struct used for individual
% attribute logistic regression

exampleStruct = struct();
exampleStruct.threshold = 0;
exampleStruct.accuracy = 0;
exampleStruct.evaluation = struct();
exampleStruct.coefficients = 0;
exampleStruct.yPredFull = 0;
exampleStruct.yTestFull = 0;
exampleStruct.varNames = [];
exampleStruct.attributeName = '';
exampleStruct.attributeNumber = 0;