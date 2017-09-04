function [contData] = extractContinuousData(preprocessedData)

contDataStartCol = 19;
[~, p] = size(preprocessedData);
contData = preprocessedData(:, contDataStartCol:p);
