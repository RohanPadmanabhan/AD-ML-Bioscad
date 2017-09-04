function [acc] = categoricalPredictionAcc(pred, actual, threshold)

catPred = pred > threshold;
succPred = (catPred == actual);
acc = sum(succPred) / length(succPred);