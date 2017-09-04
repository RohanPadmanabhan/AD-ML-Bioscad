function [output, coeffs] = genRegPred(model, input, maxSCORAD)

% Predict the outputs based on a model and the inputs

% Predict results using model
coeffs = model.Coefficients.Estimate;
[n, ~] = size(input);
output = [ones(n,1), input] * coeffs;

% Remove high and low values from prediction
output = output .* (output > 0);
output = replaceHighValues(output, maxSCORAD);
