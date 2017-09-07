function [indivAttrStruct] = createIndivAttrStruct()

% Create a struct with the same fields as the struct used for individual
% attribute logistic regression

indivAttrStruct = createBasicLRStruct();
indivAttrStruct.varNames = [];
indivAttrStruct.attributeName = '';
indivAttrStruct.attributeNumber = 0;