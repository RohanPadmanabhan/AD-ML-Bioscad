function [basicLRStruct] = createBasicLRStruct()

% Create the basic struct used in logistic regression function

basicLRStruct = struct();
basicLRStruct.threshold = 0;
basicLRStruct.accuracy = 0;
basicLRStruct.evaluation = struct();
basicLRStruct.coefficients = 0;
basicLRStruct.yPredFull = 0;
basicLRStruct.yTestFull = 0;