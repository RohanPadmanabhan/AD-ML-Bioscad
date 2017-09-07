function [bFLRStruct] = createBFLRStruct()

% Create a struct with the same fields as the struct used for individual
% attribute logistic regression

bFLRStruct = createBasicLRStruct();
bFLRStruct.varNames = [];
bFLRStruct.attributeNumbers = [];
bFLRStruct.numAttributes = 0;