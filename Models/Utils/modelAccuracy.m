function [acc] = modelAccuracy(pred, test, mcid)

% Finds the accuracy of each cross validation iteration
% Each iteration is a single row in the input matrices

[~, predsPerCross] = size(test);
diffsMean = pred - test;
diffsMean = (diffsMean < mcid) & (diffsMean > -mcid);
acc = sum(transpose(diffsMean)) / predsPerCross;