function [output] = genRegPred(coeffs, input, maxPrediction)

% Predict the outputs based on a model and the inputs

% Predict results using model
[n, ~] = size(input);
output = [ones(n,1), input] * coeffs;

% Remove high and low values from prediction
output = output .* (output > 0);
output = replaceHighValues(output, maxPrediction);
