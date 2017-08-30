function [acc] = modelAccuracy(pred, test, mcid)

[~, predsPerCross] = size(test);
diffsMean = pred - test;
diffsMean = (diffsMean < mcid) & (diffsMean > -mcid);
acc = sum(transpose(diffsMean)) / predsPerCross;