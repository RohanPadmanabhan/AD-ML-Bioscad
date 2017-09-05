function [predThresh] = thresholdData(pred, threshold)

predThresh = double(pred >= threshold);
