function [yPred] = elasticNetCoeffsPred(coeffs, xIn, maxSCORAD)

% Predict the values using the coefficients
yPred = [ones(size(xIn, 1), 1), xIn] * coeffs;

% Replace values below 0
yPred = yPred .* (yPred > 0);

% Replace values above max SCORAD
yPred = replaceHighValues(yPred, maxSCORAD);