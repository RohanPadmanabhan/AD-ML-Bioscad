function [percentage] = proportionSuccessful(actual, predictions, allowedDiff)

% Calculates the proportion of successful predictions

% Input 1 : The actual results
% Input 2 : The predicted data
% Input 3 : The maximum allowable difference

% Output 1 : The proportion of values that had less than the allowable
%            difference

successes = abs(actual - predictions) < allowedDiff;
percentage = sum(successes) / length(successes); 
