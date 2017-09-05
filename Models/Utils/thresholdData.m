function [predThresh, actThresh] = thresholdData(pred, actual, threshold)

predThresh = double(pred > threshold);
actThresh = double(actual > threshold);