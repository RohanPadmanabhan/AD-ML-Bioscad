function [nTopAttrStruct] = createNTopAttrStruct()

% Create a struct with the same fields as the struct used for individual
% attribute logistic regression

nTopAttrStruct = createBasicLRStruct();
nTopAttrStruct.numTopAttributes = 0;